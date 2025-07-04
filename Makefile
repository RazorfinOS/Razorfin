SUDO=sudo
PODMAN = $(SUDO) podman
IMAGE = quay.io/heliumos/bootc
VARIANT = canary
VERSION = 10
ARCH = x86_64

ifeq ($(VARIANT),canary)
	TAG = $(VERSION)-$(VARIANT)
else
	TAG = $(VERSION)
endif

.PHONY: echo-image echo-tag image push iso

echo-image:
	@echo $(IMAGE)

echo-tag:
	@echo $(TAG)

image:
	$(PODMAN) build \
		-f $(VERSION)/Containerfile \
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
		quay.io/centos-bootc/bootc-image-builder:latest \
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
		&& rm -f /output/HeliumOS-${VERSION}-${ARCH}-boot.iso \
		&& cd /iso/product && find . | cpio -c -o | gzip -9cv > /images/product.img && cd / \
		&& mkksiso \
			--add /images \
			--volid heliumos-${VERSION}-boot \
			--replace "vmlinuz" "vmlinuz inst.resolution=1280x800" \
			/output/bootiso/install.iso \
			/output/HeliumOS-${VERSION}-${ARCH}-boot.iso'
