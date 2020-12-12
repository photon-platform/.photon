#!/usr/bin/env bash

function images_actions() {

  # TODO: show all menu options on '?'
  ui_footer "IMAGES actions: "

  read -s -n1 -p " > "  action
  case $action in
    q) clear; ;;
    /) search; clear; images; ;;

    r) ranger; clear; images; ;;
    t) tre; clear; images; ;;
    d) ll; echo; images_actions; ;;

    g) zd; clear; images; ;;
    h) cd ..; clear; images; ;;
    '#')
      read -p "enter number: " number
      id=$((number - 1))
      if [[ ${list[$id]} ]]; then
        clear
        image "${list[$id]}" $id
      else
        clear
        images
      fi
      ;;
    [1-9]*)
      id=$((action - 1))
      if [[ ${list[$id]} ]]; then
        clear
        image "${list[$id]}" $id
      else
        clear
        images
      fi
      ;;
    # 0)
      # last=$(( ${#children[@]} - 1 ))
      # cd $(dirname ${children[ last ]})
      # clear
      # page
      # ;;
    a)  echo; images_list_get | sxiv -o - ; pause_enter; clear; images ;;
    f)  echo; images_list_get | fzf | sxiv -o - ; pause_enter; clear; images; ;;
    # T) taxonomy; clear; page; ;;
    G) tools_git; clear; images; ;;
    *)
      clear
      images
      ;;
  esac
}
