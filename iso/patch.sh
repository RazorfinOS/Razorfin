#!/usr/bin/env bash
set -xeuo pipefail

dnf install -y \
	epel-release

dnf install -y \
	lorax

curl \
	--retry 3 \
	-o out/upstream.iso \
	https://repo.almalinux.org/almalinux/10/isos/${ARCH}/AlmaLinux-${VERSION}-latest-${ARCH}-boot.iso \

cp \
    /iso/heliumos.ks \
    /out/heliumos.ks
sed -i \
    "s,<URL>,${IMAGE}:${TAG},g" \
    /out/heliumos.ks


rm -rf \
	/out/images
mkdir -p \
	/out/images

rm -rf \
	/out/product
cp -r \
	/iso/product \
	/out/product

cd /out/product
sed -i \
    "s,<VERSION>,${VERSION},g" \
    /out/product/.buildstamp
if [ "${VARIANT}" = "canary" ]; then
	sed -i \
    	"s,<IS_FINAL>,False,g" \
    	/out/product/.buildstamp
else
	sed -i \
    	"s,<IS_FINAL>,True,g" \
    	/out/product/.buildstamp
fi

find . | cpio -c -o | gzip -9cv > \
	/out/images/product.img

rm -rf \
	/out/iso
cp -r \
	/iso/EFI \
	/out/EFI
sed -i \
    "s,<VERSION>,${VERSION},g" \
    /out/EFI/BOOT/grub.cfg

cd /out
rm -f \
    /out/HeliumOS-${VERSION}-${ARCH}-boot.iso
mkksiso \
	-a images \
	-a EFI \
	-V heliumos-${VERSION}-boot \
	--replace "HeliumOS ${VERSION}" \
    --ks /out/heliumos.ks \
	/out/upstream.iso \
	/out/HeliumOS-${VERSION}-${ARCH}-boot.iso
