#!/usr/bin/env bash

source ~/.photon/tools/ffmpeg/actions.sh


function tools_ffmpeg() {

  clear
  ui_banner "tools * ffmpeg"
  tab_title "tools * ffmpeg"

  pwd
  echo
  mapfile -t media < <(find . -type f -name "*.mkv" -or -name "*.opus" -or -name "*.mp3" | sort)

  for (( i = 0; i < ${#media[@]}; i++ ))
  do
    echo ${media[i]}
  done

  echo
  
  tools_ffmpeg_actions

  tab_title "$PWD"
}
alias F=tools_ffmpeg

