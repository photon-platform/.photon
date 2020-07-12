#!/usr/bin/env bash

function themes_actions() {

  # TODO: show all menu options on '?'
  ui_banner "themeS actions: "

  read -n1  action
  case $action in
    q)
      clear
      echo "exiting themeS"
      echo "type "themes" to reeneter"
      ;;
    /)
      search
      clear
      themes
      ;;
    r)
      ranger
      clear
      themes
      ;;
    d)
      clear
      echo
      la
      echo
      themes_actions
      ;;
    h)
      # nav up
      clear
      site
      ;;
    j)
      cd ../pages
      clear
      pages
      ;;
    k)
      cd ../pages
      clear
      pages
      ;;
    [1-9]*)
      cd "$( dirname ${list[(($action-1))]} )"
      # read
      clear
      theme
      ;;
    g)
      echo
      # read -p "Enter child number: " -e num
      # cd "${dirs[(($num-1))]}"
      zd
      clear
      theme
      ;;
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
