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

    r) ranger_dir; folder; ;;
    t) tre; theme; ;;
    d) ll; echo; theme_actions; ;;

    g) zd; folder; ;;
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
    v) vr; theme; ;;

    I) images; ;;
    F) folder;  ;;
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
