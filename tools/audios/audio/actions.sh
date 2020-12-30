#!/usr/bin/env bash

function audio_actions() {
  declare -A actions
  actions['?']="help"
  actions[q]="quit"

  actions[p]="mpv"
  actions[m]="audio_migrate"
  actions[x]="audio_trash"

  actions[h]="back to audios"
  actions[j]="move to next sibling audio"
  actions[k]="move to prev sibling audio"
  actions['#']="select child by number (multi-digit, type enter)"

  actions[E]="Exif"

  echo
  hr
  P=" ${fgYellow}AUDIO${txReset}"
  read -n1 -p "$P > " action
  printf " $SEP ${actions[$action]}\n\n"
  case $action in
    \?)
      for key in "${!actions[@]}"; do
        key_item $key "${actions[$key]}"
      done
      audio_actions
      ;;
    q) audios; ;;
    n) image_rename "$file"; audios; ;;
    m) audio_migrate "$file"; audios; ;;
    x) audio_trash "$file"; audios; ;;
    p) mpv "$file" --keep-open=yes; audio "$file" $audio_index; ;;
    h) audios ;;
    j)
      id=$((audio_index + 1))
      if [[ ${list[$id]} ]]; then
        audio "${list[$id]}" $id
      else
        audio "$file" $audio_index
      fi
      ;;
    k)
      id=$((audio_index - 1))
      if [[ ${list[$id]} ]]; then
        audio "${list[$id]}" $id
      else
        audio "$file" $audio_index
      fi
      ;;
    i) exiftool "$file" | less ; audio "$file" $audio_index; ;;
    E) tools_exif_actions;
      audio "$file" $audio_index
      ;;
    *)
      audio "$file" $audio_index;
      ;;
  esac
}

function audio_migrate() {
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
    (( c++ ))
  done
  img_path+=".$ext"

  echo
  img_path=$( ask_value "migrate to" "$img_path" ) 
  mkdir -p "$img_folder"
  mv "$img" "$img_path"
}


function audio_trash() {
  img=$1

  hr
  ui_banner "TRASH $SEP $img"
  echo

  if [[ "$( ask_truefalse "continue" )" == "true" ]]; then
    gio trash "$img"
    
  fi

}
