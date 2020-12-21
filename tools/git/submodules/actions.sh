#!/usr/bin/env bash

function tools_git_submodules_actions() {

  echo
  hr
  P=" ${fgYellow}GIT SUBMODULES${txReset}"
  read -n1 -p "$P > " action
  printf " $SEP ${actions[$action]}\n\n"
  case $action in
    \?)
      for key in "${!actions[@]}"; do 
        key_item $key "${actions[$key]}"
      done
      tools_git_submodules_actions
      ;;
    q) clear -x; ;; # quit
    m) echo; tools_git_submodules_master; pause_enter;  tools_git_submodules  ;;
    f) echo; tools_git_submodules_fetch; pause_enter;  tools_git_submodules  ;;
    u) echo; tools_git_submodules_update; pause_enter;  tools_git_submodules  ;;
    a) echo; tools_git_submodules_add; pause_enter;  tools_git_submodules  ;;
    r) echo; tools_git_submodules_remove; pause_enter;  tools_git_submodules  ;;
    *)
      clear
      tools_git
      ;;
  esac

}
