#!/usr/bin/env bash

source ~/.photon/tools/grav/actions.sh

alias V=tools_grav

# alias grav-core="wget -O _grav-core.zip https://getgrav.org/download/core/grav/1.6.9 "
# alias grav-admin="wget -O _grav-admin.zip https://getgrav.org/download/core/grav/1.6.9 "
# alias grav-update="cd $SITESROOT/grav;bin/gpm self-upgrade;"

function tools_grav() {
  @
  source .photon
  cd ..

  clear
  ui_header "$PROJECT * GRAV"
  tab_title "$PROJECT * GRAV"

  echo
  bin/grav -V
  echo

  tools_grav_actions

  cd user
}
