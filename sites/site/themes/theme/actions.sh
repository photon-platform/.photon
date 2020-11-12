#!/usr/bin/env bash

function theme_actions() {

  # TODO: show all menu options on '?'
  ui_footer "theme actions: "

  read -s -n1  action
  case $action in
    q) clear; ;;
    @) clear; cd ..; site ;;
    /) search; clear; theme; ;;
    r) ranger; clear; theme; ;;
    e) v README.md ; clear; theme; ;;
    .) v blueprints.yaml ; clear; theme; ;;
    l) vim CHANGELOG.md; clear; theme; ;;
    R) report_theme > README.md; 
      mkdir -p docs;
      cp README.md docs/index.md;
      v README.md; clear; theme ;;
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
