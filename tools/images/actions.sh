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
      images_select $((number - 1))
      ;;
    [1-9])
      images_select $((action - 1))
      ;;
    0)
      images_select $(( ${#list[@]} - 1 ))
      ;;
    a)  echo; images_list_get | sxiv -o - ; pause_enter; images ;;
    v)  
      mapfile -t selected_images < <( images_list_get | fzf | sxiv -o - )
      images_selected_actions
      images; ;;
    F) folder; ;;
    G) tools_git; images; ;;
    *)
      images
      ;;
  esac
}


function images_select() {
  id=$1
  if [[ ${list[$id]} ]]; then
    image "${list[$id]}" $id
  else
    images
  fi
}

function images_selected_actions() {
  if [[ ${#selected_images[@]} != 0 ]]; then

    printf " %s\n" "${selected_images[@]}"
    echo
    hr

    P=" ${fgYellow}SELECTED${txReset}"
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

      m) echo migrate selected; ;;
      E) echo Exif selected; images_selected_actions; ;;
      *)
        images_selected_actions
        ;;
    esac
  fi
  
}
