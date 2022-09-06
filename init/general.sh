#!/usr/bin/env bash

# source ~/.photon/init/_utils.sh

title "general utilities"
if $PAUSE; then pause_enter; fi

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

# h1 "xmlstarlet"
# sudo apt install -y xmlstarlet

# h1 "tidy"
# sudo apt install -y tidy

h1 "ncal"
sudo apt install -y ncal
ncal --version | tee -a $LOG

# h1 "newsboat"
# sudo apt install -y newsboat

# h1 "wmctrl"
# sudo apt install -y wmctrl

h1 "neofetch"
sudo apt install -y neofetch

h1 "trash-cli"
sudo apt install -y trash-cli

# h1 "tesseract-ocr"
# sudo apt install -y tesseract-ocr
    
# h1 "indicator-multiload"
# sudo apt install -y indicator-multiload

# h1 "fdupes"
# sudo apt install -y fdupes
# sudo apt install -y silversearcher-ag
# sudo apt install -y fd-find
# sudo snap install  jq
# sudo snap install  yq

h1 "general utilities complete"
