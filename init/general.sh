#!/usr/bin/env bash

source ~/.photon/ui/_main.sh

clear -x
ui_banner "general utilities"

#TODO: ranger - set config files
echo
h1 "ranger"
echo
sudo apt install -y ranger

echo
h1 "fzf"
echo
sudo apt install -y fzf

echo
h1 "entr"
echo
sudo apt install -y entr

echo
h1 "tree"
echo
sudo apt install -y tree

echo
h1 "rename"
echo
sudo apt install -y rename

echo
h1 "sendmail-bin"
echo
sudo apt install -y sendmail-bin

echo
h1 "screenkey"
echo
sudo apt install -y screenkey

# echo
# h1 "python-appindicator"
# echo
# sudo apt install -y python-appindicator

echo
h1 "xmlstarlet"
echo
sudo apt install -y xmlstarlet

echo
h1 "pandoc"
echo
sudo apt install -y pandoc pandoc-citeproc

echo
h1 "newsboat"
echo
sudo apt install -y newsboat


# sudo apt install -y silversearcher-ag
# sudo apt install -y fd-find
# sudo snap install  jq
# sudo snap install  yq
