#!/usr/bin/env bash

source ~/.photon/tools/log/actions.sh

alias L=tools_log

function tools_log() {

  clear
  ui_header "tools * log"
  tab_title "tools * log"

  pwd
  echo
  
  tools_log_actions

  tab_title "$PWD"
}

