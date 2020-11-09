#!/usr/bin/env bash

# initialize the starter site

PROJECT="starter.photon-platform.net"

source ~/.photon/.functions
source ~/.photon/hosts/_main.sh
source ~/.photon/ui/_main.sh
source ~/.photon/sites/_main.sh

sites_restore $PROJECT
# echo
# h1 "download zip: $GRAV"
# echo

# sudo pwd

# echo
# h1 "sandbox grav"
# echo
# cd ~/SITES/grav
# bin/grav sandbox -s ~/SITES/$PROJECT
# ln -sf ~/SITES/grav/.htaccess ~/SITES/$PROJECT/

# echo
# echo "✴ clone starter user"
# h1 "clone grav"
# echo
# cd ~/SITES/$PROJECT
# rm -rf user
# git clone --recurse-submodules https://github.com/photon-platform/photon.git ~/SITES/$PROJECT/user
# git submodule foreach "pwd; \
  # git checkout master; \
  # git status -sb; \
  # echo"

# mkdir ~/SITES/LOGS/$PROJECT


firefox "http://$PROJECT.local" &
