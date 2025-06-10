#!/usr/bin/env sh

set -xeuo pipefail

dnf install -y \
    git \
    distrobox \
    @development


dnf install -y \
    fuse
