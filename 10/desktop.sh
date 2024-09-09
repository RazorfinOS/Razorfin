#!/usr/bin/env bash


set -e


#dnf install -y --nobest \
#   @kde-desktop-environment


dnf remove -y \
    setroubleshoot \
    cockpit


#systemctl enable \
#    sddm.service


rm -rdf /var/run
