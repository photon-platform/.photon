#!/usr/bin/env bash

function taxonomy_actions() {

  # TODO: show all menu options on '?'
  ui_banner "TAXONOMY actions: "

  read -s -n1  action
  case $action in
    q) clear; ;;
    /) search; clear; pages; ;;
    # h) cd ..; clear; site; ;;
    # j) clear; plugins; ;;
    # k) clear; plugins; ;;
    [1-9]*)
      cd $(dirname ${children[$((action - 1))]})
      clear
      page
      ;;
    0)
      last=$(( ${#children[@]} - 1 ))
      cd $(dirname ${children[ last ]})
      clear
      page
      ;;
    f) vf; clear; pages; ;;
    g) zd; clear; page; ;;
  esac
}
