#!/usr/bin/env bash

function sites_restore() {

  clear -x
  ui_header "photon ✴ SITES restore"

  PROJECT="$1"
  if [[ -z $PROJECT ]]; then
    echo
    read -p "specify PROJECT repo name to restore: " PROJECT
  fi

  githuborg_set
  repo_check

  if [ -n $PROJECT ]
  then

    echo
    h1 "sandbox grav"
    echo
    cd $SITESROOT/grav
    bin/grav sandbox -s $SITESROOT/$PROJECT
    ln -sf $SITESROOT/grav/.htaccess $SITESROOT/$PROJECT/

    echo
    h1 "clone $REPO"
    echo
    cd $SITESROOT/$PROJECT
    rm -rf user
    git clone --recurse-submodules $REPO $SITESROOT/$PROJECT/user

    cd $SITESROOT/$PROJECT/user
    git submodule foreach "pwd; \
      git checkout master; \
      git status -sb; \
      echo"

    if [[ $ISLOCAL = true ]]
    then
      apache_new $PROJECT
    fi
      
    #TODO: prompt for username
    cd $SITESROOT/$PROJECT
    bin/plugin login new-user \
      -u phi \
      -e phi@phiarchitect.com \
      -P b \
      -N "phi ARCHITECT" \
      -t "admin"
    cd $SITESROOT/$PROJECT/user
    
  else
    echo "no project name"
  fi
}
