#!/usr/bin/env bash

source ~/.photon/ui/_main.sh

clear -x
ui_banner "nextcloud client"

echo
h1 "load ppa"
echo
sudo add-apt-repository ppa:nextcloud-devs/client
sudo apt update -y

echo
h1 "install nextcloud cloud"
echo
sudo apt install -y nextcloud-client
