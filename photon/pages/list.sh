#!/usr/bin/bash

fmt_title="${txBold} %s${txReset}\n"

fmt_subtitle=" %s${txReset}\n"

fmt_child="${fgYellow}%3d)${txReset} %s${fgAqua}%s${txReset}\n"
fmt_child2="     %s\n"

function display_page_details() {
  md=$1
  filename=$(basename -- "$md")
  extension="${filename##*.}"
  name="${filename%.*}"
  dir=$(dirname "$md")

  yaml="$(cat $md | sed -n -e '/^---$/,/^---$/{ /^---$/d; /^---$/d; p; }')"

  title=$(echo "$yaml" | yq r - title )
  printf "$fmt_title" "$title"
  # espeak "$title"

  case $name in
    event)
      subtitle=$(echo "$yaml" | yq r - data.event.startDate )
      ;;
    *)
      subtitle=$(echo "$yaml" | yq r - subtitle )
      ;;
  esac
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

  grep -e "^#\{1,6\}" "$md"| sed -e "s/#/  /g"

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
  ui_banner "children:"

  children=$(find . \
    -maxdepth 2 \
    -mindepth 2 \
    -name "*.md" \
    -type f \
    | sort)

  i=1
  dirs=()

  for f in $children
  do
    filename=$(basename -- "$f")
    extension="${filename##*.}"
    name="${filename%.*}"
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
    ui_list_item_number $i "$title" "$gscount"
    ui_list_item "$(basename -- $dir)"
    ((i++))
  done
  echo
}

function move_in_siblings() {
  ui_banner "move within siblings"
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

function find_from_dir() {
  echo
  read -p "search files for: " search
  # results=$(grep -rilE --include=*.md -- "$search")
  results=$(ag -Sl "$search")
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
    # printf "$fmt_child2" "$(grep -i "$search" "$r")"
    ag -S "$search" "$r"
    ((i++))
  done

  ui_banner "[r] return | [#] jump"
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
  ui_banner "$PROJECT * PG ${d#*/pages}"

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

  ui_banner "[e] edit | [hjk] move | [#] child | [y] yaml"

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
      sxiv *.jpg
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
      yaml="$(cat $md | sed -n -e '/^---$/,/^---$/{ /^---$/d; /^---$/d; p; }')"
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
    g)
      echo
      read -p "Enter child number: " -e num
      cd "${dirs[(($num-1))]}"
      clear
      pg_list
      ;;
    G)
      clear
      echo
      gss
      read -p "Add and commit this branch [y]:  " -e commit
      if [[ $commit == "y" ]]; then
        gacp
        echo
        read -p "press any key to continue"
      fi
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
