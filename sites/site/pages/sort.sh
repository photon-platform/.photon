#!/usr/bin/bash



function sort_in_siblings() {
  ui_header "move within siblings"

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
      # title=$(echo "$yaml" | yq e title - )
      # printf "$fmt_child" $i "$current$title"
      printf "$fmt_child2" "$sib"
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
      # move down

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
      pages
      ;;
    k)
      # "move up"
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
      pages
      ;;
    [1-9]*)
      clear
      pages
      ;;
    *)
      clear
      pages
      ;;
  esac
}
