#!/usr/bin/env sh


set -e


dnf install -y \
    https://dl.fedoraproject.org/pub/epel/10/Everything/x86_64/os/Packages/e/epel-release-10-1.el10_0.noarch.rpm #epel-release


dnf config-manager --set-enabled \
    crb


dnf config-manager --save \
    --setopt=exclude=PackageKit,PackageKit-command-not-found,rootfiles,firefox,totem,gnome-tour


mkdir -p /etc/flatpak/remotes.d && \
    curl -o /etc/flatpak/remotes.d/flathub.flatpakrepo  https://dl.flathub.org/repo/flathub.flatpakrepo
