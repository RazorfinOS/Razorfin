#!/usr/bin/env sh


set -xeuo pipefail


dnf install -y \
    epel-release


dnf config-manager --set-enabled \
    crb


dnf config-manager --save \
    --setopt=exclude=PackageKit,PackageKit-command-not-found,rootfiles,firefox
