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
    k) clear; themes; ;;
    '#')
      read -p "enter number: " number
      dir="$(dirname ${children[((number-1))]})"
      cd $dir
      clear
      page
      ;;
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
    T) taxonomy; clear; page; ;;
    G)
      tools_git
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
