#!/usr/bin/env bash

export SITESROOT=~/SITES
export ISLOCAL=true
if [[ "$HOSTNAME" =~ .*com$ ]]
then
  # export SITESROOT=~
  export ISLOCAL=false
fi

# default org for github operations
GITHUBORG="photon-platform"

source ~/.photon/sites/list.sh
source ~/.photon/sites/actions.sh
source ~/.photon/sites/new.sh
source ~/.photon/sites/restore.sh
source ~/.photon/sites/apache.sh
source ~/.photon/sites/site/_main.sh

# alias grav-core="wget -O _grav-core.zip https://getgrav.org/download/core/grav/1.6.9 "
# alias grav-admin="wget -O _grav-admin.zip https://getgrav.org/download/core/grav/1.6.9 "
alias grav-update="cd $SITESROOT/grav;bin/gpm self-upgrade;"

function sites() {

  cd $SITESROOT
  
  clear -x

  ui_header "SITES $SEP $PROJECT"

  sites_list

  sites_actions

  tab_title

}

function githuborg_set() {
  echo
  read -e -i "$GITHUBORG" -p "specify GITHUB Org name: " GITHUBORG
}

function repo_check() {
  REPO="https://github.com/$GITHUBORG/$PROJECT.git"
  echo
  echo "✴ check remote repo"
  echo $REPO
  echo
  git ls-remote $REPO
  if [ $? -ne 0 ]
  then
    echo ""
    echo "check if REPO exists"
    exit 1
  fi
  
}
