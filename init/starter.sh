#!/usr/bin/env bash

# initialize the starter site

PROJECT="starter"

source ~/.photon/.hosts
source ~/.photon/.sites
source ~/.photon/.functions


sudo pwd

echo
echo "✴ cloning grav"
cd ~/SITES/grav
bin/grav sandbox -s ~/SITES/$PROJECT
ln -sf ~/SITES/grav/.htaccess ~/SITES/$PROJECT/

echo
echo "✴ clone starter user"
cd ~/SITES/$PROJECT
rm -rf user
git clone --recurse-submodules https://github.com/photon-platform/photon.git ~/SITES/$PROJECT/user
git submodule foreach "pwd; \
  git checkout master; \
  git status -sb; \
  echo"


~/.photon/sites/new-apache.sh $PROJECT
