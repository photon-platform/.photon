#!/usr/bin/env bash

function tools_grav_actions() {

  # TODO: show all menu options on '?'
  ui_banner "grav actions: q v-grav u-plugins c-cache l-clean t-tntsearch"

  read -s -n1  action
  case $action in
    q) clear; ;; # quit
    v) bin/gpm self-upgrade; echo; tools_grav_actions; ;;
    u) bin/gpm update; bin/grav clean; echo; tools_grav_actions; ;;
    c) bin/grav clearcache; echo; tools_grav_actions; ;;
    l) bin/grav clean; echo; tools_grav_actions; ;;
    t) bin/plugin tntsearch index; echo; tools_grav_actions; ;;
    *) echo; echo "not a command"; tools_grav_actions; ;;
  esac

}
