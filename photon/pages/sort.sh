#!/usr/bin/bash

function get_child_pages() {
  echo
}

function renumber_children_list() {
  ui_banner "renumber children:"

  # find all markdown files in child folders
  # ignores folders without markdown file
  children=($(find . \
    -maxdepth 2 \
    -mindepth 2 \
    -name "*.md" \
    -type f \
    | sort))

  i=1
  dirs=()

  for f in ${children[@]}; do
    dir=$(dirname "$f")
    dirs+=( $dir )

    dname=$(basename -- "$dir")
    name="${dname#*.}"
    num="${dname%%.*}"

    if [[ "$num" =~ ^[0-9]+$ ]]; then
      printf -v newnum "%02d" $i
      ui_list_item_number $i "$newnum $name"
      ui_list_item  "$dname"
    else
      echo "not a numbered folder"
    fi
    ((i++))
  done
  echo

  ask=$(ask_truefalse "continue")
  echo
  if [[ $ask == "true" ]]; then
    for (( i = $(( ${#children[@]}-1 )); i>= 0; i-- )); do
      f=${children[$i]}
      dir=$(dirname "$f")
      dname=$(basename -- "$dir")
      name="${dname#*.}"
      num="${dname%%.*}"
      if [[ "$num" =~ ^[0-9]+$ ]]; then
        printf -v newnum "%02d" $(( i + 1 ))
        newdname="$newnum.$name"
        ui_list_item_number $i "$newdname"
        ui_list_item  "$dname"
        if [[ "$dname" != "$newdname" ]]; then
          mv -n "$dname" "$newdname"
        fi
      else
        echo "not a numbered folder"
      fi
    done
    ask=$(ask_truefalse "any key continue")
    echo
  fi
}

function sort_in_siblings() {
  ui_banner "move within siblings"

  siblings=($(find $(dirname "$(pwd)") \
    -maxdepth 1 -mindepth 1 -type d | sort))

  i=0
  index=0
  for sib in ${siblings[@]}; do
    current=""

    if [[ $sib == $(pwd) ]]; then
      index=$i
      # echo $sib
      current=$fgRed
    fi
    ((i++))

    mds=(${sib}/*.md)
    md=${mds[0]}
    if test -f $md; then
      yaml=$(cat $md | sed -n '/---/,/---/p')
      title=$(echo "$yaml" | yq r - title )
      printf "$fmt_child" $i "$current$title"
      printf "$fmt_child2" "$sib"
    else
      printf "$fmt_child" $i "no page"
    fi
  done
  echo
  echo "" $((index + 1)) of ${#siblings[@]}

  ui_banner "[j] move down | [k] move up | [q] quit"
  read -n1  action
  case $action in
    j)
      clear
      echo "move down"
      echo "move"

      echo ${siblings[index]}
      fromDir=$(basename -- ${siblings[index]})
      echo $fromDir
      num1="${fromDir%.*}"
      name1="${fromDir#*.}"
      echo $num1 $name1
      echo "to"
      echo ${siblings[$((index + 1))]}
      toDir=$(basename -- ${siblings[$((index + 1))]})
      echo $toDir
      num2="${toDir%.*}"
      name2="${toDir#*.}"
      echo $num2 $name2
      mv "../$fromDir" "../$num2.$name1"
      mv "../$toDir" "../$num1.$name2"
      # clear
      pg_list
      ;;
    k)
      clear
      echo "move up"
      echo ${siblings[index]}
      fromDir=$(basename -- ${siblings[index]})
      echo $fromDir
      num1="${fromDir%.*}"
      name1="${fromDir#*.}"
      echo $num1 $name1
      echo "to"
      echo ${siblings[$((index - 1))]}
      toDir=$(basename -- ${siblings[$((index - 1))]})
      echo $toDir
      num2="${toDir%.*}"
      name2="${toDir#*.}"
      echo $num2 $name2
      mv "../$fromDir" "../$num2.$name1"
      mv "../$toDir" "../$num1.$name2"
      # clear
      pg_list
      ;;
    [1-9]*)
      clear
      pg_list
      ;;
    *)
      clear
      pg_list
      ;;
  esac
}
