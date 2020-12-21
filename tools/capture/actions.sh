#!/usr/bin/env bash

function tools_capture_actions() {

  echo
  hr
  P=" ${fgYellow}CAPTURE${txReset}"
  read -n1 -p "$P > " action
  printf " $SEP ${actions[$action]}\n\n"
  case $action in
    \?)
      for key in "${!actions[@]}"; do 
        key_item $key "${actions[$key]}"
      done
      tools_capture_actions
      ;;
    q) clear -x; ;; # quit
    l) gphoto2 --list-files; tools_capture_actions; ;;
    g) tools_capture_get_all_files; tools_capture_actions; ;;
    *) echo " $SEP ${fgRed}not a command${txReset}"; tools_capture_actions; ;;
  esac

}

function tools_capture_get_all_files() {
  gphoto2 --get-all-files --filename "${HOME}/Media/${USER}/%Y/%m/%d/%H%M%S-%03n.%C" 
}
