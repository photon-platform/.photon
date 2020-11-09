#!/usr/bin/env bash

source ~/.photon/ui/_main.sh

clear -x
ui_banner "neomutt"

echo
h1 "isync"
echo
sudo apt install -y isync

echo
h1 "pass"
echo
sudo apt install -y pass

echo
h1 "mpack"
echo
sudo apt install -y mpack

echo
h1 "neomutt"
echo
sudo apt install -y neomutt

# TODO: make mutt-wizard a submodule of photon
# echo
# h1 "mutt-wizard"
# echo
# git clone https://github.com/LukeSmithxyz/mutt-wizard
# cd mutt-wizard
# sudo make install

