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
    ui_list_item "$subtitle"
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
