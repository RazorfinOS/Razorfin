#!/usr/bin/env sh

set -xeuo pipefail

echo "UTC" >> /etc/adjtime

LIST=$(ls /usr/lib/systemd/ntp-units.d/ | awk '{print $1}' | head -n 1)
systemctl enable \
    $(echo $(cat /usr/lib/systemd/ntp-units.d/${LIST}) | awk '{print $1}' | head -n 1)

# steam-devices

dnf install -y \
    https://dl.fedoraproject.org/pub/epel/10/Everything/x86_64/Packages/s/steam-devices-1.0.0.101^git20240522.e2971e4-2.el10_1.noarch.rpm
    

dnf install -y \
    nvidia-open-kmod

kver=$(cd /usr/lib/modules && echo * | awk '{print $1}')

dracut -vf /usr/lib/modules/$kver/initramfs.img $kver

