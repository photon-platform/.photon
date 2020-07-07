#!/usr/bin/env bash


function site_siblings() {

  # siblings=$(sites_dirs | sort)

  siblings=( $( sites_dirs ))
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

