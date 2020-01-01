#!/usr/bin/env bash

source ~/.photon/photon/pages/pg_list.sh
source ~/.photon/photon/pages/pg_new.sh

function pg() {
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
        echo "pg [new]"

        ;;
    esac
  else
    cd ${PROJECT_DIR}/user/pages
    clear
    pg_list
  fi
}
