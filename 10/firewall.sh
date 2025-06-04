#!/usr/bin/env sh


set -xeuo pipefail


dnf install -y \
    firewall-config


sed -i \
	's,DefaultZone=public,DefaultZone=HeliumOS,g' \
	/etc/firewalld/firewalld.conf
