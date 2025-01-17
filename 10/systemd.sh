#!/usr/bin/env sh


set -e

rm /etc/profile.d/console-login-helper-messages-profile.sh

systemctl disable atd.service
systemctl disable rpm-ostree-countme.service

systemctl mask hibernate.target
