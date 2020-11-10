#!/usr/bin/env bash


source ~/.photon/ui/_main.sh

clear -x
ui_banner "git config"

echo
read -p "git user name: " username
read -p "git user email: " useremail
echo


# set account
git config --global user.name $username
git config --global user.email $useremail


# Set git to use the credential memory cache
git config --global credential.helper cache
# extend cache timeout
git config --global credential.helper 'cache --timeout=10000000'

git config --list

