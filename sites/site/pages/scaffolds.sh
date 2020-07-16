#!/usr/bin/env bash

function scaffolds_list() {
  find $PROJECT_DIR -type f -wholename "**/scaffolds/*.md"
}
function scaffolds_select () 
{ 
    scaffolds=();
    for scf in $(scaffolds_list);
    do
        # echo $scf;
        # basename $scf;
        scaffolds[$( basename $scf )]=$scf;
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

