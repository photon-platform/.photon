#!/usr/bin/env bash

function plugin_actions() {

  # TODO: show all menu options on '?'
  ui_footer "plugin actions: "

  read -s -n1  action
  case $action in
    q) clear; ;;
    @) clear; cd ..; site ;;
    /) search; clear; plugin; ;;
    r) ranger; clear; plugin; ;;
    R) report_plugin > README.md; 
      mkdir -p docs;
      cp README.md docs/index.md;
      v README.md; 
      clear; plugin ;;
    d) clear; echo; ls -hA; echo; plugin; ;;
    e) v README.md ; clear; plugin; ;;
    .) v blueprints.yaml ; clear; plugin; ;;
    l) vim CHANGELOG.md; clear; plugin; ;;
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
    g) zd; clear; ;;
    G)
      tools_git
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
