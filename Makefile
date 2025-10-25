SUDO := sudo
PODMAN := podman
IMAGE := ghcr.io/razorfinos-org/razorfin
IS_CANARY := true
IS_EDGE := false
VERSION := 1
ARCH := x86_64

# VM image defaults
SIZE ?= 100G
FORMAT ?= qcow2
FILESYSTEM ?= ext4

TAG := $(VERSION)
ifeq ($(IS_CANARY),true)
	TAG := $(TAG)-canary
endif
ifeq ($(IS_EDGE),true)
	TAG := $(TAG)-edge
endif

PLAYBOOK := $(VERSION)
ifeq ($(IS_EDGE),true)
	PLAYBOOK := $(PLAYBOOK)-edge
endif

.PHONY: echo-image echo-tag image push iso

echo-image:
	@echo $(IMAGE)

echo-tag:
	@echo $(TAG)

image:
	$(PODMAN) build \
		--build-arg PLAYBOOK=$(PLAYBOOK).yaml \
		--network host \
		--security-opt label=disable \
		-f Containerfile \
		-t $(IMAGE):$(TAG) \
		.

rechunk:
	$(SUDO) IMAGE=$(IMAGE):$(TAG) ./rechunk.sh

push:
	$(PODMAN) push \
		$(IMAGE):$(TAG)

iso:
	$(SUDO) rm -rf ./out
	mkdir ./out

	cp \
		./iso/config.toml \
		./out/config.toml
	sed -i \
    "s,<URL>,$(IMAGE):$(TAG),g" \
    ./out/config.toml

	$(PODMAN) pull \
		$(IMAGE):$(TAG)

	$(PODMAN) run \
		--rm \
		-it \
		--privileged \
		--pull=newer \
		--security-opt label=type:unconfined_t \
		-v ./out/config.toml:/config.toml:ro \
		-v ./out:/output \
		-v /var/lib/containers/storage:/var/lib/containers/storage \
		quay.io/centos-bootc/bootc-image-builder:sha256-12b08293b340613061e81414b67e1dbf76a47f8f9c631f94f27e4da99dfe757d \
		--type anaconda-iso \
		--use-librepo=False \
		$(IMAGE):$(TAG)

	$(PODMAN) run \
		--rm \
		-it \
		--pull=newer \
		--privileged \
		-v ./out:/output \
		-v ./iso:/iso \
		quay.io/almalinuxorg/almalinux:10-kitten \
		bash -c '\
			dnf install -y lorax \
		&& rm -rf /images && mkdir /images \
		&& rm -f /output/RazorfinOS-${VERSION}-${ARCH}-boot.iso \
		&& cd /iso/product && find . | cpio -c -o | gzip -9cv > /images/product.img && cd / \
		&& mkksiso \
			--add /images \
			--volid razorfinos-${VERSION}-boot \
			--replace "vmlinuz" "vmlinuz inst.resolution=1280x800" \
			/output/bootiso/install.iso \
			/output/RazorfinOS-${VERSION}-${ARCH}-boot.iso'

install-to-disk:
	@echo "Installing RazorfinOS to disk/device: $(DEVICE)"
	@if [ -z "$(DEVICE)" ]; then \
		echo "Error: DEVICE parameter required. Usage: make install-to-disk DEVICE=/dev/sdX"; \
		exit 1; \
	fi
	@echo "WARNING: This will DESTROY all data on $(DEVICE)"
	@read -p "Are you sure you want to continue? (yes/no): " confirm && [ "$$confirm" = "yes" ]
	@echo "Ensuring image is available in user's container storage..."
	$(PODMAN) pull $(IMAGE):$(TAG) || echo "Pull failed, checking if image exists locally..."
	@if ! $(PODMAN) image exists $(IMAGE):$(TAG); then \
		echo "Error: Image $(IMAGE):$(TAG) not found. Please pull it manually or login to the registry."; \
		exit 1; \
	fi
	@echo "Exporting container image to OCI directory..."
	$(SUDO) rm -rf /tmp/bootc-install-image
	$(SUDO) skopeo copy containers-storage:$(IMAGE):$(TAG) oci:/tmp/bootc-install-image
	@echo "Installing RazorfinOS to $(DEVICE) using host bootc..."
	$(SUDO) bootc install to-disk \
		--source-imgref oci:/tmp/bootc-install-image \
		--filesystem $(FILESYSTEM) \
		--wipe \
		$(DEVICE)
	@echo "Cleaning up..."
	$(SUDO) rm -rf /tmp/bootc-install-image
	@echo "Installation complete!"

create-vm-image:
	@echo "Creating $(SIZE) VM image: ./out/RazorfinOS-$(VERSION)-$(ARCH).$(FORMAT)"
	$(SUDO) rm -rf ./out
	mkdir -p ./out
	@echo "Creating disk image file..."
	@if [ "$(FORMAT)" = "qcow2" ]; then \
		qemu-img create -f qcow2 ./out/RazorfinOS-$(VERSION)-$(ARCH).qcow2 $(SIZE); \
		echo "Converting to raw format for installation..."; \
		qemu-img convert -f qcow2 -O raw ./out/RazorfinOS-$(VERSION)-$(ARCH).qcow2 ./out/RazorfinOS-$(VERSION)-$(ARCH).raw; \
		echo "Exporting container image using skopeo..."; \
		$(SUDO) rm -rf /tmp/bootc-image-dir; \
		$(SUDO) skopeo copy containers-storage:$(IMAGE):$(TAG) dir:/tmp/bootc-image-dir; \
		echo "Setting up loop device..."; \
		LOOP_DEVICE=$$($(SUDO) losetup --find --show --partscan ./out/RazorfinOS-$(VERSION)-$(ARCH).raw); \
		echo "Loop device: $$LOOP_DEVICE"; \
		echo "Installing RazorfinOS to loop device..."; \
		$(SUDO) podman run \
			--rm --privileged \
			--pid=host \
			--network=host \
			-v /dev:/dev \
			-v /tmp:/tmp \
			-v /run:/run \
			--tmpfs /var/tmp:rw,exec,size=10g \
			--security-opt label=disable \
			--security-opt unmask=ALL \
			$(IMAGE):$(TAG) \
			bootc install to-disk --source-imgref dir:/tmp/bootc-image-dir --filesystem $(FILESYSTEM) --wipe $$LOOP_DEVICE || (echo "ERROR: bootc install failed!" && $(SUDO) losetup -d $$LOOP_DEVICE && exit 1); \
		echo "Syncing..."; \
		sync; \
		sleep 2; \
		echo "Detaching loop device..."; \
		$(SUDO) losetup -d $$LOOP_DEVICE; \
		echo "Converting back to qcow2 format..."; \
		qemu-img convert -f raw -O qcow2 -c ./out/RazorfinOS-$(VERSION)-$(ARCH).raw ./out/RazorfinOS-$(VERSION)-$(ARCH).qcow2; \
		rm -f ./out/RazorfinOS-$(VERSION)-$(ARCH).raw; \
		$(SUDO) rm -rf /tmp/bootc-image-dir; \
	fi
	@echo "VM image created successfully: ./out/RazorfinOS-$(VERSION)-$(ARCH).$(FORMAT)"
boot-vm:
	@if [ ! -f "./out/RazorfinOS-$(VERSION)-$(ARCH).$(FORMAT)" ]; then \
		echo "Error: VM image not found. Run 'make create-vm-image' first."; \
		exit 1; \
	fi
	@if [ ! -f "./OVMF_VARS.fd" ]; then \
		echo "Creating OVMF_VARS.fd..."; \
		cp /usr/share/OVMF/OVMF_VARS.fd ./OVMF_VARS.fd; \
	fi
	@echo "Booting RazorfinOS VM image..."
	qemu-system-x86_64 \
		-m 8G \
		-cpu host \
		-enable-kvm \
		-drive file=./out/RazorfinOS-$(VERSION)-$(ARCH).$(FORMAT),format=$(FORMAT),if=virtio \
		-drive if=pflash,format=raw,readonly=on,file=/usr/share/OVMF/OVMF_CODE.fd \
		-drive if=pflash,format=raw,file=./OVMF_VARS.fd \
		-device virtio-vga-gl \
		-display sdl,gl=on \
		-netdev user,id=net0 \
		-device virtio-net-pci,netdev=net0

help:
	@echo "RazorfinOS Build System"
	@echo ""
	@echo "Available targets:"
	@echo "  image           - Build container image"
	@echo "  push            - Push container image to registry"
	@echo "  iso             - Create installation ISO (requires dnf, may not work on Arch)"
	@echo "  install-to-disk - Install directly to disk/USB (DEVICE=/dev/sdX)"
	@echo "  create-vm-image - Create VM disk image using bootc via-loopback (SIZE=20G FORMAT=qcow2)"
	@echo "  boot-vm         - Boot the created VM image with QEMU"
	@echo "  rechunk         - Rechunk container image"
	@echo "  clean           - Clean build artifacts"
	@echo ""
	@echo "VM Image Options:"
	@echo "  SIZE=<size>       - Image size (default: 20G, examples: 10G, 50G)"
	@echo "  FORMAT=<format>   - Image format (default: qcow2, options: qcow2, raw)"
	@echo "  FILESYSTEM=<fs>   - Filesystem type (default: ext4, options: ext4, btrfs, xfs)"
	@echo ""
	@echo "Examples:"
	@echo "  make image VARIANT=stable"
	@echo "  make install-to-disk DEVICE=/dev/sdb"
	@echo "  make create-vm-image SIZE=20G FORMAT=qcow2 VARIANT=stable"
	@echo "  make create-vm-image SIZE=10G FORMAT=raw FILESYSTEM=btrfs"
	@echo "  make boot-vm"
