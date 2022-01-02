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


## git new keygen (if ncessary)
mkdir -p ~/.ssh
cd ~/.ssh
key_file="id_ed25519"

h1 "generate key files"
echo
ssh-keygen -t ed25519 -C "$useremail" -f "$key_file"

# start agent
echo
h1 "add key"
echo
eval "$(ssh-agent -s)"
# add key to agent for single signon
ssh-add $key_file

# Copies the contents of the id_rsa.pub file to your clipboard - paste to github settings
# sudo apt install xclip
# xclip -sel clip < $key_file.pub

echo
git --version
echo

h1 "Copy Public Key to GitHub"
h2 "$key_file.pub"
echo
echo paste contents into GitHub SSH public key form
echo
cat "$key_file.pub"
echo
pause_enter

echo
h1 "test connection"
echo
ssh -T git@github.com
pause_enter



# echo
# h1 "load ppa"
# echo
# sudo add-apt-repository -y ppa:git-core/ppa
# sudo apt update

# echo
# h1 "install git"
# echo
# sudo apt install -y git

# h1 "install git-lfs"
# echo
# sudo apt install -y git-lfs
