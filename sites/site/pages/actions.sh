#!/usr/bin/env bash

function pages_actions() {

  # TODO: show all menu options on '?'
  ui_footer "PAGES actions: "

  read -s -n1 -p " > "  action
  case $action in
    q) clear; ;;
    @) clear; site ;;
    /) search; clear; pages; ;;
    
    r) ranger; clear; pages; ;;
    t) tre; clear; pages; ;;
    d) ll; echo; pages_actions; ;;
    I) images; ;;

    h) cd ..; clear; site; ;;
    k) cd ../plugins; clear; plugins; ;;
    j) cd ../themes; clear; themes; ;;
    '#')
      read -p "enter number: " number
      if [[ ${children[$((number - 1))]} ]]; then
        dir="$(dirname ${children[((number-1))]})"
        if [[ -d "$dir" ]]; then
          cd "$dir"
        fi
      fi
      clear
      page
      ;;
    [1-9]*)
      if [[ ${children[$((action - 1))]} ]]; then
        dir="$(dirname ${children[((action-1))]})"
        if [[ -d "$dir" ]]; then
          cd "$dir"
        fi
      fi
      clear
      page
      ;;
    0)
      last=$(( ${#children[@]} - 1 ))
      cd $(dirname ${children[ last ]})
      clear
      page
      ;;
    a)
      vim "${children[@]}"
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
