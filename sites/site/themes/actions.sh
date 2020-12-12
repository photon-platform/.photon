#!/usr/bin/env bash

function themes_actions() {

  # TODO: show all menu options on '?'
  ui_footer "themes actions: "

  read -s -n1 -p " > "  action
  case $action in
    q) clear; ;; # quit
    @) clear; site ;;
    /) search; clear; themes; ;;

    r) ranger; clear; themes; ;;
    t) tre; clear; themes; ;;
    d) ll; echo; themes_actions; ;;
    I) images; ;;

    h) clear; site; ;;
    k) cd ../pages; clear; pages; ;;
    '#')
      read -p "enter number: " number
      dir="$(dirname ${list[((number-1))]})"
      cd $dir
      clear
      theme
      ;;
    [1-9]*)
      cd "$( dirname ${list[(($action-1))]} )"
      # read
      clear
      theme
      ;;
    f) vf; clear; themes;;
    g) zd; clear ;;
    G)
      tools_git
      clear
      themes
      ;;
    n)
      # new theme from template
      ;;
    c)
      # create submodule
      ;;
    b)
      # restore submodule
      ;;
    remove)
      # initialize a submodule
      ;;
    *)
      clear
      themes
      ;;
  esac

}
