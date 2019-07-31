#!/usr/bin/env bash

function pg() {
  if [ $1 ]
  then
    case $1 in
      new)
        # if no second paramter for template - defualt to article
        TEMPLATE=${2-"article"}

        echo "photon ✴ NEW $TEMPLATE"

        # get page title
        read -p "   TITLE: " TITLE

        # get page folder
        FOLDER=$(echo "$TITLE" | tr "[:upper:]" "[:lower:]" | tr "[:space:]" "-" | sed -e 's/-$//g' | sed -e 's/[,\/\?\.]//g')

        read -p "  FOLDER: " -i "$FOLDER" -e FOLDER

        # determine folder number
        NUM="00"
        read -p "     NUM: " -i "$NUM" -e NUM
        if [ $NUM ]
        then
          FOLDER="${NUM}.${FOLDER}"
        fi

        read -p "SUBTITLE: " SUBTITLE

        read -p " SUMMARY: " SUMMARY

        mkdir $FOLDER
        cd $FOLDER

        sed -e "s/:TITLE:/$TITLE/g" \
            -e "s/:SUBTITLE:/$SUBTITLE/g" \
            -e "s/:SUMMARY:/$SUMMARY/g" \
            ~/.photon/templates/$TEMPLATE.md > $TEMPLATE.md

        atom $TEMPLATE.md
        ;;
      *)
        echo "pg [new]"

        ;;
    esac
  else
    cd ${PROJECT_DIR}/user/pages
    ls
    git status -sb .
  fi
}
