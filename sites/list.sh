#!/usr/bin/env bash

function sites_dirs() {
  find $SITESROOT -maxdepth 2 -type d -name user | sort
}

function sites_list() {
  # sites=$(sites_dirs)
  sites=()
  while IFS=  read -r -d $'\0'; do
      sites+=("$REPLY")
    done < <( find $SITESROOT -maxdepth 3 -type f -wholename "*/user/.photon" -print0 | sort)
  IFS=$'\n' sites=($(sort <<<"${sites[*]}"))
  unset IFS
  sites_count=${#sites[@]}

  i=1
  # dirs=()

  ui_banner "sites:"

  for site in ${sites[@]}
  do
    # filename=$(basename -- "$site")
    # extension="${filename##*.}"
    # filename="${filename%.*}"
    dir=$(dirname "$site")
    # dirs+=( $site )

    title=$(sed -n -e 's/title: \(.*\)/\1/p' "$dir/config/site.yaml")

    # echo -e "$i\t$title $gscount"
    ui_list_item_number $i "$title"
    ui_list_item "${dir}"
    ((i++))
  done
  echo
}

