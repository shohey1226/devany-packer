#!/bin/bash

apt-get update

apt-get install -y software-properties-common
add-apt-repository ppa:tsl0922/ttyd-dev -y
apt-get update
apt-get install -y ttyd

apt-get install -y apache2 apache2-utils
a2enmod dav dav_fs proxy rewrite proxy_http proxy_wstunnel
a2dissite 000-default

sed -i -e 's_80_8888_g' /etc/apache2/ports.conf

apt-get install -y --no-install-recommends build-essential libreadline-dev ca-certificates curl git libssl-dev tmux vim-nox emacs-nox make less iputils-ping net-tools wget dnsutils locales sudo file python-setuptools libsqlite3-dev g++ curl libssl-dev apache2-utils git libxml2-dev sshfs supervisor sysv-rc-conf

locale-gen en_US.UTF-8
sysv-rc-conf apache2 off
/etc/init.d/apache2 stop
