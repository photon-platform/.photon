#!/usr/bin/env bash

function tools_exif_actions() {
  declare -A actions
  actions['?']="help"
  actions[q]="quit"


  hr
  P=" ${fgYellow}EXIF${txReset}"
  read  -n1 -p "$P > " action
  printf " $SEP ${actions[$action]}\n\n"
  case $action in
    \?)
      for key in "${!actions[@]}"; do 
        key_item $key "${actions[$key]}"
      done
      tools_exif_actions
      ;;
    q) clear -x; ;;
    t) updateExif Title;  ;;
    d) updateExif Description;  ;;
    n) updateExif Notes;  ;;
    s) updateExif Subject;  ;;
    r) updateExif Rating;  ;;
    l) updateExif Colorlabels;  ;;
    c) updateExif Creator;  ;;
    p) updateExif Publisher;  ;;
    y) updateExif Copyright;  ;;
    *)
      tools_exif_actions
      ;;
  esac
}

function updateExif() {
  key=$1
  if [[ $key ]]; then
    value="$(ask_value "$key" "$( getExifValue "$key" )" )"
    exiftool -$key="$value" "$file"
  else
    echo " provide key"
  fi
}
