#!/usr/bin/env sh


set -e


dnf install -y \
    git \
    angelfish


dnf install -y \
    distrobox \
    @development


# Appimage
dnf install -y \
    fuse


#dnf install -y \
#    https://kojipkgs.fedoraproject.org//packages/bootc-gtk/0.3/1.el9/noarch/bootc-gtk-0.3-1.el9.noarch.rpm

