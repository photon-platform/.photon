#!/usr/bin/env bash

sudo dpkg --add-architecture i386

wget -nc https://dl.winehq.org/wine-builds/winehq.key
sudo apt-key add winehq.key
rm winehq.key

# Ubuntu 21.04 	
sudo add-apt-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ hirsute main' 
sudo apt update
sudo apt install -y --install-recommends winehq-stable
