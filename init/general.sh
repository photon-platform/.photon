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
h1 "libnotify-bin"
echo
sudo apt install -y libnotify-bin

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

echo
h1 "xmlstarlet"
echo
sudo apt install -y xmlstarlet

echo
h1 "tidy"
echo
sudo apt install -y tidy

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
sudo pip install --upgrade youtube-dl

echo
h1 "wmctrl"
echo
sudo apt install -y wmctrl

echo
h1 "highlight"
echo
sudo apt install -y highlight

echo
h1 "neofetch"
echo
sudo apt install -y neofetch

echo
h1 "trash-cli"
echo
sudo apt install -y trash-cli

echo
h1 "tesseract-ocr"
echo
sudo apt install -y tesseract-ocr
    
echo
h1 "indicator-multiload"
echo
sudo apt install -y indicator-multiload


echo
h1 "calibre ebook"
echo
sudo -v && wget -nv -O- https://download.calibre-ebook.com/linux-installer.sh | sudo sh /dev/stdin

echo
h1 "Qt5"
echo
sudo apt install -y qtbase5-dev qttools5-dev qttools5-dev-tools qtwebengine5-dev

echo
h1 "python accessories"
echo
sudo apt install -y python3-dev python3-pip python3-lxml python3-six python3-css-parser python3-dulwich
sudo apt install -y python3-tk python3-pyqt5 python3-pyqtwebengine python3-html5lib python3-regex python3-pillow python3-cssselect python3-chardet

# sudo apt install -y silversearcher-ag
# sudo apt install -y fd-find
# sudo snap install  jq
# sudo snap install  yq
