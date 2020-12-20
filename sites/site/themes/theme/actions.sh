#!/usr/bin/env bash

function theme_actions() {

  hr
  P=" ${fgYellow}THEME${txReset}"
  read -s -n1 -p "$P > " action
  case $action in
    q) clear -x; ;;
    @) cd ..; site ;;
    /) search; theme; ;;
    e) v README.md ; theme; ;;
    .) v blueprints.yaml ; theme; ;;
    l) vim CHANGELOG.md; theme; ;;

    r) ranger; theme; ;;
    t) tre; theme; ;;
    d) ll; echo; theme_actions; ;;
    I) images; ;;

    h) cd ..; themes; ;;
    j)
      next=$(dirname ${siblings[$((siblings_index + 1))]})
      if [[ -d "$next" ]]
      then
        cd "$next"
      fi
      theme
      ;;
    k)
      prev=$(dirname ${siblings[$((siblings_index - 1))]})
      if [[ -d "$prev" ]]
      then
        cd "$prev"
      fi
      theme
      ;;
    f) vf; theme; ;;
    g) zd; theme; ;;

    F) folder; theme; ;;
    G) tools_git; theme; ;;
    R) report_theme > README.md; 
      mkdir -p docs;
      cp README.md docs/index.md;
      v README.md; 
      theme ;;
    n)
      themes_new
      theme
      ;;
    *)
      theme
      ;;
  esac
}
