#!/usr/bin/env bash

function tools_git_actions() {

  # TODO: show all menu options on '?'
  ui_banner "git actions: a c p f b"

  read -n1  action
  case $action in
    q) clear; ;; # quit
    a) git add .; read -p "enter to continue"; tools_git  ;;
    c) git commit; read -p "enter to continue"; tools_git  ;;
    p) git push; read -p "enter to continue"; tools_git  ;;
    f) gsub fetch; read -p "enter to continue"; tools_git  ;;
    b) gsub update; read -p "enter to continue"; tools_git  ;;
    *)
      clear
      tools_git
      ;;
  esac

}
