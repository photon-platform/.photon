#!/usr/bin/env bash

# source ~/.photon/init/_utils.sh

title "general utilities"
if $PAUSE; then pause_enter; fi

SECTION_TIME="$(date -u +%s)"

sub "ranger"
sudo apt install -y ranger
ranger --version | tee -a $LOG

sub "tree"
sudo apt install -y tree
tree --version | tee -a $LOG

sub "highlight"
sudo apt install -y highlight
highlight --version | tee -a $LOG

sub "xclip"
sudo apt install -y xclip
xclip -version | tee -a $LOG

sub "bat"
sudo apt install -y bat
mkdir -p ~/.local/bin
ln -s /usr/bin/batcat ~/.local/bin/bat
bat --version | tee -a $LOG

sub "screenkey"
sudo apt install -y screenkey
screenkey --version | tee -a $LOG

# sub "xmlstarlet"
# sudo apt install -y xmlstarlet

# sub "tidy"
# sudo apt install -y tidy

sub "ncal"
sudo apt install -y ncal
ncal --version | tee -a $LOG

# sub "newsboat"
# sudo apt install -y newsboat

# sub "wmctrl"
# sudo apt install -y wmctrl

sub "neofetch"
sudo apt install -y neofetch
neofetch --version | tee -a $LOG

# use gio trash
# sub "trash-cli"
# sudo apt install -y trash-cli
# trash --version | tee -a $LOG

# sub "tesseract-ocr"
# sudo apt install -y tesseract-ocr
    
# sub "indicator-multiload"
# sudo apt install -y indicator-multiload

# sub "fdupes"
# sudo apt install -y fdupes
# sudo apt install -y silversearcher-ag
# sudo apt install -y fd-find
# sudo snap install  jq
# sudo snap install  yq

sub "general utilities complete"
elapsed_time $SECTION_TIME | tee -a $LOG
