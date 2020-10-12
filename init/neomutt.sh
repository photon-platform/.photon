#!/usr/bin/env bash

sudo apt install -y isync
sudo apt install -y pass
sudo apt install -y neomutt

git clone https://github.com/LukeSmithxyz/mutt-wizard
cd mutt-wizard
sudo make install

sudo apt install -y mpack
