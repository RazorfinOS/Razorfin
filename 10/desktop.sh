#!/usr/bin/env bash


set -e


dnf install -y \
	@"KDE Plasma Workspaces"


dnf remove -y \
    setroubleshoot \
    cockpit


systemctl enable \
    sddm.service


rm -rdf /var/run
