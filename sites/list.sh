#!/usr/bin/env bash

function sites_dirs() {
  find $SITESROOT -maxdepth 3 -type f -wholename "*/user/.photon" | sort
}

function sites_list() {
  sites=( $( sites_dirs ))
  sites_count=${#sites[@]}

  i=1

  # ui_banner "sites ${SEP} ${#sites[@]}"
  echo

  for site in ${sites[@]}
  do
    dir=$(dirname "$site")

    tmp=$PWD
    cd $dir
    title=$(sed -n -e 's/title: \(.*\)/\1/p' "config/site.yaml")
    title+=" $SEP ${fgPurple}$(git_branch) $SEP ${fgRed}$(gsss)${txReset} "
    cd $tmp

    ui_list_item_number $i "$title"
    ui_list_item "${fgg08}${dir#$PWD/}${txReset}"
    ((i++))
  done
  echo
}

