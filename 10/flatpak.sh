#!/usr/bin/env sh


set -xeuo pipefail


dnf install -y \
    flatpak


mkdir -p \
    /etc/flatpak/remotes.d

curl \
    -o /etc/flatpak/remotes.d/flathub.flatpakrepo \
    https://dl.flathub.org/repo/flathub.flatpakrepo