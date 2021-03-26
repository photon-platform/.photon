#!/usr/bin/env bash

function theme_actions() {
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
  P=" ${fgYellow}THEME${txReset}"
  read -s -n1 -p "$P > " action
  printf " $SEP ${actions[$action]}\n\n"
  printf " $SEP ${actions[$action]}\n\n"
  case $action in
    \?)
      for key in "${!actions[@]}"; do
        key_item $key "${actions[$key]}"
      done
      theme_actions
      ;;
    q) clear -x; ;;
    @) cd ..; site ;;
    /) search; theme; ;;
    
    r) ranger_dir; folder; ;;
    t) tre; theme; ;;
    l) ll; echo; theme_actions; ;;

    e) v README.md ; theme; ;;
    c) v CHANGELOG.md; theme; ;;
    .) v blueprints.yaml ; theme; ;;

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
