#!/usr/bin/env bash

source ~/.photon/photon/pages/list.sh
source ~/.photon/photon/pages/new.sh
source ~/.photon/photon/pages/sort.sh

function pg() {
  # espeak pages &
  # mpv /usr/share/lmms/samples/misc/dong02.ogg

  clear
  if [ $1 ]
  then
    case $1 in
      new)
        pg_new $2
        ;;
      ls)
        clear
        pg_list
        ;;
      *)
        echo "pg [new|ls]"

        ;;
    esac
  else
    cd ${PROJECT_DIR}/user/pages
    clear
    pg_list
  fi
}

function fix_delimiter() {
  files=$(grep -lr --include="*.md" "___" | sort)

  for f in ${files}
  do
    echo $f
    sed -i 's/^___$/===/' $f
  done
}
