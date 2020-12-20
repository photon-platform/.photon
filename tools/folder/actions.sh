#!/usr/bin/env bash

function folder_actions() {

  hr
  P=" ${fgYellow}FOLDER${txReset}"
  read -s -n1 -p "$P > " action
  case $action in
    q) clear -x; ;;
    /) search; folder; ;;

    r) ranger_dir; folder; ;;
    t) tre; folder; ;;
    d) ll; folder_actions; ;;

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
    j) folder_sibling_get $((siblings_index + 1)) ;;
    k) folder_sibling_get $((siblings_index - 1)) ;;
    # a)  echo; folder_list_get | sxiv -o - ; pause_enter; clear; folder ;;
    f) vf; folder; ;;
    G) tools_git; folder; ;;
    I) images; folder; ;;
    *)
      clear
      folder
      ;;
  esac
}
