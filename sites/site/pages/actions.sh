#!/usr/bin/env bash

function pages_actions() {

  # TODO: show all menu options on '?'
  ui_banner "PAGES actions: "

  read -s -n1  action
  case $action in
    q) clear; ;;
    t) tree; pages_actions; ;;
    /) search; clear; pages; ;;
    r) ranger; clear; pages; ;;
    d) la; echo; pages_actions; ;;
    h) cd ..; clear; site; ;;
    j) clear; plugins; ;;
    k) clear; plugins; ;;
    [1-9]*)
      cd $(dirname ${children[$((action - 1))]})
      clear
      page
      ;;
    f) vf; clear; pages; ;;
    g) zd; clear; page; ;;
    G)
      clear
      echo
      gss
      read -p "Add and commit this branch [y]:  " -e commit
      if [[ $commit == "y" ]]; then
        gacp
        echo
        read -p "press any key to continue"
      fi
      clear
      pages
      ;;
    b)
      clear
      page_children_renumber
      clear
      pages
      ;;
    n) clear; pages_new; clear; page; ;;
    *)
      clear
      pages
      ;;
  esac
}
