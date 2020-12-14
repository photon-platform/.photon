#!/usr/bin/env bash

function tools_grav_actions() {

  hr
  P=" ${fgYellow}GRAV${txReset}"
  read -s -n1 -p "$P > " action
  case $action in
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
