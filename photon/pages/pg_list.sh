#!/usr/bin/env bash

sty_banner="${bgYellow}${fgBlack}"
fmt_banner="${sty_banner} %-*s${txReset}\n"

sty_title="${txBold}"
fmt_title="${sty_title} %s${txReset}\n"

sty_subtitle=""
fmt_subtitle="${sty_subtitle} %s${txReset}\n"

sty_child="${fgYellow}"
fmt_child="${sty_child}%3d)${txReset} %s${fgAqua}%s${txReset}\n"
fmt_child2="     %s\n"

function display_page_details() {
  md=$1
  yaml=$(cat $md | sed -n -e '/^---$/,/^---$/{ /^---$/d; /^---$/d; p; }')

  title=$(echo "$yaml" | yq r - title )
  printf "$fmt_title" "$title"
  # espeak "$title"

  subtitle=$(echo "$yaml" | yq r - subtitle )
  if [[ -n $subtitle ]]
  then
    # echo $subtitle
    printf "$fmt_subtitle" "$subtitle"
  fi

  summary=$(tail -n +2 $md | sed -n -e '/^---$/,/^===$/{ /^---$/d; /^===$/d; p; }' | sed 's/^/ /')
  if [[ -n $summary ]]
  then
    echo "$summary" | fold -w $((width-1)) -s
  fi
}

function print_banner() {
  width=$(tput cols)
  printf "$fmt_banner" $((width - 1)) "$1"
  echo
}

function display_sibling_position() {
  siblings=($(find $(dirname "$(pwd)") \
    -maxdepth 1 -mindepth 1 -type d | sort))

  i=0
  index=0
  for sib in ${siblings[@]}
  do
    if [[ $sib == $(pwd) ]]
    then
      index=$i
      # echo $sib
    fi
    ((i++))
  done

  echo "" $((index + 1)) of ${#siblings[@]}
}

function display_children_list() {
  children=$(find . \
    -maxdepth 2 \
    -mindepth 2 \
    -name "*.md" \
    -type f \
    | sort)

  i=1
  dirs=()

  print_banner "children:"

  for f in $children
  do
    filename=$(basename -- "$f")
    extension="${filename##*.}"
    filename="${filename%.*}"
    dir=$(dirname "$f")
    dirs+=( $dir )

    yaml=$(cat $f | sed -n '/---/,/---/p')
    title=$(echo "$yaml" | yq r - title )

    # gscount=$(git status -sb $dir | wc -l)
    ((gscount--))

    if (( gscount > 0 ));
    then
      gscount=" [$gscount]"
    else
      gscount=""
    fi

    # echo -e "$i\t$title $gscount"
    printf "$fmt_child" $i "$title" "$gscount"
    ((i++))
  done
  echo
}

function move_in_siblings() {
  print_banner "move within siblings"
  siblings=($(find $(dirname "$(pwd)") \
    -maxdepth 1 -mindepth 1 -type d | sort))

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

  print_banner "[j] move down | [k] move up | [q] quit"
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

function find_from_dir() {
  clear
  read -p "search files for: " search
  results=$(grep -rilE --include=*.md -- "$search")
  i=1
  dirs=()

  for r in $results
  do
    filename=$(basename -- "$r")
    extension="${filename##*.}"
    filename="${filename%.*}"
    dir=$(dirname "$r")
    dirs+=( $dir )
    echo
    printf "$fmt_child" $i "$r"
    printf "$fmt_child2" "$(grep -i "$search" "$r")"
    ((i++))
  done

  print_banner "[r] return | [#] jump"
  read -n1  search_action
  case $search_action in
    [1-9]*)
      cd "${dirs[(($search_action-1))]}"
      clear
      pg_list
      ;;
    *)
      clear
      pg_list
      ;;
  esac
}

function pg_list() {
  d=$(pwd)
  print_banner "$PROJECT * PG ${d#*/pages}"

  # TODO: check of current directory is home directory
  # set flag to restrict navigation

  mds=(*.md)
  md=${mds[0]}
  if test -f $md;
  then
    display_page_details $md
    display_sibling_position
  else
    printf "$fmt_title" "pages root"
  fi
  echo

  display_children_list

  print_banner "[e] edit | [hjk] move | [#] child | [y] yaml"

  read -n1  action
  case $action in
    q)
      clear
      ;;
    e)
      vim *.md
      clear
      pg_list
      ;;
    v)
      eog *.jpg
      clear
      pg_list
      ;;
    f)
      find_from_dir
      ;;
    d)
      clear
      echo
      ls -hA
      echo
      pg_list
      ;;
    m)
      clear
      move_in_siblings
      ;;
    y)
      clear
      echo
      echo "$yaml"
      echo
      pg_list
      ;;
    h)
      cd ..
      clear
      pg_list
      ;;
    j)
      next=${siblings[$((index + 1))]}
      if [[ -d "$next" ]]
      then
        cd ${next}
      fi
      clear
      pg_list
      ;;
    k)
      prev=${siblings[$((index - 1))]}
      if [[ -d "$prev" ]]
      then
        cd ${prev}
      fi
      clear
      pg_list
      ;;
    [1-9]*)
      cd "${dirs[(($action-1))]}"
      clear
      pg_list
      ;;
    n)
      clear
      pg_new
      clear
      pg_list
      ;;
    *)
      clear
      pg_list
      ;;
  esac
}
