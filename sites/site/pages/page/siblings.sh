#!/usr/bin/env bash

siblings=
siblings_index=
siblings_count=

function page_siblings() {

  parent_dir=$(dirname "$(pwd)") 

  siblings=()
  while IFS=  read -r -d $'\0'; do
      siblings+=("$REPLY")
  done < <(find $parent_dir -maxdepth 2 -mindepth 2 -name "*.md" -type f -print0 | sort )
  IFS=$'\n' siblings=($(sort <<<"${siblings[*]}"))
  unset IFS

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

function page_siblings_move() {
  ui_banner "move page within siblings"

  i=0
  index=0
  for sib in ${siblings[@]}
  do
    current=""

    if [[ $sib == $(pwd) ]]
    then
      index=$i
      # echo $sib
      current=$fgRed
    fi
    ((i++))

    mds=(${sib}/*.md)
    md=${mds[0]}
    if test -f $md;
    then
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
      echo "swap: "

      fromDir=$(basename -- ${siblings[index]})
      echo $fromDir
      num1="${fromDir%.*}"
      name1="${fromDir#*.}"

      toDir=$(basename -- ${siblings[$((index + 1))]})
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

      fromDir=$(basename -- ${siblings[index]})
      echo $fromDir
      num1="${fromDir%.*}"
      name1="${fromDir#*.}"

      toDir=$(basename -- ${siblings[$((index - 1))]})
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
