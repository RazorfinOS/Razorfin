SUDO=sudo
PODMAN = podman
IMAGE = quay.io/heliumos/bootc
VARIANT = canary
VERSION = 10
ARCH = x86_64

ifeq ($(VARIANT),canary)
	TAG = $(VERSION)-$(VARIANT)
else
	TAG = $(VERSION)
endif

.PHONY: image push iso

image:
	$(PODMAN) build \
		-f $(VERSION)/Containerfile \
		-t $(IMAGE):$(TAG) \
		.

push:
	$(PODMAN) push \
		$(IMAGE):$(TAG)

iso:
	mkdir -p out
	
	$(SUDO) $(PODMAN) run \
		--privileged \
		--rm \
		-it \
		-v ./out:/out:z \
		-v ./iso:/iso:z \
		-e IMAGE=$(IMAGE) \
		-e VARIANT=$(VARIANT) \
		-e VERSION=$(VERSION) \
		-e ARCH=$(ARCH) \
		-e TAG=$(TAG) \
		quay.io/almalinuxorg/almalinux:10 \
		/iso/patch.sh
