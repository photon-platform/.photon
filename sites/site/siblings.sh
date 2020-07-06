#!/usr/bin/env bash

siblings=
siblings_index=
siblings_count=

function site_siblings() {

  # siblings=$(sites_dirs | sort)

  siblings=()
  while IFS=  read -r -d $'\0'; do
      siblings+=("$REPLY")
    done < <( find $SITESROOT -maxdepth 3 -type f -wholename "*/user/.photon" -print0 | sort)
  IFS=$'\n' siblings=($(sort <<<"${siblings[*]}"))
  unset IFS
  siblings_count=${#siblings[@]}

  i=0
  for sib in ${siblings[@]}
  do
    if [[ $( dirname "$sib" ) == $(pwd) ]]
    then
      siblings_index=$((i))
    fi
    ((i++))
  done

}

