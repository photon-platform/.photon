#!/usr/bin/env bash

function themes_actions() {
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
  P=" ${fgYellow}THEMES${txReset}"
  read -s -n1 -p "$P > " action
  printf " $SEP ${actions[$action]}\n\n"
  case $action in
    \?)
      for key in "${!actions[@]}"; do
        key_item $key "${actions[$key]}"
      done
      themes_actions
      ;;
    q) clear -x; ;; # quit
    @) site ;;
    /) search; themes; ;;

    r) ranger_dir; folder; ;;
    t) tre; themes; ;;
    l) ll; themes_actions; ;;

    e) v README.md; pages; ;;

    g) zd; folder ;;
    h) site; ;;
    k) cd ../pages; pages; ;;
    '#')
      read -p "enter number: " number
      dir="$(dirname ${list[((number-1))]})"
      cd $dir
      theme
      ;;
    [1-9]*)
      cd "$( dirname ${list[(($action-1))]} )"
      # read
      theme
      ;;
    f) vf; themes;;
    v) vr; pages; ;;
    F) folder; ;;
    I) images; ;;
    G)
      tools_git
      themes
      ;;
    *)
      themes
      ;;
  esac

}
