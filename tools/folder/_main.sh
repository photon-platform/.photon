#!/usr/bin/env bash

source ~/.photon/tools/folder/list.sh
source ~/.photon/tools/folder/children.sh
source ~/.photon/tools/folder/siblings.sh

source ~/.photon/tools/folder/actions.sh

alias F=folder
function folder() {
  
  clear -x

  ui_header "FOLDER $SEP $PWD"

  folder_siblings
  h2 "$(( siblings_index + 1 )) ${fgg08}of${txReset} $siblings_count"
  show_dir

  folder_summarize

  folder_children
  h1 "Total $SEP $(folder_total_bytes "$PWD") ${fgg08}KiB${txReset}"
  echo

  folder_actions
}

function folder_total_bytes() {
  printf "%'.f\n" $( du -s "$1" | awk '{ print $1}' ) 
}

function folder_summarize() {
  ui_banner "files $SEP $(find "$PWD" -type f ! -wholename "*.git/*" | wc -l)"
  echo
   
  # list_working_files | xargs -I {} basename "{}" |  sed 's/.*\.\(.*\)$/\1/' | sort | uniq -c | sort -nr | head -n20

  # declare -A ext_summary
  # extensions=$( list_working_files | xargs -I {} basename "{}" |  sed 's/.*\.\(.*\)$/\1/' )
  # for ext in ${extensions[@]}; do
    # (( ext_summary[$ext]++ ))
  # done

  # for key in ${!ext_summary[@]}
  # do
    # printf " %6d $SEP %s\n" "${ext_summary[$key]}" $key
  # done | sort -rn | head -n20

  echo
  
}
