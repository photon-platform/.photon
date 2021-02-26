#!/usr/bin/env bash

function page_siblings() {
  siblings=( $(page_siblings_dirs) )
  siblings_count=${#siblings[@]}

  i=0
  for sib_md in ${siblings[@]}
  do
    if [[ $(dirname "$sib_md") == $(pwd) ]]
    then
      siblings_index=$i
    fi
    ((i++))
  done
}

function page_siblings_dirs() {
  parent_dir=$(dirname "$(pwd)")
  find $parent_dir -maxdepth 2 -mindepth 2 -name "*.md" -type f | sort
}

function page_sibling_get() {
  id=$1
  dir=$(dirname ${siblings[$id]})
  if [[ -d "$dir" ]]
  then
    cd "$dir"
  fi
  clear
  page
}

function page_siblings_move() {
  ui_header "Move page within siblings"

  h1 "$(dirname $(pwd))"
  echo

  i=0
  index=0

  siblings=( $(page_siblings_dirs) )
  siblings_count=${#siblings[@]}

  for sib_md in ${siblings[@]}
  do
    current=""

    if [[ $(dirname "$sib_md") == $(pwd) ]]
    then
      index=$i
      # echo $sib_md
      current=$fgRed
    fi
    ((i++))

    if test -f $sib_md;
    then
      yaml=$(cat $sib_md | sed -n '/---/,/---/p')
      # title=$(echo "$yaml" | yq e "title" - )
      # printf "$fmt_child" $i "$current$title"
      # printf "$fmt_child2" "$sib_md"
      printf "$fmt_child2" "$(basename $(dirname ${sib_md}))"
    else
      printf "$fmt_child" $i "no page"
    fi
  done
  echo
  echo "" $((index + 1)) of ${#siblings[@]}

  ui_footer "[j] move down | [k] move up | [q] quit"
  read -n1  action
  case $action in
    j)
      clear
      echo "move down"
      echo "swap: "

      fromDir=$(basename $(dirname ${siblings[index]}))
      echo $fromDir
      num1="${fromDir%.*}"
      name1="${fromDir#*.}"

      toDir=$(basename $(dirname ${siblings[$((index + 1))]}))
      echo $toDir
      num2="${toDir%.*}"
      name2="${toDir#*.}"

      mv "../$fromDir" "../$num2.$name1"
      mv "../$toDir" "../$num1.$name2"
      cd "../$num2.$name1"
      pwd
      # clear
      page_siblings_move
      ;;
    k)
      clear
      echo "move up"
      echo "swap: "

      fromDir=$(basename $(dirname ${siblings[index]}))
      echo $fromDir
      num1="${fromDir%.*}"
      name1="${fromDir#*.}"

      toDir=$(basename $(dirname ${siblings[$((index - 1))]}))
      echo $toDir
      num2="${toDir%.*}"
      name2="${toDir#*.}"

      mv "../$fromDir" "../$num2.$name1"
      mv "../$toDir" "../$num1.$name2"
      cd "../$num2.$name1"
      pwd
      # clear
      page_siblings_move
      ;;
    [1-9]*)
      clear
      page
      ;;
    *)
      clear
      page
      ;;
  esac
}
