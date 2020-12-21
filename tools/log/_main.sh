#!/usr/bin/env bash

source ~/.photon/tools/log/actions.sh

alias L=tools_log

function tools_log() {
  clear -x
  ui_header "LOG $SEP $PWD"
  
  tools_log_actions

  tab_title "$PWD"
}

function log() {
  wmctrl -T log$$ -r :ACTIVE:
  sk
  v4
  sleep 2
  wmctrl -a log$$
  clear
  source ~/SITES/phiarchitect.com/user/.photon
  cd ~/SITES/phiarchitect.com/user/pages/04.log/
  page
}
