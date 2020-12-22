#!/usr/bin/env bash

function image_actions() {
  declare -A actions
  actions['?']="help"
  actions[q]="quit"

  actions[e]="gimp"
  actions[v]="sxiv"
  actions[d]="darktable"
  actions[m]="image_migrate"

  actions[h]="back to images"
  actions[j]="move to next sibling image"
  actions[k]="move to prev sibling image"
  actions['#']="select child by number (multi-digit, type enter)"

  actions[E]="Exif"

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
    q) images; ;;
    m) image_migrate "$file"; images; ;;
    e) gimp "$file"; image "$file" $image_index; ;;
    v) sxiv "$file"; image "$file" $image_index; ;;
    d) darktable "$file"; image "$file" $image_index; ;;
    h) images ;;
    j)
      id=$((image_index + 1))
      if [[ ${list[$id]} ]]; then
        image "${list[$id]}" $id
      else
        image "$file" $image_index
      fi
      ;;
    k)
      id=$((image_index - 1))
      if [[ ${list[$id]} ]]; then
        image "${list[$id]}" $id
      else
        image "$file" $image_index
      fi
      ;;
    E) tools_exif_actions;
      image "$file" $image_index
      ;;
    *)
      image "$file" $image_index;
      ;;
  esac
}

function image_migrate() {
  img=$1

  hr
  ui_banner "MIGRATE $SEP $img"
  echo

  ext=${img##*.}
  ext=$( slugify "$ext" )

  img_project=$( ask_value "project" "$img_project" )
  img_project=$( slugify "$img_project" )

  img_activity=$( ask_value "activity" "$img_activity" )
  img_activity=$( slugify "$img_activity" )

  img_dt=$( exiftool -DateTimeOriginal "$img" -S | \
    sed -n 's/^DateTimeOriginal\: \(.*\)/\1/p' | \
    tr ":" " "  \
    )
  img_folder="$HOME/Media/$img_project/"
  img_folder+=$( echo $img_dt | awk '{printf "%s/%s/%s/", $1, $2, $3}' )

  img_file=$( echo $img_dt | awk '{printf "%s%s%s", $4, $5, $6}' )
  img_file+="-$img_activity"

  img_path="$img_folder$img_file"

  i=1
  while [[ -f "$img_path.$ext" ]]; do
    img_path="$img_folder$img_file.$i"
  done
  img_path+=".$ext"

  echo
  ui_banner "Migrate to "
  h1 "$img_path"
  mkdir -p "$img_folder"
  mv "$img" "$img_path"
  pause_any
}
