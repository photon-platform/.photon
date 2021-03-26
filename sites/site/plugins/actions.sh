#!/usr/bin/env bash

function plugins_actions() {
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

  actions[n]="new plugin"
  actions[c]="create new submodule"
  actions[b]="restore plugin from github"

  actions[F]="folder"
  actions[I]="images"
  actions[V]="videos"
  actions[A]="audios"
  actions[G]="git"

  echo
  hr
  P=" ${fgYellow}PLUGINS${txReset}"
  read -s -n1 -p "$P > " action
  printf " $SEP ${actions[$action]}\n\n"
  case $action in
    \?)
      for key in "${!actions[@]}"; do
        key_item $key "${actions[$key]}"
      done
      plugins_actions
      ;;
    q) clear -x; ;;
    @) site ;;
    /) search; plugins; ;;

    r) ranger_dir; folder; ;;
    t) tre; plugins; ;;
    l) ll; plugins_actions; ;;

    e) v README.md; plugins; ;;

    g) zd; folder ;;
    h) site; ;;
    j) cd ../pages; pages; ;;
    '#')
      read -p "enter number: " number
      dir="$(dirname ${list[((number-1))]})"
      cd $dir
      plugin
      ;;
    [1-9]*)
      cd "$( dirname ${list[(($action-1))]} )"
      # read
      plugin
      ;;

    f) vf; plugins;;
    v) vr; pages; ;;

    F) folder; ;;
    I) images; ;;
    G)
      tools_git
      plugins
      ;;
    n)
      # new plugin from template
      pr
      bin/plugin photon newplugin
      ;;
    c) plugin_create_submodule ;;
    b) plugin_restore;  ;;
    remove) plugin_remove_submodule ;;
    *)
      plugins
      ;;
  esac

}
