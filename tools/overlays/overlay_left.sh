#!/usr/bin/env bash
OVERLAY_PHP=~/.photon/tools/overlays
OVERLAY_OUTPUT=~/tmp/overlay.html

title="$1"
output="$2"

if [[ ! "$title" ]]; then
  read -p "overlay title: " title 
fi

if [[ ! "$output" ]]; then
  createdt=$( date )
  ts=$( date +"%g.%j.%H%M%S" --date="$createdt" )
  slug=$( slugify "$title" )
  output="left.$slug.png"
fi

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
  -Subject="left caption" \
  -Creator="phi ARCHITECT" \
  -Copyright="$(date +%Y --date="$createdt") • phiarchitect.com" \
  -DateTimeOriginal="$( date "+%Y:%m:%d %H:%M:%S" --date="$createdt")" \
  -overwrite_original \
  "$output" \
  &> /dev/null

echo $output
