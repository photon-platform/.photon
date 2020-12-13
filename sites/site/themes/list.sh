#!/usr/bin/env bash
function themes_list_dirs() {
  find . -maxdepth 2 -mindepth 2 -name "blueprints.yaml" -type f | sort 
}

function themes_list() {

  list=( $(themes_list_dirs) )
  list_count=${#list[@]}

  i=1

  ui_banner "themes $SEP $list_count"
  echo

  for theme in ${list[@]}
  do
    export yaml=$(cat $theme)
    eval "$(yaml_parse theme)" 2> /dev/null

    dir=$(dirname "$theme")

    tmp=$PWD
    cd $dir
    stat=" $SEP ${fgPurple}$(git_branch) $SEP ${fgRed}$(gsss)${txReset} "
    cd $tmp
    ui_list_item_number $i "$(remove_quotes "$theme_name") $SEP $theme_version $stat"
    ((i++))
  done
  echo
}

