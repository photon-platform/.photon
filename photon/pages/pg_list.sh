#!/usr/bin/env bash

sty_banner="${bgYellow}${fgBlack}"
fmt_banner="${sty_banner} %-*s${txReset}\n"

sty_title="${txBold}"
fmt_title="${sty_title} %s${txReset}\n"

sty_subtitle=""
fmt_subtitle="${sty_subtitle} %s${txReset}\n"

sty_child="${fgYellow}"
fmt_child="${sty_child}%3d)${txReset} %s${fgCyan}%s${txReset}\n"

function pg_list() {
  width=$(tput cols)
  clear
  d=$(pwd)

  printf "$fmt_banner" $((width - 1)) "$PROJECT * PG ${d#*/pages}"
  echo

  mds=(*.md)
  md=${mds[0]}
  if test -f $md;
  then
    # yaml=$(cat $md | sed -n '/---/,/---/p')
    yaml=$(cat $md | sed -n -e '/^---$/,/^---$/{ /^---$/d; /^---$/d; p; }')

    title=$(echo "$yaml" | yq r - title )
    printf "$fmt_title" "$title"

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
  else
    printf "$fmt_title" "pages root"
  fi

  echo


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

  children=$(find . \
    -maxdepth 2 \
    -mindepth 2 \
    -name "*.md" \
    -type f \
    | sort)

  i=1
  dirs=()

  printf "$fmt_banner" $((width - 1)) "children:"
  echo
  for f in $children
  do
    filename=$(basename -- "$f")
    extension="${filename##*.}"
    filename="${filename%.*}"
    dirname=$(dirname "$f")
    dirs+=( $dirname )

    gscount=$(git status -sb $dirname | wc -l)
    ((gscount--))

    yaml=$(cat $f | sed -n '/---/,/---/p')
    title=$(echo "$yaml" | yq r - title )

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

  printf "$fmt_banner" $((width - 1)) "[e] edit | [hjk] move | [#] child | [y] yaml"
  read -n1  action
  case $action in
    q)
      clear
      ;;
    e)
      vim *.md
      pg_list
      ;;
    f)
      clear
      echo
      la
      printf "$fmt_banner" $((width - 1)) "[e] edit | [hjk] move | [#] child | [y] yaml"
      ;;
    y)
      echo
      echo "$yaml"
      ;;
    h)
      cd ..
      pg_list
      ;;
    j)
      cd ${siblings[$((index + 1))]}
      pg_list
      ;;
    k)
      cd ${siblings[$((index - 1))]}
      pg_list
      ;;
    [1-9]*)
      cd "${dirs[(($action-1))]}"
      pg_list
      ;;
  esac
}
