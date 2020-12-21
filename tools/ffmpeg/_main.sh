#!/usr/bin/env bash

source ~/.photon/tools/ffmpeg/actions.sh
source ~/.photon/tools/ffmpeg/cameras.sh


function tools_ffmpeg() {

  clear -x
  ui_header "FFMPEG $SEP $PWD"

  ffmpeg -hide_banner -sources pulse
  ffmpeg -hide_banner -sources video4linux2

  for (( i = 0; i < ${#media[@]}; i++ ))
  do
    echo ${media[i]}
  done

  
  tools_ffmpeg_actions

  tab_title "$PWD"
}
alias ff=tools_ffmpeg

