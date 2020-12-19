#!/usr/bin/env bash

function tools_capture_actions() {

  hr
  P=" ${fgYellow}CAPTURE${txReset}"
  read -n1 -p "$P > " action
  case $action in
    q) clear; ;; # quit
    l) gphoto2 --list-files; echo; tools_capture_actions; ;;
    g) tools_capture_get_all_files; echo; tools_capture_actions; ;;
    *) echo " $SEP ${fgRed}not a command${txReset}"; tools_capture_actions; ;;
  esac

}

function tools_capture_get_all_files() {
  gphoto2 --get-all-files --filename "${HOME}/Media/${USER}/%Y/%m/%d/%H%M%S-%03n.%C" 
}
