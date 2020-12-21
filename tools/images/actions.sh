#!/usr/bin/env bash

function images_actions() {

  echo
  hr

  P=" ${fgYellow}IMAGES${txReset}"
  read -n1 -p "$P > " action
  printf " $SEP ${actions[$action]}\n\n"
  case $action in
    \?)
      for key in "${!actions[@]}"; do 
        key_item $key "${actions[$key]}"
      done
      images_actions
      ;;
    q) clear -x; ;;
    /) search; images; ;;

    r) ranger; images; ;;
    t) tre; images; ;;
    d) ll; images_actions; ;;

    g) zd; images; ;;
    h) cd ..; images; ;;
    '#')
      read -p "enter number: " number
      id=$((number - 1))
      if [[ ${list[$id]} ]]; then
        image "${list[$id]}" $id
      else
        images
      fi
      ;;
    [1-9]*)
      id=$((action - 1))
      if [[ ${list[$id]} ]]; then
        image "${list[$id]}" $id
      else
        images
      fi
      ;;
    # 0)
      # last=$(( ${#children[@]} - 1 ))
      # cd $(dirname ${children[ last ]})
      # page
      # ;;
    a)  echo; images_list_get | sxiv -o - ; pause_enter; images ;;
    f)  echo; images_list_get | fzf | sxiv -o - ; pause_enter; images; ;;
    # T) taxonomy; page; ;;
    F) folder; ;;
    G) tools_git; images; ;;
    *)
      images
      ;;
  esac
}
