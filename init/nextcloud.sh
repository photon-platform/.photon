#!/usr/bin/env bash

source ~/.photon/ui/_main.sh

clear -x
ui_banner "nextcloud"

sudo add-apt-repository ppa:nextcloud-devs/client
sudo apt update -y
sudo apt install nextcloud-client
