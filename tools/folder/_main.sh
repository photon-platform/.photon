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

  ui_banner "files $SEP $(find $PWD -type f ! -wholename "*.git/*" | wc -l)"
  echo
  # find $PWD -type f ! -wholename "*.git/*" | xargs -I {} basename "{}" | sed 's/.*\.\(.*\)$/\1/' | sort | uniq -c | sort -nr | head -n20
  list_working_files | xargs -I {} basename "{}" | sed 's/.*\.\(.*\)$/\1/' | sort | uniq -c | sort -nr | head -n20
  echo

  folder_children
  h1 "Total $SEP $(folder_total_bytes $PWD) ${fgg08}KiB${txReset}"
  echo

  folder_actions
}

function folder_total_bytes() {
 printf "%'.f\n" $( du -s "$1" | awk '{ print $1}' ) 
}
