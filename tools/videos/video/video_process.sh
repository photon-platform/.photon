#!/usr/bin/env bash

# vf="hue=s=0, eq=contrast=2:brightness=-.5" 
VIDEO_FILTERS=()
# VIDEO_FILTERS+=("hue=s=0")
VIDEO_FILTERS+=("eq=contrast=2:brightness=-.5")
VF=$(printf '%s,' "${VIDEO_FILTERS[@]}")
VF="${VF%,}"

function video_filter() {
  # process raw recordings from webcam
  input=$1
  input_stem=${input%.*}
  output="$input_stem.vf.${input##*.}"

  if [[ $output ]]; then
    mv $output $output.bak
  fi

  echo
  ui_banner "filter video: "
  VF=$(printf '%s,' "${VIDEO_FILTERS[@]}")
  VF="${VF%,}"

  ffmpeg -y  -hide_banner \
    -i "$input" \
    -map_metadata 0 \
    -vf "$VF" \
    "$output" 

  echo

  getExif "$input"
  notes="$(getExifValue "Notes")"
  processed="processed $( date +"%g.%j.%H%M%S" ) : vf='$VF' : af='$AF' "
  if [[ $notes == "" ]]; then
    notes="$processed"
  else
    notes+=" | $processed"
  fi

  exiftool -tagsFromFile "$input" "$output" -overwrite_original
  exiftool -ec \
    -Notes="$notes" \
    -overwrite_original \
    "$output"

  video "$output"
}
