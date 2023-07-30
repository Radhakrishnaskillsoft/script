#!/bin/sh
apt install curl apt-transport-https gnupg

apt install locales
locale-gen en_US.UTF-8
echo "LANG=en_US.UTF-8" > /etc/default/locale

echo "deb [signed-by=/etc/apt/trusted.gpg.d/pkgr-zammad.gpg] https://dl.packager.io/srv/deb/zammad/zammad/stable/ubuntu 22.04 main"| \
   tee /etc/apt/sources.list.d/zammad.list > /dev/null

apt update
apt install zammad
