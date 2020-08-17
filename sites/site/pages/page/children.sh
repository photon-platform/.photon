#!/usr/bin/env bash

function page_children_dirs() {
  find . -maxdepth 2 -mindepth 2 -name "*.md" -type f | sort 
}

function page_children() {

  children=( $(page_children_dirs) )
  children_count=${#children[@]}

  ui_banner "children [$children_count]:"

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
    ui_list_item "$md"

    ((i++))
  done
  echo
}

function test_list_nullsep() {
  children=()
  while IFS=  read -r -d $'\0'; do
      children+=("$REPLY")
  done < <(find . -maxdepth 2 -mindepth 2 -name "*.md" -type f -print0 | sort )
  IFS=$'\n' children=($(sort <<<"${children[*]}"))
  unset IFS
  echo ${children[@]}
}


function page_children_renumber() {
  ui_banner "renumber children:"

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
