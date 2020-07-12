#!/usr/bin/env bash


function theme_siblings_dirs() {
  parent_dir=$(dirname "$(pwd)") 
  find $parent_dir -maxdepth 2 -mindepth 2 -name "blueprints.yaml" -type f | sort 
}

function theme_siblings() {

  siblings=( $(theme_siblings_dirs) )
  siblings_count=${#siblings[@]}

  i=0
  for sib in ${siblings[@]}
  do
    if [[ $(dirname "$sib") == $(pwd) ]]
    then
      siblings_index=$i
    fi
    ((i++))
  done

}

