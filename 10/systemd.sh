#!/usr/bin/env sh


set -e

systemctl disable atd.service
systemctl disable rpm-ostree-countme.service

systemctl mask hibernate.target
