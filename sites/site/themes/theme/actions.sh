#!/usr/bin/env bash

function theme_actions() {

  # TODO: show all menu options on '?'
  ui_banner "theme actions: "

  read -n1  action
  case $action in
    q) clear; ;;
    @) clear; cd ..; site ;;
    /) search; clear; theme; ;;
    r) ranger; clear; theme; ;;
    d) clear; echo; ls -hA; echo; theme; ;;
    h) cd ..; clear; themes; ;;
    j)
      next=$(dirname ${siblings[$((siblings_index + 1))]})
      if [[ -d "$next" ]]
      then
        cd "$next"
      fi
      clear
      theme
      ;;
    k)
      prev=$(dirname ${siblings[$((siblings_index - 1))]})
      if [[ -d "$prev" ]]
      then
        cd "$prev"
      fi
      clear
      theme
      ;;
    f) vf; clear; theme; ;;
    g) zd; clear; theme; ;;
    G)
      tools_git
      clear
      theme
      ;;
    n)
      clear
      themes_new
      clear
      theme
      ;;
    *)
      clear
      theme
      ;;
  esac
}
