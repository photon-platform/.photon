#!/usr/bin/env bash

source ~/.photon/ui/_main.sh

clear -x
ui_banner "node"

echo
h1 "node"
echo
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
sudo apt-get install -y nodejs

echo
h1 "npm"
echo
sudo apt install -y npm
