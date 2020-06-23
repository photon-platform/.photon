#!/usr/bin/env bash

# sandbox a new site with grav
# copy additional files
# set up apache


SITESROOT=~/SITES
ISLOCAL=true
if [[ "$HOSTNAME" == .*com$ ]]
then
  SITESROOT=~
  ISLOCAL=false
fi

GITHUBORG="illumiphi"
PROJECT="$1"
TITLE="$2"

echo
echo "✴ photon SITE Restorer"
if [ -z $PROJECT ]
then
  echo
  read -p "specify PROJECT repo name to restore: " PROJECT
fi

REPO="https://github.com/$GITHUBORG/$PROJECT.git"
echo
echo "✴ check remote repo"
echo $REPO
echo
git ls-remote $REPO
if [ $? -ne 0 ]
then
  echo ""
  echo "https://github.com/new"
  exit 1
fi

if [ -n $PROJECT ]
then

  START_TIME="$(date -u +%s)"

  # CLONE=starter

  sudo pwd

  echo
  echo "✴ cloning grav"
  cd $SITESROOT/grav
  bin/grav sandbox -s $SITESROOT/$PROJECT
  ln -sf $SITESROOT/grav/.htaccess $SITESROOT/$PROJECT/

  echo
  echo "✴ clone github repo for site"
  cd $SITESROOT/$PROJECT
  rm -rf user
  git clone --recurse-submodules $REPO $SITESROOT/$PROJECT/user
  git submodule foreach "pwd; \
    git checkout master; \
    git status -sb; \
    echo"

  # echo
  # echo "✴ init tntsearch"
  # bin/plugin tntsearch index

  # echo
  # echo "✴ set config files"
  # cd $SITESROOT/$PROJECT/user
  # echo "✴ create server config folder"
  # mv starter.photon-platform.net $PROJECT.illumiphi.com
  #
  #
  echo
  echo "✴ set accounts"
  cd $SITESROOT/$PROJECT/user
  cp $SITESROOT/$CLONE/user/accounts/*.yaml accounts/

  if [[ $ISLOCAL = true ]]
  then
    ~/.photon/sites/new-apache.sh $PROJECT
  fi
    
  # git remote set-url origin "$REPO"

  # git add .
  # git commit -m "init"

  END_TIME="$(date -u +%s)"
  ELAPSED="$((END_TIME-START_TIME))"
  TIME=$(convertsecstomin $ELAPSED)
  echo
  echo "✴ elapsed: $TIME m:s"

  gsub update

  
else
  echo "no project name"
fi
