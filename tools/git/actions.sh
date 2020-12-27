#!/usr/bin/env bash

function tools_git_actions() {
  declare -A actions
  actions['?']="help"
  actions[q]="quit"
  actions[g]="zd"
  actions[h]="cd .."
  actions[l]="git log --graph --oneline"
  actions[d]="git diff ."
  actions[a]="git add ."
  actions[c]="git commit"
  actions[p]="git push "
  actions[u]="git pull --recurse-submodules"
  actions[S]="SUBMODULES"

  echo
  hr
  P=" ${fgYellow}GIT${txReset}"
  read -n1 -p "$P > " action
  printf " $SEP ${actions[$action]}\n\n"
  case $action in
    \?)
      for key in "${!actions[@]}"; do
        key_item $key "${actions[$key]}"
      done
      tools_git_actions
      ;;
    q) clear -x; ;;

    r) ranger_dir; tools_git; ;;
    t) tre; tools_git; ;;

    g) zd;  tools_git; ;;
    h) cd ..;  tools_git; ;;
    j) folder_sibling_get $((siblings_index + 1)); tools_git ;;
    k) folder_sibling_get $((siblings_index - 1)); tools_git ;;

    l) git log --graph --oneline; tools_git  ;;
    d) git diff .; pause_enter; tools_git  ;;
    a) git add .;  tools_git  ;;
    c) git commit;  tools_git  ;;
    p) git push; pause_enter;  tools_git  ;;
    u) git pull --recurse-submodules; pause_enter;  tools_git  ;;
    S) tools_git_submodules;  tools_git  ;;
    *)
      clear
      tools_git
      ;;
  esac

}
