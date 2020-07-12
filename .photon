#!/usr/bin/env bash

export PROJECT=".photon"
export PROJECT_DIR="/home/phi/$"

function search_old(){
  clear
  read -p "search files for: " search
  results=($(grep -rilE \
    --include=* \
    --exclude-dir=.git \
    --exclude-dir=.atom \
    --exclude-dir=thunderbird \
    --exclude-dir=dart-sass \
    --exclude-dir=".vim" \
    -- "$search"))
  i=1
  dirs=()

  for r in ${results[@]}
  do
    filename=$(basename -- "$r")
    extension="${filename##*.}"
    filename="${filename%.*}"
    dir=$(dirname "$r")
    dirs+=( $dir )
    echo
    printf "$fmt_child" $i "$r"
    grep -in "$search" "$r"
    ((i++))
  done

  echo
  ui_banner "[r] return | [#] jump"
  read -n1  search_action
  case $search_action in
    [1-9]*)
      vim "${results[$(($search_action-1))]}"
      ;;
    *)
      clear
      ;;
  esac
}

