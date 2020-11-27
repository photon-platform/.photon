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
h1 "bat"
echo
sudo apt install -y bat
mkdir -p ~/.local/bin
ln -s /usr/bin/batcat ~/.local/bin/bat

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
h1 "ncal"
echo
sudo apt install -y ncal

echo
h1 "newsboat"
echo
sudo apt install -y newsboat

echo
h1 "youtube-dl"
echo
sudo pip install --upgrade youtube_dl

echo
h1 "wmctrl"
echo
sudo apt install -y wmctrl

echo
h1 "highlight"
echo
sudo apt install -y highlight


# sudo apt install -y silversearcher-ag
# sudo apt install -y fd-find
# sudo snap install  jq
# sudo snap install  yq
