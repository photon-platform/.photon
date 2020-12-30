#!/usr/bin/env bash

function folder_actions() {
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

  actions[I]="images"
  actions[V]="videos"
  actions[A]="audios"
  actions[G]="git"
  actions[S]="sites"
  actions[s]="site"

  echo
  hr

  P=" ${fgYellow}FOLDER${txReset}"
  read -n1 -p "$P > " action
  printf " $SEP ${actions[$action]}\n\n"
  case $action in
    \?)
      for key in "${!actions[@]}"; do
        key_item $key "${actions[$key]}"
      done
      folder_actions
      ;;
    q) clear -x; ;;
    /) search; folder; ;;

    r) ranger_dir; folder; ;;
    t) tre; folder; ;;
    l) ll; folder_actions; ;;

    e) v README.md; folder; ;;

    g) zd; folder; ;;
    h) cd ..; folder; ;;
    '#')
      read -p "enter number: " number
      id=$((number - 1))
      if [[ ${children[$id]} ]]; then
        cd "${children[$id]}"
      fi
      folder
      ;;
    [1-9]*)
      id=$((action - 1))
      if [[ ${children[$id]} ]]; then
        cd "${children[$id]}"
      fi
      folder
      ;;
    0)
      # get last item
      id=$(( ${#children[@]} - 1 ))
      if [[ ${children[$id]} ]]; then
        cd "${children[$id]}"
      fi
      folder
      ;;
    j) folder_sibling_get $((siblings_index + 1)) ; folder;;
    k) folder_sibling_get $((siblings_index - 1)) ; folder;;

    a) vim $( list_text_files ); folder; ;;
    f) vf; folder; ;;
    v) vr; folder; ;;

    G) tools_git; folder; ;;
    A) audios; ;;
    V) videos; ;;
    I) images; ;;
    s) site; ;;
    S) sites; ;;
    *)
      folder
      ;;
  esac
}
