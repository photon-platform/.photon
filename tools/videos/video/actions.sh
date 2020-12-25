#!/usr/bin/env bash

function video_actions() {
  declare -A actions
  actions['?']="help"
  actions[q]="quit"

  actions[v]="mpv"
  actions[m]="video_migrate"
  actions[x]="video_trash"

  actions[h]="back to videos"
  actions[j]="move to next sibling video"
  actions[k]="move to prev sibling video"
  actions['#']="select child by number (multi-digit, type enter)"

  actions[E]="Exif"

  echo
  hr
  P=" ${fgYellow}video${txReset}"
  read -n1 -p "$P > " action
  printf " $SEP ${actions[$action]}\n\n"
  case $action in
    \?)
      for key in "${!actions[@]}"; do
        key_item $key "${actions[$key]}"
      done
      video_actions
      ;;
    q) videos; ;;
    m) video_migrate "$file"; videos; ;;
    x) video_trash "$file"; videos; ;;
    v) mpv "$file" --keep-open=yes; video "$file" $video_index; ;;
    h) videos ;;
    j)
      id=$((video_index + 1))
      if [[ ${list[$id]} ]]; then
        video "${list[$id]}" $id
      else
        video "$file" $video_index
      fi
      ;;
    k)
      id=$((video_index - 1))
      if [[ ${list[$id]} ]]; then
        video "${list[$id]}" $id
      else
        video "$file" $video_index
      fi
      ;;
    E) tools_exif_actions;
      video "$file" $video_index
      ;;
    *)
      video "$file" $video_index;
      ;;
  esac
}

function video_migrate() {
  img=$1

  hr
  ui_banner "MIGRATE $SEP $img"
  echo

  ext=${img##*.}
  ext=$( slugify "$ext" )

  project=$( ask_value "project" "$project" )
  project=$( slugify "$project" )

  activity=$( ask_value "activity" "$activity" )
  activity=$( slugify "$activity" )

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
    c++
  done
  img_path+=".$ext"

  echo
  ui_banner "Migrate to "
  h1 "$img_path"
  mkdir -p "$img_folder"
  mv "$img" "$img_path"
  pause_any
}


function video_trash() {
  img=$1

  hr
  ui_banner "TRASH $SEP $img"
  echo

  if [[ "$( ask_truefalse "continue" )" == "true" ]]; then
    gio trash "$img"
    
  fi

}
