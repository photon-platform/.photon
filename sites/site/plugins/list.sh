#!/usr/bin/env bash

function plugins_list() {

  # list=$(find . \
    # -maxdepth 1 \
    # -mindepth 1 \
    # -not -path "./LOGS" \
    # -not -path "./grav" \
    # -type d \
    # | sort)

  list=()
  while IFS=  read -r -d $'\0'; do
      list+=("$REPLY")
  done < <(find . -maxdepth 2 -mindepth 2 -name "blueprints.yaml" -type f -print0 | sort )
  IFS=$'\n' list=($(sort <<<"${list[*]}"))
  unset IFS

  i=1
  dirs=()

  ui_banner "plugins:"

  for plugin in ${list[@]}
  do
    # filename=$(basename -- "$plugin")
    # extension="${filename##*.}"
    # filename="${filename%.*}"
    # dir=$(dirname "$plugin")
    # dirs+=( $dir )

    # gsss

    # echo -e "$i\t$title $gscount"
    ui_list_item_number $i "$plugin"
    ((i++))
  done
  echo
}

