#!/usr/bin/env bash

set -xeou pipefail

# IMAGE=quay.io/heliumos/bootc:10-canary
echo ${IMAGE}
export RECHUNKER="ghcr.io/hhd-dev/rechunk:v1.2.2"

if [ "$(id -u)" != "0" ]; then
    podman unshare -- ./rechunk.sh
    exit $?
fi

export volume_name=cache_rechunk
export CREF=$(podman create ${IMAGE} bash)
export OUT_NAME=bootc.tar
export MOUNT="$(podman mount $CREF)"

podman pull --retry 3 ${RECHUNKER}

podman run --rm \
    --security-opt label=disable \
    --volume "$MOUNT":/var/tree \
    --env TREE=/var/tree \
    --user 0:0 \
    ${RECHUNKER} \
    /sources/rechunk/1_prune.sh

podman run --rm \
    --security-opt label=disable \
    --volume "$MOUNT":/var/tree \
    --volume "cache_ostree:/var/ostree" \
    --env TREE=/var/tree \
    --env REPO=/var/ostree/repo \
    --env RESET_TIMESTAMP=1 \
    --user 0:0 \
    ${RECHUNKER} \
    /sources/rechunk/2_create.sh

podman unmount "$CREF"
podman rm "$CREF"

mkdir -p ./"${volume_name}"/bootc

podman run --rm \
    --security-opt label=disable \
    --volume ./"${volume_name}":/workspace \
    --volume "$(dirname "$(realpath "$0")")":/var/git \
    --volume cache_ostree:/var/ostree \
    --env REPO=/var/ostree/repo \
    --env OUT_NAME="$OUT_NAME" \
    --env OUT_REF="oci-archive:$OUT_NAME" \
    --env GIT_DIR="/var/git" \
    --user 0:0 \
    ${RECHUNKER} \
    /sources/rechunk/3_chunk.sh

podman volume rm cache_ostree

export IMAGE_ID=$(podman load -i ${volume_name}/${OUT_NAME} 2> /dev/null | awk '{print $3}' | sed 's,sha256:,,g')
podman tag ${IMAGE_ID} ${IMAGE}

rm -rf ${volume_name}
