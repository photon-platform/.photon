#!/usr/bin/env bash

function themes_actions() {

  echo
  hr
  P=" ${fgYellow}THEMES${txReset}"
  read -s -n1 -p "$P > " action
  case $action in
    q) clear -x; ;; # quit
    @) site ;;
    /) search; themes; ;;

    r) ranger_dir; folder; ;;
    t) tre; themes; ;;
    l) ll; themes_actions; ;;

    e) v README.md; pages; ;;

    g) zd; folder ;;
    h) site; ;;
    k) cd ../pages; pages; ;;
    '#')
      read -p "enter number: " number
      dir="$(dirname ${list[((number-1))]})"
      cd $dir
      theme
      ;;
    [1-9]*)
      cd "$( dirname ${list[(($action-1))]} )"
      # read
      theme
      ;;
    f) vf; themes;;
    v) vr; pages; ;;
    F) folder; ;;
    I) images; ;;
    G)
      tools_git
      themes
      ;;
    *)
      themes
      ;;
  esac

}
