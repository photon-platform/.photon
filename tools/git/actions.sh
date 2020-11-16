#!/usr/bin/env bash

function tools_git_actions() {

  # TODO: show all menu options on '?'
  ui_footer "git actions: q l d a c p u S"

  read -s -n1 -p " > "  action
  case $action in
    q) clear; ;; # quit
    l) echo; git log --graph --oneline ;   tools_git  ;;
    d) echo; git diff .; pause_enter;  tools_git  ;;
    a) echo; git add .;  tools_git  ;;
    c) echo; git commit;  tools_git  ;;
    p) echo; git push; pause_enter;  tools_git  ;;
    u) echo; git pull --recurse-submodules; pause_enter;  tools_git  ;;
    S) echo; tools_git_submodules;  tools_git  ;;
    *)
      clear
      tools_git
      ;;
  esac

}
