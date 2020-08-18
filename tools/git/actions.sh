#!/usr/bin/env bash

function tools_git_actions() {

  # TODO: show all menu options on '?'
  ui_banner "git actions: a c p f b"

  read -n1  action
  case $action in
    q) clear; ;; # quit
    a) git add .;  tools_git  ;;
    c) git commit;  tools_git  ;;
    p) git push;  tools_git  ;;
    f) gsub fetch;  tools_git  ;;
    b) gsub update;  tools_git  ;;
    *)
      clear
      tools_git
      ;;
  esac

}
