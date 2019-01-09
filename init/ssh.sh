#!/bin/sh

# start agent
eval "$(ssh-agent -s)"

# set ssh keys
# copy keys into folder
# set directory to proper permissions
sudo chmod 700 ~/.ssh
# set private keys

# instructions for setting up an SSH key on inmotion_ssh
# https://www.inmotionhosting.com/support/website/ssh/shared-reseller-ssh
sudo chmod 600 ~/.ssh/inmotion_ssh
sudo ssh-add ~/.ssh/inmotion_ssh
# 'config' file should have alias for illumiphi.com
# connect to inmotion
ssh illumiphi.com

# for github
sudo chmod 600 ~/.ssh/id_rsa_phi_illumiphi
ssh-add ~/.ssh/id_rsa_phi_illumiphi
# use password from key creation







## git new keygen (if ncessary)
ssh-keygen -t rsa -b 4096 -C "phi@illumiphi.com"
# save to id_rsa_phi_illumiphi

# start agent
eval "$(ssh-agent -s)"
# add key to agent for single signon
ssh-add ~/.ssh/id_rsa_phi_illumiphi

# Copies the contents of the id_rsa.pub file to your clipboard - paste to github settings
sudo apt install xclip
xclip -sel clip < ~/.ssh/id_rsa_phi_illumiphi.pub

