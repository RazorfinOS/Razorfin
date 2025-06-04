#!/usr/bin/env sh


set -xeuo pipefail

systemctl disable \
    atd.service

systemctl disable \
    rpm-ostree-countme.service
