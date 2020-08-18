#!/usr/bin/env bash

source ~/.photon/tools/grav/actions.sh

alias V=tools_grav

function tools_grav() {
  @
  source .photon
  cd ..

  clear
  ui_banner "$PROJECT * GRAV"
  tab_title "$PROJECT * GRAV"

  echo
  bin/gpm version
  echo

  tools_grav_actions

  cd user
}
