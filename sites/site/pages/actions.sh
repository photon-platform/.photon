#!/usr/bin/env bash

function pages_actions() {

  echo
  hr
  P=" ${fgYellow}PAGES${txReset}"
  read -s -n1 -p "$P > " action
  case $action in
    q) clear -x; ;;
    @) site ;;
    /) search; pages; ;;
    
    r) ranger; pages; ;;
    t) tre; pages; ;;
    l) ll; echo; pages_actions; ;;

    e) v README.md; pages; ;;

    g) zd; page; ;;
    h) cd ..; site; ;;
    k) cd ../plugins; plugins; ;;
    j) cd ../themes; themes; ;;
    '#')
      read -p "enter number: " number
      if [[ ${children[$((number - 1))]} ]]; then
        dir="$(dirname ${children[((number-1))]})"
        if [[ -d "$dir" ]]; then
          cd "$dir"
        fi
      fi
      page
      ;;
    [1-9]*)
      if [[ ${children[$((action - 1))]} ]]; then
        dir="$(dirname ${children[((action-1))]})"
        if [[ -d "$dir" ]]; then
          cd "$dir"
        fi
      fi
      page
      ;;
    0)
      last=$(( ${#children[@]} - 1 ))
      cd $(dirname ${children[ last ]})
      page
      ;;
    a)
      vim "${children[@]}"
      ;;
    f) vf; pages; ;;
    v) vr; pages; ;;
    F) folder; ;;
    I) images; ;;
    T) taxonomy; page; ;;
    G) tools_git; pages ;;
    b)
      page_children_renumber
      clear
      pages
      ;;
    n) clear; pages_new; clear; page; ;;
    *)
      pages
      ;;
  esac
}
