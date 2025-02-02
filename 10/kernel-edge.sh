#!/usr/bin/env bash

dnf install -y \
    wget \
    kernel-devel \
    kernel-headers \
    dkms \
    vulkan \
    vulkan-tools \
    vulkan-headers \
    vulkan-loader-devel

touch \
    /etc/modprobe.d/nouveau-blacklist.conf

echo "blacklist nouveau" | tee \
    /etc/modprobe.d/nouveau-blacklist.conf

echo "options nouveau modeset=0" | tee -a \
    /etc/modprobe.d/nouveau-blacklist.conf

dracut --force

wget \
    https://us.download.nvidia.com/XFree86/Linux-x86_64/550.144.03/NVIDIA-Linux-x86_64-550.144.03.run

chmod +x \
    NVIDIA-Linux-x86_64-550.144.03.run

./NVIDIA-Linux-x86_64-550.144.03.run \
    --silent --run-nvidia-xconfig --dkms \
    --kernel-source-path /usr/src/kernels/$(ls /usr/src/kernels/ | awk '{print $1}') \
    --kernel-module-build-directory=kernel-open/

dracut --force

