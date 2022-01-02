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



