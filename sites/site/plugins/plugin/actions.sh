#!/usr/bin/env bash

function plugin_actions() {

  hr
  P=" ${fgYellow}PLUGIN${txReset}"
  read -s -n1 -p "$P > " action
  case $action in
    q) clear -x; ;;
    @) cd ..; site ;;
    /) search; plugin; ;;

    r) ranger; plugin; ;;
    t) tre; plugin; ;;
    d) ll; echo; plugin_actions; ;;
    I) images; ;;

    e) v README.md ; plugin; ;;
    .) v blueprints.yaml ; plugin; ;;
    l) vim CHANGELOG.md; plugin; ;;

    h) cd ..; plugins; ;;
    j)
      next=$(dirname ${siblings[$((siblings_index + 1))]})
      if [[ -d "$next" ]]
      then
        cd "$next"
      fi
      plugin
      ;;
    k)
      prev=$(dirname ${siblings[$((siblings_index - 1))]})
      if [[ -d "$prev" ]]
      then
        cd "$prev"
      fi
      plugin
      ;;
    f) vf; plugin; ;;
    g) zd; ;;
    R) report_plugin > README.md;
      mkdir -p docs;
      cp README.md docs/index.md;
      v README.md;
      plugin ;;
    F) folder; plugin; ;;
    G)
      tools_git
      plugin
      ;;
    n)
      plugins_new
      plugin
      ;;
    *)
      clear
      plugin
      ;;
  esac
}
