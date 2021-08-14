#!/usr/bin/env bash

OVERLAY_PHP=~/.photon/tools/overlays
OVERLAY_OUTPUT=~/tmp/overlay.html

function overlay_left() {
  title="$1"

  if [[ ! "$title" ]]; then
    read -p "overlay title: " title 
  fi

  createdt=$( date )
  ts=$( date +"%g.%j.%H%M%S" --date="$createdt" )
  slug=$( slugify "$title" )
  output="left.$slug.png"

  php -f "$OVERLAY_PHP/left.php" title="$title" > "$OVERLAY_OUTPUT"
  timesnap "$OVERLAY_OUTPUT" \
    --viewport "1920,1080" \
    --transparent-background \
    --frames=1 \
    --output-pattern="$output" \
    &> /dev/null

  exiftool \
    -Title="$title" \
    -Description="$ts" \
    -Subject="left title" \
    -Creator="phi ARCHITECT" \
    -Copyright="$(date +%Y --date="$createdt") • phiarchitect.com" \
    -DateTimeOriginal="$( date "+%Y:%m:%d %H:%M:%S" --date="$createdt")" \
    -overwrite_original \
    "$output" \
    &> /dev/null

  echo $output
}

function overlay_title() {
  title="$1"

  if [[ ! "$title" ]]; then
    read -p "overlay title: " title 
  fi

  createdt=$( date )
  ts=$( date +"%g.%j.%H%M%S" --date="$createdt" )
  slug=$( slugify "$title" )
  output="title.$slug.png"

  php -f "$OVERLAY_PHP/title.php" title="$title" > "$OVERLAY_OUTPUT"
  timesnap "$OVERLAY_OUTPUT" \
    --viewport "1920,1080" \
    --transparent-background \
    --frames=1 \
    --output-pattern="$output" \
    &> /dev/null

  exiftool \
    -Title="$title" \
    -Description="$ts" \
    -Subject="title" \
    -Creator="phi ARCHITECT" \
    -Copyright="$(date +%Y --date="$createdt") • phiarchitect.com" \
    -DateTimeOriginal="$( date "+%Y:%m:%d %H:%M:%S" --date="$createdt")" \
    -overwrite_original \
    "$output" \
    &> /dev/null

  echo $output
}

function overlay_caption() {
  caption="$1"

  if [[ ! "$caption" ]]; then
    read -p "overlay caption: " caption 
  fi

  createdt=$( date )
  ts=$( date +"%g.%j.%H%M%S" --date="$createdt" )
  slug=$( slugify "$caption" )
  output="caption.$slug.png"

  php -f "$OVERLAY_PHP/caption.php" caption="$caption" > "$OVERLAY_OUTPUT"
  timesnap "$OVERLAY_OUTPUT" \
    --viewport "1920,1080" \
    --transparent-background \
    --frames=1 \
    --output-pattern="$output" \
    &> /dev/null

  exiftool \
    -Title="$caption" \
    -Description="$ts" \
    -Subject="caption" \
    -Creator="phi ARCHITECT" \
    -Copyright="$(date +%Y --date="$createdt") • phiarchitect.com" \
    -DateTimeOriginal="$( date "+%Y:%m:%d %H:%M:%S" --date="$createdt")" \
    -overwrite_original \
    "$output" \
    &> /dev/null

  echo $output
}

