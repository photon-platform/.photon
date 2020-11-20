#!/usr/bin/env bash

source ~/.photon/tools/ffmpeg/actions.sh
source ~/.photon/tools/ffmpeg/cameras.sh


function tools_ffmpeg() {

  clear
  ui_header "tools * ffmpeg"
  tab_title "tools * ffmpeg"

  pwd
  echo
  ffmpeg -hide_banner -sources pulse
  ffmpeg -hide_banner -sources video4linux2

  for (( i = 0; i < ${#media[@]}; i++ ))
  do
    echo ${media[i]}
  done

  echo
  
  tools_ffmpeg_actions

  tab_title "$PWD"
}
alias F=tools_ffmpeg

