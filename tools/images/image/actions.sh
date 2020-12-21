#!/usr/bin/env bash

# function image_siblings() {
  
# }

function image_actions() {
  declare -A actions
  actions['?']="help"
  actions[q]="quit"

  actions[e]="gimp"
  actions[v]="sxiv"
  actions[d]="darktable"

  actions[h]="back to images"
  actions[j]="move to next sibling image"
  actions[k]="move to prev sibling image"
  actions['#']="select child by number (multi-digit, type enter)"

  actions[f]="vf"
  actions[v]="vr"

  actions[I]="images"
  actions[G]="git"

  echo
  hr
  P=" ${fgYellow}IMAGE${txReset}"
  read -n1 -p "$P > " action
  printf " $SEP ${actions[$action]}\n\n"
  case $action in
    \?)
      for key in "${!actions[@]}"; do 
        key_item $key "${actions[$key]}"
      done
      image_actions
      ;;
    q) clear; images; ;;
    e) gimp "$file"; clear; image "$file" $image_index; ;;
    v) sxiv "$file"; clear; image "$file" $image_index; ;;
    d) darktable "$file"; clear; image "$file" $image_index; ;;
    h) clear; images ;;
    j)
      id=$((image_index + 1))
      if [[ ${list[$id]} ]]; then
        clear
        image "${list[$id]}" $id
      else
        clear
        image "$file" $image_index
      fi
      ;;
    k)
      id=$((image_index - 1))
      if [[ ${list[$id]} ]]; then
        clear
        image "${list[$id]}" $id
      else
        clear
        image "$file" $image_index
      fi
      ;;
    # T) taxonomy; clear; page; ;;
    E) tools_exif_actions; 
      image "$file" $image_index
      ;;
    *)
      image "$file" $image_index;
      ;;
  esac
}

