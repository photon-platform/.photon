#!/usr/bin/env bash

declare -A scaffolds

function scaffolds_list() {
  find $PROJECT_DIR -type f -wholename "**/scaffolds/*.md"
}

function scaffolds_select ()
{
  for scf in $(scaffolds_list)
  do
    key="$( basename $scf )"
    # echo $scf;
    # echo $key
    scaffolds[$key]=$scf;
  done;
  key=$( scaffolds_keys | sort | fzf );
  echo ${scaffolds[$key]}
}

function scaffolds_keys ()
{
  for key in ${!scaffolds[@]};
  do
    echo $key;
  done
}

function scaffold_vars() {
  sed -n -e 's/.*\${\(.*\)}.*/\1/p' $1
}

function scaffold_edit() {
  v $( scaffolds_select )
}

function scaffold_edit_all() {
  v $( scaffolds_list )
}
