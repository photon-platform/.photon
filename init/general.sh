#!/usr/bin/env bash

# source ~/.photon/init/_utils.sh

title "general utilities"

#TODO: ranger - set config files
h1 "ranger"
sudo apt install -y ranger
ranger --version | tee -a $LOG

h1 "tree"
sudo apt install -y tree
tree --version | tee -a $LOG

h1 "highlight"
sudo apt install -y highlight
highlight --version | tee -a $LOG

h1 "bat"
sudo apt install -y bat
mkdir -p ~/.local/bin
ln -s /usr/bin/batcat ~/.local/bin/bat
bat --version | tee -a $LOG

h1 "screenkey"
sudo apt install -y screenkey
screenkey --version | tee -a $LOG

# echo
# h1 "xmlstarlet"
# echo
# sudo apt install -y xmlstarlet

# echo
# h1 "tidy"
# echo
# sudo apt install -y tidy

h1 "ncal"
sudo apt install -y ncal
ncal --version | tee -a $LOG

# echo
# h1 "newsboat"
# echo
# sudo apt install -y newsboat

# echo
# h1 "wmctrl"
# echo
# sudo apt install -y wmctrl

echo
h1 "neofetch"
echo
sudo apt install -y neofetch

echo
h1 "trash-cli"
echo
sudo apt install -y trash-cli

# echo
# h1 "tesseract-ocr"
# echo
# sudo apt install -y tesseract-ocr
    
# echo
# h1 "indicator-multiload"
# echo
# sudo apt install -y indicator-multiload

# echo
# h1 "fdupes"
# echo
# sudo apt install -y fdupes
# sudo apt install -y silversearcher-ag
# sudo apt install -y fd-find
# sudo snap install  jq
# sudo snap install  yq
