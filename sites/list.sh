#!/usr/bin/env bash

function sites_dirs() {
  find $SITESROOT -maxdepth 3 -type f -wholename "*/user/.photon" | sort
}

function sites_list() {
  sites=( $( sites_dirs ))
  sites_count=${#sites[@]}

  h1 "$PWD"

  i=1

  ui_banner "sites ${SEP} ${#sites[@]}"
  echo

  for site in ${sites[@]}
  do
    dir=$(dirname "$site")

    title=$(sed -n -e 's/title: \(.*\)/\1/p' "$dir/config/site.yaml")

    ui_list_item_number $i "$title"
    ui_list_item "${fgg08}${dir#$PWD/}${txReset}"
    ((i++))
  done
  echo
}

