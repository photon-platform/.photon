#!/usr/bin/env bash

source ~/.photon/tools/capture/actions.sh

alias capture=tools_capture

function tools_capture() {
  clear -x
  ui_header "CAPTURE $SEP $PWD"

  gio mount -s gphoto2
  gphoto2 --summary

  tools_capture_actions

}
