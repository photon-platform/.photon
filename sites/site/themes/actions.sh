#!/usr/bin/env bash

function themes_actions() {

  # TODO: show all menu options on '?'
  ui_banner "themeS actions: "

  read -n1  action
  case $action in
    q) clear; ;; # quit
    /) search; clear; themes; ;;
    r) ranger; clear; themes; ;;
    d) clear; echo; la; echo; themes_actions; ;;
    h) clear; site; ;;
    j) cd ../pages; clear; pages; ;;
    k) cd ../pages; clear; pages; ;;
    [1-9]*)
      cd "$( dirname ${list[(($action-1))]} )"
      # read
      clear
      theme
      ;;
    f) vf; clear; themes;;
    g) zd; ranger ;;
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