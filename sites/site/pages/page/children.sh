#!/usr/bin/env bash

children=()
children_count=0

function page_children() {

  children=()
  while IFS=  read -r -d $'\0'; do
      children+=("$REPLY")
  done < <(find . -maxdepth 2 -mindepth 2 -name "*.md" -type f -print0 | sort )
  IFS=$'\n' children=($(sort <<<"${children[*]}"))
  unset IFS

  children_count=${#children[@]}

  ui_banner "children [$children_count]:"

  i=1
  dirs=()

  for f in ${children[@]}
  do
    # dir=$(dirname "$f")
    # dirs+=( $dir )

    yaml=$(cat $f | sed -n '/---/,/---/p')
    title="$(yq_r title )"
    subtitle="$(yq_r subtitle )"

    ui_list_item_number $i "$title"
    ui_list_item "$subtitle"
    ui_list_item "$f"
    ((i++))
  done
  echo
}

function test_list() {
children=()
while IFS=  read -r -d $'\0'; do
    children+=("$REPLY")
done < <(find . -maxdepth 2 -mindepth 2 -name "*.md" -type f -print0 | sort )
IFS=$'\n' children=($(sort <<<"${children[*]}"))
unset IFS
echo ${children[@]}
}
