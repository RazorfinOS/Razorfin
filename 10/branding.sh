#!/usr/bin/env sh


set -e


mkdir -p /etc/xdg && \
    touch /etc/xdg/system.kdeglobals


sed -i 's,https://centos.org/,https://www.heliumos.org/,g' /usr/lib/os-release && \
    sed -i 's,https://issues.redhat.com/,https://bugs.heliumos.org/,g' /usr/lib/os-release && \
    sed -i 's,LOGO="fedora-logo-icon",LOGO="heliumos-logo-icon",g' /usr/lib/os-release && \
    sed -i 's,10 (Coughlan),10,g' /usr/lib/os-release && \
    sed -i 's,ID="centos",ID="heliumos",g' /usr/lib/os-release && \
    sed -i 's,REDHAT_SUPPORT_PRODUCT="Red Hat Enterprise Linux 10",,g' /usr/lib/os-release && \
    sed -i 's,REDHAT_SUPPORT_PRODUCT_VERSION="CentOS Stream",,g' /usr/lib/os-release && \
    sed -i 's,CentOS Stream,HeliumOS,g' /usr/lib/os-release && \
    sed -i 's,centos,heliumos,g' /usr/lib/os-release && \
    sed -i 's,ID_LIKE="rhel fedora",ID_LIKE="rhel centos fedora",g' /usr/lib/os-release && \
    sed -i 's,VENDOR_NAME="CentOS",VENDOR_NAME="HeliumOS",g' /usr/lib/os-release


curl -o logo.tar.gz https://codeberg.org/HeliumOS/logo/archive/0ce8b5cd8f6d311924d84c9a9f4961da95306171.tar.gz && \
    tar -xzf logo.tar.gz && \
	mv logo/export/logo/logo-color.svg /usr/share/icons/hicolor/scalable/apps/heliumos-logo-icon.svg && \
	mv logo/export/logo/logo.svg /usr/share/icons/hicolor/scalable/apps/heliumos-logo-icon-white.svg && \
	mv logo/export/logo/logo-color-256x256.png /usr/share/icons/hicolor/256x256/apps/heliumos-logo-icon.png && \
	mv logo/export/logo/logo-color-64x64.png /usr/share/icons/hicolor/64x64/apps/heliumos-logo-icon.png && \
	ln -sf /usr/share/icons/hicolor/scalable/apps/heliumos-logo-icon.svg /usr/share/icons/hicolor/scalable/apps/start-here.svg && \
	ln -sf /usr/share/icons/hicolor/scalable/apps/heliumos-logo-icon.svg /usr/share/icons/hicolor/scalable/apps/xfce4_xicon1.svg && \
	ln -sf /usr/share/icons/hicolor/scalable/apps/heliumos-logo-icon.svg /usr/share/pixmaps/fedora-logo-sprite.svg && \
	ln -sf /usr/share/icons/hicolor/256x256/apps/heliumos-logo-icon.png /usr/share/pixmaps/fedora-logo-sprite.png && \
	ln -sf /usr/share/icons/hicolor/256x256/apps/heliumos-logo-icon.png /usr/share/pixmaps/fedora-logo.png && \
	ln -sf /usr/share/icons/hicolor/64x64/apps/heliumos-logo-icon.png /usr/share/pixmaps/fedora-gdm-logo.png && \
	ln -sf /usr/share/icons/hicolor/64x64/apps/heliumos-logo-icon.png /usr/share/pixmaps/fedora-logo-small.png && \


curl -o wallpapers.tar.gz https://codeberg.org/HeliumOS/wallpapers/archive/eccec97df37d4d5aee4f23e1e57b46c0e4e6c484.tar.gz && \
    tar -xzf wallpapers.tar.gz && \
    mkdir -p /usr/share/backgrounds/heliumos && \
    cp /workdir/wallpapers/*.jpg /usr/share/backgrounds/heliumos
