#!/usr/bin/env sh


set -e


dnf install -y \
    git \
    angelfish


dnf install -y \
    distrobox


# Appimage
dnf install -y \
    fuse


#dnf install -y \
#    docker-ce \
#    docker-ce-cli \
#    containerd.io \
#    docker-buildx-plugin \
#    docker-compose-plugin

export DOCKER_VERSION=27.3.1

wget https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKER_VERSION}.tgz && \
    tar -xzf docker-${DOCKER_VERSION}.tgz && \
    cp docker/* /usr/bin/

wget https://download.docker.com/linux/static/stable/x86_64/docker-rootless-extras-${DOCKER_VERSION}.tgz && \
    tar -xzf docker-rootless-extras-${DOCKER_VERSION}.tgz && \
    cp docker-rootless-extras/* /usr/bin/

    
#dnf install -y \
#    https://kojipkgs.fedoraproject.org//packages/bootc-gtk/0.3/1.el9/noarch/bootc-gtk-0.3-1.el9.noarch.rpm

