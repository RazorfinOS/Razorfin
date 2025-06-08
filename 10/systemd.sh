#!/usr/bin/env sh


set -xeuo pipefail

systemctl disable \
    atd.service

systemctl disable \
    rpm-ostree-countme.service

systemctl mask \
    hibernate.target

systemctl mask \
    hybrid-sleep.target

systemctl mask \
    suspend-then-hibernate.target
