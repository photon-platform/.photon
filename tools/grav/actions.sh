#!/usr/bin/env bash

function tools_grav_actions() {

  # TODO: show all menu options on '?'
  ui_banner "grav actions: "

  read -n1  action
  case $action in
    q) clear; ;; # quit
    c) bin/grav clearcache; read -p "enter to continue";  ;;
    u) bin/gpm update; read -p "enter to continue";  ;;
    l) bin/grav clean; read -p "enter to continue";  ;;
    *)
      clear
      ;;
  esac

}
