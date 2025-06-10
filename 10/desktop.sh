#!/usr/bin/env bash


set -xeuo pipefail


dnf install -y \
	@"KDE Plasma Workspaces" \
    angelfish \
    kcalc \
    kmines \
    kolourpaint \
    krdp \
    kreversi \
    okular 


dnf remove -y \
    setroubleshoot \
    cockpit \
    krfb


rm -rf \
    /usr/share/plasma/look-and-feel/org.fedoraproject.fedora.desktop
rm -rf \
    /usr/share/wallpapers/fedora
rm -rf \
    /usr/share/backgrounds/*


systemctl enable \
    sddm.service


rm -rf \
    /var/run
