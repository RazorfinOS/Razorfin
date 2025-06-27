#!/usr/bin/env sh


set -xeuo pipefail


dnf install -y \
    steam-devices

dnf install -y \
    https://build.almalinux.org/pulp/content/builds/AlmaLinux-Kitten-10-x86_64-39017-br/Packages/k/kmod-nvidia-open-575.64-1.el10.x86_64.rpm \
    https://build.almalinux.org/pulp/content/builds/AlmaLinux-Kitten-10-x86_64-39017-br/Packages/n/nvidia-open-kmod-575.64-1.el10.x86_64.rpm
    # nvidia-open-kmod

kver=$(cd /usr/lib/modules && echo * | awk '{print $1}')

dracut -vf /usr/lib/modules/$kver/initramfs.img $kver
