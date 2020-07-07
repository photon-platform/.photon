#!/usr/bin/bash

## photon - pages - list

# TODO check $yaml should be established before  calling
function yq_r() {
  key="$1"
  echo "$yaml" | yq r - "$key"
}



function find_from_dir() {
  echo
  read -p "search files for: " search
  # results=$(grep -rilE --include=*.md -- "$search")
  results=$(grep -ril "$search" . )
  i=1
  dirs=()

  for r in $results
  do
    dir=$(dirname "$r")
    dirs+=( $dir )
    echo
    ui_list_item_number $i "$r"
    ui_list_item "$(grep -i "$search" "$r")"
    ((i++))
  done

  echo
  ui_banner "[q] return | [#] jump"
  read -n1  search_action
  case $search_action in
    [1-9]*)
      cd "${dirs[(($search_action-1))]}"
      clear
      page
      ;;
    *)
      clear
      page
      ;;
  esac
}

