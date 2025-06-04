#!/usr/bin/env sh


set -xeuo pipefail


dnf install -y \
    angelfish \
    kolourpaint \
    kcalc \
    okular 


dnf install -y \
    git \
    distrobox \
    @development


dnf install -y \
    fuse
