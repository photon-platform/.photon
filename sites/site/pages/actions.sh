#!/usr/bin/env bash

function pages_actions() {
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

  actions['@']="site"
  actions[e]="vim README.md"
  actions[b]="renumber child folders"
  actions[n]="add new child page"

  actions[F]="folder"
  actions[I]="images"
  actions[V]="videos"
  actions[A]="audios"
  actions[G]="git"

  echo
  hr
  P=" ${fgYellow}ARTICLES${txReset}"
  read -s -n1 -p "$P > " action
  printf " $SEP ${actions[$action]}\n\n"
  case $action in
    \?)
      for key in "${!actions[@]}"; do
        key_item $key "${actions[$key]}"
      done
      pages_actions
      ;;
    q) clear -x; ;;
    @) site ;;
    /) search; pages; ;;
    
    r) ranger; pages; ;;
    t) tre; pages; ;;
    l) ll; echo; pages_actions; ;;

    e) v README.md; pages; ;;

    g) zd; page; ;;
    h) cd ..; site; ;;
    k) cd ../plugins; plugins; ;;
    j) cd ../themes; themes; ;;
    '#')
      read -p "enter number: " number
      if [[ ${children[$((number - 1))]} ]]; then
        dir="$(dirname ${children[((number-1))]})"
        if [[ -d "$dir" ]]; then
          cd "$dir"
        fi
      fi
      page
      ;;
    [1-9]*)
      if [[ ${children[$((action - 1))]} ]]; then
        dir="$(dirname ${children[((action-1))]})"
        if [[ -d "$dir" ]]; then
          cd "$dir"
        fi
      fi
      page
      ;;
    0)
      last=$(( ${#children[@]} - 1 ))
      cd $(dirname ${children[ last ]})
      page
      ;;
    a)
      vim "${children[@]}"
      ;;
    f) vf; pages; ;;
    v) vr; pages; ;;
    F) folder; ;;
    I) images; ;;
    T) taxonomy; page; ;;
    G) tools_git; pages ;;
    b)
      page_children_renumber
      clear
      pages
      ;;
    n) clear; pages_new; clear; page; ;;
    *)
      pages
      ;;
  esac
}
