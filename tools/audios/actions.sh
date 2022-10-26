#!/usr/bin/env bash

function audios_actions() {

  echo
  hr

  P=" ${fgYellow}AUDIOS${txReset}"
  read -n1 -p "$P > " action
  echo
  echo
  # printf " $SEP ${actions[$action]}\n\n"
  case $action in
    \?)
      for key in "${!actions[@]}"; do 
        key_item $key "${actions[$key]}"
      done
      audios_actions
      ;;
    q) clear -x; ;;
    /) search; audios; ;;

    r) ranger_dir; audios; ;;
    t) tre; audios; ;;
    l) ll; audios_actions; ;;

    e) v README.md; audios; ;;

    g) zd; audios; ;;
    h) cd ..; audios; ;;
    '#')
      read -p "enter number: " number
      audios_select $((number - 1))
      ;;
    [1-9]) audios_select $((action - 1)) ;;
    j) folder_sibling_get $((siblings_index + 1)) ; audios;;
    k) folder_sibling_get $((siblings_index - 1)) ; audios;;
    0) audios_select $(( ${#list[@]} - 1 )) ;;
    a) 
      #view all
      mapfile -t selected_audios < <( audios_list_get )
      audios_selected_actions
      audios; ;;
    v)  
      mapfile -t selected_audios < <( audios_list_get | fzf )
      audios_selected_actions
      audios; ;;
    R) record; ;;
    F) folder; ;;
    I) images; ;;
    V) videos; ;;
    G) tools_git; audios; ;;
    *)
      audios
      ;;
  esac
}

function audios_select() {
  id=$1
  if [[ ${list[$id]} ]]; then
    audio "${list[$id]}" $id
  else
    audios
  fi
}

function audios_selected_actions() {
  if [[ ${#selected_audios[@]} != 0 ]]; then

    printf " %s\n" "${selected_audios[@]}"
    echo
    printf " selected: %s\n" "${#selected_audios[@]}"
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
        audios_actions
        ;;
      q) clear -x; ;;

      x) audios_selected_trash; ;;
      ""|o) audios_selected_play; ;;
      m) audios_selected_migrate; ;;
      E) audios_selected_exif; audios_selected_actions; ;;
      *)
        audios_selected_actions
        ;;
    esac
  fi
}

function audios_selected_play() {
  printf " %s\n" "${selected_audios[@]}" |
  mpv --keep-open=yes --playlist=-
}

function audios_selected_migrate() {
  
  hr
  ui_banner "SELECTED $SEP MIGRATE "
  echo

  project=$( ask_value "project" "$project" )
  project=$( slugify "$project" )

  activity=$( ask_value "activity" "$activity" )
  activity=$( slugify "$activity" )

  for (( i = 0; i < ${#selected_audios[@]}; i++ )); do
    img=${selected_audios[i]}

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

function audios_selected_exif() {
 echo Exif selected 
  
}

function audios_selected_trash() {
  hr
  ui_banner "SELECTED $SEP TRASH $SEP ${#selected_audios[@]}"
  echo

  if [[ "$( ask_truefalse "continue" )" == "true" ]]; then
    for (( i = 0; i < ${#selected_audios[@]}; i++ )); do
      file=${selected_audios[i]}
      echo "  $1 $SEP $file"
      gio trash "$file"
    done
  fi
}
