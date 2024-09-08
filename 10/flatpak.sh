#!/usr/bin/env sh


set -e


dnf install -y \
    flatpak-builder


mkdir /var/roothome


curl -O https://codeberg.org/HeliumOS/flatpak-readonlyroot/raw/tag/v0.2/flatpak-readonlyroot.py


python3 flatpak-readonlyroot.py --name=heliumos flatpak.toml


rm -rdf /var/roothome
