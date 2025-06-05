#!/usr/bin/env sh


set -xeuo pipefail


dnf install -y \
    epel-release \
    almalinux-release-nvidia-driver


dnf config-manager --save \
    --setopt=exclude=PackageKit,PackageKit-command-not-found,rootfiles,firefox
