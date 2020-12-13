#!/usr/bin/env bash

function tools_git_actions() {

  hr
  P=" ${fgYellow}GIT${txReset}"
  read -s -n1 -p "$P > " action
  case $action in
    q) clear; ;; # quit

    g) zd; clear; tools_git; ;;
    h) cd ..; clear; tools_git; ;;

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
