#!/usr/bin/env bash

# function image_siblings() {
  
# }

function image_actions() {

  hr
  P=" ${fgYellow}IMAGE${txReset}"
  read -s -n1 -p "$P > " action
  case $action in
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
    *)
      clear
      image "$file" $image_index;
      ;;
  esac
}
