#!/usr/bin/env bash

sty_banner="${bgYellow}${fgBlack}"
fmt_banner="${sty_banner} %-*s${txReset}\n"

sty_title="${txBold}"
fmt_title="${sty_title} %s${txReset}\n"

sty_subtitle=""
fmt_subtitle="${sty_subtitle} %s${txReset}\n"

sty_child="${fgYellow}"
fmt_child="${sty_child}%3d)${txReset} %s${fgAqua}%s${txReset}\n"
fmt_child2="     %s$\n"

function pg_list() {
  width=$(tput cols)
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
    espeak "$title"

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
      clear
      pg_list
      ;;
    v)
      eog *.jpg
      clear
      pg_list
      ;;
    f)
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
        dirname=$(dirname "$r")
        dirs+=( $dirname )
        echo
        printf "$fmt_child" $i "$r"
        printf "$fmt_child2" "$(grep -i "$search" "$r")"
        ((i++))
      done

      printf "$fmt_banner" $((width - 1)) "[r] return | [#] jump"
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
      ;;
    d)
      clear
      echo
      ls -hA
      echo
      printf "$fmt_banner" $((width - 1)) "[e] edit | [hjk] move | [#] child | [y] yaml"
      pg_list
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
