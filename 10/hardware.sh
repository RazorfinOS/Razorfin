#!/usr/bin/env sh


set -xeuo pipefail


dnf install -y \
    steam-devices


dnf install -y \
    kmod-nvidia-open


kver=$(cd /usr/lib/modules && echo * | awk '{print $1}')

dracut -vf /usr/lib/modules/$kver/initramfs.img $kver
