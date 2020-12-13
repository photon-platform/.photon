#!/usr/bin/env bash
function plugins_list_dirs() {
  find . -maxdepth 2 -mindepth 2 -name "blueprints.yaml" -type f | sort
}

function plugins_list() {

  list=( $(plugins_list_dirs) )
  list_count=${#list[@]}

  i=1

  ui_banner "plugins $SEP $list_count"
  echo

  for plugin in ${list[@]}
  do
    export yaml=$(cat $plugin)
    eval "$(yaml_parse plugin)" 2> /dev/null

    dir=$(dirname "$plugin")

    tmp=$PWD
    cd $dir
    stat=" $SEP ${fgPurple}$(git_branch) $SEP ${fgRed}$(gsss)${txReset} "
    cd $tmp
    ui_list_item_number $i "$(remove_quotes "$plugin_name") $SEP $plugin_version $stat"
    ((i++))
  done
  echo
}

