#!/usr/bin/env bash

# create an empty host directory
# set up apache

PROJECT="$1"

source ~/.photon/.hosts
source ~/.photon/.sites
source ~/.photon/.functions

echo
echo "✴ photon SITE Generator - Apache Host ONLY"
if [ -z $PROJECT ]
then
  echo
  read -p "specify site PROJECT name: " PROJECT
fi

if [ -n $PROJECT ]
then

  START_TIME="$(date -u +%s)"

  mkdir ~/SITES/$PROJECT
  
  ~/.photon/sites/new-apache.sh $PROJECT

  END_TIME="$(date -u +%s)"
  ELAPSED="$(($END_TIME-$START_TIME))"
  TIME=$(convertsecstomin $ELAPSED)
  echo
  echo "✴ elapsed: $TIME m:s"

else
  echo "no project name"
fi
