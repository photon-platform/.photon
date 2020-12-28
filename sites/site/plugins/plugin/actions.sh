#!/usr/bin/env bash

function plugin_actions() {

  echo
  hr
  P=" ${fgYellow}PLUGIN${txReset}"
  read -s -n1 -p "$P > " action
  case $action in
    q) clear -x; ;;
    @) cd ..; site ;;
    /) search; plugin; ;;

    r) ranger_dir; folder; ;;
    t) tre; plugin; ;;
    l) ll; plugin_actions; ;;

    e) v README.md ; plugin; ;;
    c) v CHANGELOG.md; plugin; ;;
    .) v blueprints.yaml ; plugin; ;;

    g) zd; folder;;
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
    R) report_plugin > README.md;
      mkdir -p docs;
      cp README.md docs/index.md;
      v README.md;
      plugin ;;
    I) images; ;;
    F) folder; ;;
    G)
      tools_git
      plugin
      ;;
    n)
      plugins_new
      plugin
      ;;
    *)
      plugin
      ;;
  esac
}
