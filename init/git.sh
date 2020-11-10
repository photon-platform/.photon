#!/usr/bin/env bash


source ~/.photon/ui/_main.sh

clear -x
ui_banner "git"

echo
h1 "load ppa"
echo
sudo add-apt-repository -y ppa:git-core/ppa
sudo apt update

echo
h1 "install git"
echo
sudo apt install -y git
git --version
