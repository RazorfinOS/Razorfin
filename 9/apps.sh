#!/usr/bin/env sh


set -e


# https://codeberg.org/HeliumOS/bugs/issues/2
dnf install -y \
    https://repo.almalinux.org/almalinux/9/AppStream/x86_64/os/Packages/ocl-icd-2.2.13-4.el9.x86_64.rpm

# https://bugzilla.redhat.com/show_bug.cgi?id=2316533
dnf install -y \
    chromium \
    ocl-icd \
    git


dnf install -y \
    distrobox \
    podman-compose


dnf install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin

    
dnf install -y \
    https://dl.fedoraproject.org/pub/fedora/linux/development/rawhide/Everything/x86_64/os/Packages/b/bootc-gtk-0.3-1.fc42.noarch.rpm

