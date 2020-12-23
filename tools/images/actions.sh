#!/usr/bin/env bash

function images_actions() {

  echo
  hr

  P=" ${fgYellow}IMAGES${txReset}"
  read -n1 -p "$P > " action
  echo
  echo
  # printf " $SEP ${actions[$action]}\n\n"
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
    [1-9]) images_select $((action - 1)) ;;
    0) images_select $(( ${#list[@]} - 1 )) ;;
    a) 
      #view all
      mapfile -t selected_images < <( images_list_get  | sxiv -o - )
      images_selected_actions
      images; ;;
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

      m) images_selected_migrate; ;;
      E) images_selected_exif; images_selected_actions; ;;
      *)
        images_selected_actions
        ;;
    esac
  fi
}

function images_selected_migrate() {
  
  hr
  ui_banner "SELECTED $SEP MIGRATE $SEP $img"
  echo

  project=$( ask_value "project" "$project" )
  project=$( slugify "$project" )

  activity=$( ask_value "activity" "$activity" )
  activity=$( slugify "$activity" )

  for (( i = 0; i < ${#selected_images[@]}; i++ )); do
    img=${selected_images[i]}

    ext=${img##*.}
    ext=$( slugify "$ext" )
    img_dt=$( exiftool -DateTimeOriginal "$img" -S | \
      sed -n 's/^DateTimeOriginal\: \(.*\)/\1/p' | \
      tr ":" " "  \
      )
    img_folder="$HOME/Media/$project/"
    img_folder+=$( echo $img_dt | awk '{printf "%s/%s/%s/", $1, $2, $3}' )

    img_file=$( echo $img_dt | awk '{printf "%s%s%s", $4, $5, $6}' )
    img_file+="-$activity"

    img_path="$img_folder$img_file"

    c=1
    while [[ -f "$img_path.$ext" ]]; do
      img_path="$img_folder$img_file.$c"
      ((c++))
    done
    img_path+=".$ext"

    echo
    h2 "     $img"
    h1 " to: $img_path"

    mkdir -p "$img_folder"
    mv "$img" "$img_path"
    
  done
  pause_any
}

function images_selected_exif() {
 echo Exif selected 
  
}
