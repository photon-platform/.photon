#!/usr/bin/bash


function search() {
  if [[ -z $1 ]]
  then
    echo
    read -p "search files for: " search
  else
    search=$1
  fi

  results=( $(grep \
   -rilE \
   --exclude-dir="vendor" \
   --exclude-dir="node_modules" \
   --exclude-dir=".git" \
   --exclude="tags" \
   --exclude="*.min.js" \
   --exclude="*.min.css" \
   --exclude="*.pack.js" \
   --exclude="*.map" \
   --exclude="grav.index" \
   -- \
   "$search" \
   . ) )
  i=1

  for r in ${results[@]}
  do
    echo
    ui_list_item_number $i "$r"
    grep -i "$search" "$r"
    ((i++))
  done

  echo
  ui_footer "[q] return | [#] jump"
  read -n1  search_action
  case $search_action in
    '#')
      read -p "enter number: " number
      if [[ ${results[(($search_action-1))]} ]]; then
          vim -c "/$search/" "${results[(($search_action-1))]}"
      fi
      ;;
    [1-9]*)
      if [[ ${results[(($search_action-1))]} ]]; then
          vim -c "/$search/" "${results[(($search_action-1))]}"
      fi
      ;;
    a)
      vim -c "/$search/" "${results[@]}"
      ;;
    q)
      # clear
      # page
      ;;
  esac
}

