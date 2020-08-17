#!/usr/bin/env bash

function plugin_actions() {

  # TODO: show all menu options on '?'
  ui_banner "plugin actions: "

  read -n1  action
  case $action in
    q) clear; ;;
    /) search; clear; plugin; ;;
    r) ranger; clear; plugin; ;;
    d) clear; echo; ls -hA; echo; plugin; ;;
    h) cd ..; clear; plugins; ;;
    j)
      next=$(dirname ${siblings[$((siblings_index + 1))]})
      if [[ -d "$next" ]]
      then
        cd "$next"
      fi
      clear
      plugin
      ;;
    k)
      prev=$(dirname ${siblings[$((siblings_index - 1))]})
      if [[ -d "$prev" ]]
      then
        cd "$prev"
      fi
      clear
      plugin
      ;;
    f) vf; clear; plugin; ;;
    g) zd; clear; plugin; ;;
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
      plugin
      ;;
    n)
      clear
      plugins_new
      clear
      plugin
      ;;
    *)
      clear
      plugin
      ;;
  esac
}
