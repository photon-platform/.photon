#!/usr/bin/env bash

export SITESROOT=~/SITES
export ISLOCAL=true
if [[ "$HOSTNAME" =~ .*com$ ]]
then
  # export SITESROOT=~
  export ISLOCAL=false
fi

# default org for github operations
# GITHUBORG="photon-platform"

source ~/.photon/sites/list.sh
source ~/.photon/sites/actions.sh
source ~/.photon/sites/new.sh
source ~/.photon/sites/restore.sh
source ~/.photon/sites/apache.sh
source ~/.photon/sites/site/_main.sh

alias S=sites

function sites() {
  cd $SITESROOT
  
  clear -x

  ui_header "ARCHIVES $SEP $PWD"

  sites_list

  sites_actions

  tab_title
}

function repo_check() {
  ORGNAME="$1"
  if [[ -z $ORGNAME ]]; then
    echo
    read -p "specify ORGNAME: " ORGNAME
  fi

  PROJECT="$2"
  if [[ -z $PROJECT ]]; then
    echo
    read -p "specify PROJECT in $ORGNAME: " PROJECT
  fi

  REPO="git@github.com:$ORGNAME/$PROJECT.git"
  echo
  echo "✴ check remote repo"
  echo $REPO
  echo
  git ls-remote $REPO
}
