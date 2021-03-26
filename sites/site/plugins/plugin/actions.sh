#!/usr/bin/env bash

function plugin_actions() {
  declare -A actions
  actions['?']="help"
  actions[q]="quit"
  actions[/]="search"

  actions[r]="ranger_dir"
  actions[t]="tre"
  actions[l]="ll"

  actions[g]="zd"
  actions[h]="move to parent folder"
  actions[j]="move to next sibling folder"
  actions[k]="move to prev sibling folder"
  actions['1-9']="select child by number"
  actions['0']="select last child"
  actions['#']="select child by number (multi-digit, type enter)"

  actions[a]="open all text files in vim"
  actions[f]="vf; # select files for vim"
  actions[v]="vr; # select most recent foles for vim"

  actions[F]="folder"
  actions[I]="images"
  actions[V]="videos"
  actions[A]="audios"
  actions[G]="git"

  echo
  hr
  P=" ${fgYellow}PLUGIN${txReset}"
  read -s -n1 -p "$P > " action
  printf " $SEP ${actions[$action]}\n\n"
  case $action in
    \?)
      for key in "${!actions[@]}"; do
        key_item $key "${actions[$key]}"
      done
      plugin_actions
      ;;
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
