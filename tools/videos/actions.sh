#!/usr/bin/env bash

function videos_actions() {

  echo
  hr

  P=" ${fgYellow}videos${txReset}"
  read -n1 -p "$P > " action
  echo
  echo
  # printf " $SEP ${actions[$action]}\n\n"
  case $action in
    \?)
      for key in "${!actions[@]}"; do 
        key_item $key "${actions[$key]}"
      done
      videos_actions
      ;;
    q) clear -x; ;;
    /) search; videos; ;;

    r) ranger; videos; ;;
    t) tre; videos; ;;
    d) ll; videos_actions; ;;

    g) zd; videos; ;;
    h) cd ..; videos; ;;
    '#')
      read -p "enter number: " number
      videos_select $((number - 1))
      ;;
    [1-9]) videos_select $((action - 1)) ;;
    0) videos_select $(( ${#list[@]} - 1 )) ;;
    a) 
      #view all
      mapfile -t selected_videos < <( videos_list_get  | sxiv -o - )
      videos_selected_actions
      videos; ;;
    v)  
      mapfile -t selected_videos < <( videos_list_get | fzf | sxiv -o - )
      videos_selected_actions
      videos; ;;
    F) folder; ;;
    I) images; ;;
    G) tools_git; videos; ;;
    *)
      videos
      ;;
  esac
}

function videos_select() {
  id=$1
  if [[ ${list[$id]} ]]; then
    video "${list[$id]}" $id
  else
    videos
  fi
}

function videos_selected_actions() {
  if [[ ${#selected_videos[@]} != 0 ]]; then

    printf " %s\n" "${selected_videos[@]}"
    echo
    printf " selected: %s\n" "${#selected_videos[@]}"
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
        videos_actions
        ;;
      q) clear -x; ;;

      m) videos_selected_migrate; ;;
      E) videos_selected_exif; videos_selected_actions; ;;
      *)
        videos_selected_actions
        ;;
    esac
  fi
}

function videos_selected_migrate() {
  
  hr
  ui_banner "SELECTED $SEP MIGRATE "
  echo

  project=$( ask_value "project" "$project" )
  project=$( slugify "$project" )

  activity=$( ask_value "activity" "$activity" )
  activity=$( slugify "$activity" )

  for (( i = 0; i < ${#selected_videos[@]}; i++ )); do
    img=${selected_videos[i]}

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
  echo " migrated: $i"
  echo
  pause_any
}

function videos_selected_exif() {
 echo Exif selected 
  
}