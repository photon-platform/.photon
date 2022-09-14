#!/usr/bin/env bash

# source ~/.photon/init/_utils.sh

title "configure git"
git --version | tee -a  $LOG
if $PAUSE; then pause_enter; fi

SECTION_TIME="$(date -u +%s)"

sub "set account"
username=$(ask_value 'git user name' 'phiarchitect')
useremail=$(ask_value 'git user email' 'phi@phiarchitect.com')
# read -p "git user name: " username
# read -p "git user email: " useremail
echo 

git config --global user.name $username
git config --global user.email $useremail

# set git to use credential memory cache
git config --global credential.helper cache
git config --global credential.helper 'cache --timeout=10000000'

git config --global pull.rebase false  # merge (the default strategy)

git config --global init.defaultBranch main

## git new keygen (if ncessary)
mkdir -p ~/.ssh
cd ~/.ssh
key_file="id_ed25519"

sub "generate key files"
ssh-keygen -t ed25519 -C "$useremail" -f "$key_file"

# start agent
sub "add key"
eval "$(ssh-agent -s)"
# add key to agent for single signon
ssh-add $key_file

sub "Copy Public Key to GitHub"
echo
echo paste contents into GitHub SSH public key form
echo https://github.com/settings/keys
echo
echo "$key_file.pub"
cat "$key_file.pub"
xclip -i "$key_file.pub" -selection clipboard
open "https://github.com/settings/keys" > /dev/null 2> /dev/null &

echo
pause_enter

sub "test connection"
ssh -T git@github.com

sub "git settings complete"
elapsed_time $SECTION_TIME | tee -a $LOG
pause_enter


