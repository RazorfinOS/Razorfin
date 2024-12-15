#!/usr/bin/env sh


set -e


dnf install -y selinux-policy-40.13.13-1.el10


sed -i 's,ExecStart=/usr/bin/bootc update --apply --quiet,ExecStart=/usr/bin/bootc update --quiet,g' \
    /usr/lib/systemd/system/bootc-fetch-apply-updates.service


mv /opt /var/opt && \
  ln -s /var/opt /opt


mv /usr/local /var/usrlocal && \
  ln -s /var/usrlocal /usr/local


systemctl disable atd.service

