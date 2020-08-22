#!/usr/bin/env bash

function tools_git_actions() {

  # TODO: show all menu options on '?'
  ui_banner "git actions: q a c p u f b"

  read -n1  action
  case $action in
    q) clear; ;; # quit
    a) echo; git add .;  tools_git  ;;
    c) echo; git commit;  tools_git  ;;
    p) echo; git push; echo; read -p "enter to continue: ";  tools_git  ;;
    u) echo; git pull --recurse-submodules; echo; read -p "enter to continue: ";  tools_git  ;;
    f) echo; gsub fetch; echo; read -p "enter to continue: " ;  tools_git  ;;
    b) echo; gsub update; echo; read -p "enter to continue: " ;  tools_git  ;;
    *)
      clear
      tools_git
      ;;
  esac

}
