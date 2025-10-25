#!/usr/bin/env sh


set -xeuo pipefail

sed -i 's,AlmaLinux,RazorfinOS,g' \
    /usr/lib/os-release
sed -i 's, (Purple Lion),,g' \
    /usr/lib/os-release
sed -i 's,ID="almalinux",ID="razorfinos",g' \
    /usr/lib/os-release
sed -i 's,rhel,almalinux rhel,g' \
    /usr/lib/os-release
sed -i 's,0;34,38;5;39,g' \
    /usr/lib/os-release
sed -i 's,cpe:/o:almalinux:almalinux:10::baseos,cpe:/o:razorfinos:razorfinos:1::baseos,g' \
    /usr/lib/os-release
sed -i 's,https://almalinux.org/,https://www.razorfinos.org/,g' \
    /usr/lib/os-release
sed -i 's,https://wiki.almalinux.org/,https://www.razorfinos.org/docs,g' \
    /usr/lib/os-release
sed -i 's,AlmaLinux,RazorfinOS,g' \
    /usr/lib/os-release
sed -i 's,https://bugs.almalinux.org/,https://bugs.razorfinos.org/,g' \
    /usr/lib/os-release
sed -i 's, Kitten,,g' \
    /usr/lib/os-release
sed -i 's, (Lion Cub),,g' \
    /usr/lib/os-release

curl \
    -o logo.tar.gz \
    https://codeberg.org/RazorfinOS/logo/archive/0ce8b5cd8f6d311924d84c9a9f4961da95306171.tar.gz
tar -xzf \
    logo.tar.gz
mv \
    logo/export/logo/logo-color.svg \
    /usr/share/icons/hicolor/scalable/apps/razorfinos-logo-icon.svg
mv \
    logo/export/logo/logo.svg \
    /usr/share/icons/hicolor/scalable/apps/razorfinos-logo-icon-white.svg
mv \
    logo/export/logo/logo-color-256x256.png \
    /usr/share/icons/hicolor/256x256/apps/razorfinos-logo-icon.png
mv \
    logo/export/logo/logo-color-64x64.png \
    /usr/share/icons/hicolor/64x64/apps/razorfinos-logo-icon.png
ln -sf \
    /usr/share/icons/hicolor/scalable/apps/razorfinos-logo-icon.svg \
    /usr/share/icons/hicolor/scalable/apps/start-here.svg
ln -sf \
    /usr/share/icons/hicolor/scalable/apps/razorfinos-logo-icon.svg \
    /usr/share/icons/hicolor/scalable/apps/xfce4_xicon1.svg
ln -sf \
    /usr/share/icons/hicolor/scalable/apps/razorfinos-logo-icon.svg \
    /usr/share/pixmaps/fedora-logo-sprite.svg
ln -sf \
    /usr/share/icons/hicolor/256x256/apps/razorfinos-logo-icon.png \
    /usr/share/pixmaps/fedora-logo-sprite.png
ln -sf \
    /usr/share/icons/hicolor/256x256/apps/razorfinos-logo-icon.png \
    /usr/share/pixmaps/fedora-logo.png
ln -sf \
    /usr/share/icons/hicolor/256x256/apps/razorfinos-logo-icon.png \
    /usr/share/pixmaps/system-logo-white.png
ln -sf \
    /usr/share/icons/hicolor/64x64/apps/razorfinos-logo-icon.png \
    /usr/share/pixmaps/fedora-gdm-logo.png
ln -sf \
    /usr/share/icons/hicolor/64x64/apps/razorfinos-logo-icon.png \
    /usr/share/pixmaps/fedora-logo-small.png

pacman -R --noconfirm \
    console-login-helper-messages || true

rm -rf \
    /var/run

rm /branding.sh
