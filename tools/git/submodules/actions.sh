#!/usr/bin/env bash

function tools_git_submodules_actions() {

  # TODO: show all menu options on '?'
  ui_banner "git actions: q m f u | a r"

  read -s -n1  action
  case $action in
    q) clear; ;; # quit
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