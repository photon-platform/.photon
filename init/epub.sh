#!/usr/bin/env bash


echo
h1 "calibre ebook"
echo
sudo -v && wget -nv -O- https://download.calibre-ebook.com/linux-installer.sh | sudo sh /dev/stdin

