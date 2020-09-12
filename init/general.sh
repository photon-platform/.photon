#!/bin/sh

curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
sudo apt-get install -y nodejs

sudo apt install -y npm

sudo apt install -y entr

sudo apt install -y tree

sudo apt install -y rename

sudo apt install -y fzf

sudo apt install -y silversearcher-ag

sudo apt install -y fd-find

sudo apt install -y cmake #for YouCompleteMe

# sudo apt install -y nextcloud-client

sudo apt install -y sendmail-bin

sudo apt install -y ranger

sudo apt install -y nemo

sudo apt install -y tmux

sudo apt install -y screenkey
sudo apt install -y python-appindicator

#image viewers
sudo apt install -y fim
sudo apt install -y caca-utils

# Gogh theme for Terminal - with Gruvbox
# https://github.com/Mayccoll/Gogh
sudo apt-get install dconf-cli uuid-runtime
bash -c  "$(wget -qO- https://git.io/vQgMr)"

sudo snap install  jq
sudo snap install  yq

sudo apt install -y xmlstarlet

sudo apt install -y newsboat

sudo add-apt-repository ppa:nextcloud-devs/client
sudo apt-get update
sudo apt install nextcloud-client
