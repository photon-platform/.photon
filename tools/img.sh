#!/usr/bin/env bash

function img_caption() {
  caption=${1}
  if [[ $caption == "" ]]; then
    read -p "caption: " caption
  fi

  createdt=$( date )
  ts=$( date +"%g.%j.%H%M%S" --date="$createdt" )
  slug=$( slugify "$caption" )
  output="caption.$slug.png"

  convert \
    -font "Fira-Sans-Compressed-Book" -pointsize 72 \
    -background transparent -fill "#c90" \
    -size 1920x1080 -gravity South \
    caption:"$caption"  $output
  
  echo $output
  
}
