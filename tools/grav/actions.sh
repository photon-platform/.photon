#!/usr/bin/env bash

function tools_grav_actions() {

  echo
  hr
  P=" ${fgYellow}GRAV${txReset}"
  read -n1 -p "$P > " action
  printf " $SEP ${actions[$action]}\n\n"
  case $action in
    \?)
      for key in "${!actions[@]}"; do 
        key_item $key "${actions[$key]}"
      done
      tools_grav_actions
      ;;
    q) clear; ;; # quit
    v) 
        cd $SITESROOT/grav
        bin/gpm self-upgrade; 
        cd -
        echo; tools_grav_actions; 
        ;;
    u) bin/gpm update; bin/grav clean; echo; tools_grav_actions; ;;
    c) bin/grav clearcache; echo; tools_grav_actions; ;;
    l) bin/grav clean; echo; tools_grav_actions; ;;
    t) bin/plugin tntsearch index; echo; tools_grav_actions; ;;
    *) echo; echo "not a command"; tools_grav_actions; ;;
  esac

}
