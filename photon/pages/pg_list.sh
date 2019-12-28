#!/usr/bin/env bash


function pg_list() {
  echo
  echo "******** photon PAGES ***************************************************"


  if test -f *.md;
  then
    frontmatter=$(cat *.md | sed -n '/---/,/---/p' )
    # title=$(sed -n "s/^\(title:\s*\)\(.*\)/\2/p" *.md)
    # title="${title%\"}"
    # title="${title%\'}"
    # title="${title#\"}"
    # title="${title#\'}"
    # echo $title
    # echo $frontmatter
    # echo $frontmatter | yq r - title
    # echo $frontmatter | yq r - subtitle
    title=$(cat *.md | sed -n '/---/,/---/p' | yq r - title )
    echo $title
    subtitle=$(cat *.md | sed -n '/---/,/---/p' | yq r - subtitle )
    echo $subtitle
    d=$(pwd)
    echo ${d#*/pages}
    echo
  fi

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
    filename="${filename%.*}"
    dirname=$(dirname "$f")
    dirs+=( $dirname )

    # sed -n "s/^\(title:\s*\)\(.*\)/\2/p" $f
    gscount=$(git status -sb $dirname | wc -l)
    ((gscount--))
    title=$(cat $f | sed -n '/---/,/---/p' | yq r - title )
    if (( gscount > 0 ));
    then
      gscount="- $gscount"
    else
      gscount=""
    fi
    echo -e "$i\t$title $gscount"
    # echo -e "\t[$filename]\t$dirname"
    # echo
    i=$((i+1))
  done
  echo
  echo "[e] edit current"
  echo "[#] number jump to child folder"
  read -p "?: " action
  case $action in
    q) ;;
    e) 
      vim *.md 
      pq_list
      ;;
    y) 
      cat *.md | sed -n '/---/,/---/p' 
      pg_list
      ;;
    h)
      cd ..
      pg_list
      ;;
    *)
      # echo "${dirs[(($action-1))]}"
      cd "${dirs[(($action-1))]}"
      pg_list
    ;;
  esac
}
