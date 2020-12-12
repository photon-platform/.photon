#!/usr/bin/bash

TEMPLATE_DIR=~/.photon/templates/

function pages_new() {

  clear
  ui_header "photon ✴ PAGE new"
  show_dir
  h1 "Select a template: "

  scaffold=$( scaffolds_select )
  if [[ $scaffold ]]; then
    
    clear
    ui_header "photon ✴ PAGE new"
    show_dir
    ncal -3
    echo
    scaffold_name=`sed -n -e 's/% name: \(.*\)/\1/p' $scaffold`
    h1 "$scaffold_name"
    h2 "$scaffold"
    echo

    scaffold_folder=`sed -n -e 's/% folder: \(.*\)/\1/p' $scaffold`
    echo folder type: $scaffold_folder
    
    scaffold_vars=( $( scaffold_vars $scaffold ) )

    for v in ${scaffold_vars[@]}
    do
      eval "unset $v"
    done

    # defs=( `sed -n -e 's/% def: \(.*\)/"\1"/p' $scaffold` )
    mapfile -t defs < <(sed -n -e 's/% def: \(.*\)/\1/p' $scaffold)
    # sed -n -e 's/% def: \(.*\)/"\1"/p' $scaffold | mapfile defs 
    # for def in ${defs[@]}
    for (( i = 0; i < ${#defs[@]}; i++))
    do
      # echo ${defs[i]}
      eval export "${defs[i]}"
    done

    for v in ${scaffold_vars[@]}
    do
      value="$(ask_value "$v" "${!v}" )"
      eval "export $v='$value'"
      if [[ $v=="start_dt" ]]
      then
        export start_dt_long="$(date '+%A, %B %d, %Y @ %I:%M%p' --date "$start_dt")"
      fi
    done

    # get page folder name from title
    case $scaffold_folder in 
      date)
        folder="$(date +%Y-%m-%d --date "$post_date")-$(slugify "$title")"
        ;;
      event)
        folder="$(date +%Y-%m-%d --date "$start_dt")-$(slugify "$title")"
        ;;
      list)
        folder=$(slugify "$title")
        ;;
      *)
        folder="$(printf "%02d" $(( ${#children[@]} + 1 )) ).$(slugify "$title")"
        ;;
    esac

    folder="$(ask_value "folder:" "${folder}" )"
    mkdir "$folder"

    newfile="$folder/$(basename $scaffold)"
    # envsubst < $scaffold > $newfile
    cat $scaffold | sed  -e '/^[%]/d' | envsubst > $newfile


    for v in ${scaffold_vars[@]}
    do
        eval "unset $v"
    done

    cd "$folder"
  else
    clear
    page
  fi

}
