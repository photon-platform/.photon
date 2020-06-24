#!/usr/bin/env bash

function sites_list() {
  sites=$(find . \
    -type f \
    -wholename "*user/config/site.yaml" \
    | sort)

  i=1
  dirs=()

  ui_banner "sites:"

  for site in $sites
  do
    filename=$(basename -- "$site")
    extension="${filename##*.}"
    filename="${filename%.*}"
    dir=$(dirname "$site")
    dirs+=( $dir )

    title=$(sed -n -e 's/title: \(.*\)/\1/p' $site)

    # gscount=$(git status -sb $dir | wc -l)
    ((gscount--))

    if (( gscount > 0 ));
    then
      gscount=" [$gscount]"
    else
      gscount=""
    fi

    # echo -e "$i\t$title $gscount"
    ui_list_item_number $i "$title"
    ui_list_item "${dir%/user/config}"
    ((i++))
  done
  echo
}

