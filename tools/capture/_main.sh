#!/usr/bin/env bash

source ~/.photon/tools/capture/actions.sh

alias capture=tools_capture

function tools_capture() {

  clear
  ui_header "CAPTURE $SEP $PWD"

  gphoto2 --auto-detect

  echo 

  tools_capture_actions

}
