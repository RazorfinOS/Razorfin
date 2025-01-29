#!/usr/bin/env bash


set -e


dnf install -y --nobest \
	@"KDE Plasma Workspaces"


dnf remove -y \
    setroubleshoot \
    cockpit \
    krfb


rm -rf /usr/share/plasma/look-and-feel/org.fedoraproject.fedora.desktop
rm -rf /usr/share/wallpapers/fedora
rm -rf /usr/share/backgrounds/*


systemctl enable \
    sddm.service


rm -rdf /var/run
