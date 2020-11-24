#!/usr/bin/env bash


source ~/.photon/ui/_main.sh

clear -x
ui_banner "git"

echo
h1 "set account"
echo
read -p "git user name: " username
read -p "git user email: " useremail
echo 

git config --global user.name $username
git config --global user.email $useremail

# set git to use credential memory cache
git config --global credential.helper cache
git config --global credential.helper 'cache --timeout=10000000'

git config --global pull.rebase false  # merge (the default strategy)

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
