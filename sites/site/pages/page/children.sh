#!/usr/bin/env bash

function page_children_dirs() {
  find . -maxdepth 2 -mindepth 2 -name "*.md" -type f | sort 
}

function page_children() {
  children=( $(page_children_dirs) )
  children_count=${#children[@]}

  ui_banner "children ${fgg08}•${txReset} $children_count"
  echo

  i=1

  for md in ${children[@]}
  do
    yaml="$(cat $md | sed -n -e '/^---$/,/^---$/{ /^---$/d; /^---$/d; p; }')"
    # yaml=$(cat $md | sed -n '/---/,/---/p')
    title=$( echo "$yaml" | sed -n -e 's/^title: \(.*\)/\1/p' )
    subtitle=$( echo "$yaml" | sed -n -e 's/^subtitle: \(.*\)/\1/p' )

    ui_list_item_number $i "$title"
    if [[ $subtitle ]]
    then
      ui_list_item "$subtitle"
    fi
    ui_list_item "${fgg08}${md#./}${txReset}"

    ((i++))
  done
  echo
}

function page_child_get() {
  id=$1
  dir=$(dirname ${children[$id]})
  if [[ -d "$dir" ]]
  then
    cd "$dir"
  fi
  clear
  page
}

function page_children_renumber() {
  ui_header "renumber children:"

  i=1
  dirs=()

  children=( $(page_children_dirs) )
  children_count=${#children[@]}

  for f in ${children[@]}; do
    dir=$(dirname "$f")
    dirs+=( $dir )

    dname=$(basename -- "$dir")
    name="${dname#*.}"
    num="${dname%%.*}"

    if [[ "$num" =~ ^[0-9]+$ ]]; then
      printf -v newnum "%02d" $i
      ui_list_item_number $i "$newnum $name"
      ui_list_item  "$dname"
    else
      echo "not a numbered folder"
    fi
    ((i++))
  done
  echo

  ask=$(ask_truefalse "continue")
  echo
  if [[ $ask == "true" ]]; then
    for (( i = $(( ${#children[@]}-1 )); i>= 0; i-- )); do
      f=${children[$i]}
      dir=$(dirname "$f")
      dname=$(basename -- "$dir")
      name="${dname#*.}"
      num="${dname%%.*}"
      if [[ "$num" =~ ^[0-9]+$ ]]; then
        printf -v newnum "%02d" $(( i + 1 ))
        newdname="$newnum.$name"
        ui_list_item_number $i "$newdname"
        ui_list_item  "$dname"
        if [[ "$dname" != "$newdname" ]]; then
          mv -n "$dname" "$newdname"
        fi
      else
        echo "not a numbered folder"
      fi
    done
    ask=$(ask_truefalse "any key continue")
    echo
  fi
}
