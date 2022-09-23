#!/usr/bin/env bash

# vf="hue=s=0, eq=contrast=2:brightness=-.5" 
VIDEO_FILTERS=()
# VIDEO_FILTERS+=("hue=s=0")
VIDEO_FILTERS+=("eq=contrast=2:brightness=-.5")
VF=$(printf '%s,' "${VIDEO_FILTERS[@]}")
VF="${VF%,}"

function video_process() {
  # process raw recordings from webcam
  input=$1
  if [[ "$input" == *.raw.mp4 ]]; then
    output="${input%.raw.mp4}.mp4"

    if [[ $output ]]; then
      mv $output $output.bak
    fi

    # dur=$(ffprobe -hide_banner -i "$input"  -show_entries format=duration -v quiet -of csv="p=0")

    echo
    ui_banner "process video: "
    h1 "vf=$VF"
    h1 "af=$AF"
    ffmpeg -y  -hide_banner \
      -i "$input" \
      -map_metadata 0 \
      -vf "$VF" \
      -af "$AF" \
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

    exiftool -ec \
      -DateTimeOriginal="$(getExifValue "DateTimeOriginal")" \
      -Title="$(getExifValue "Title")" \
      -Description="$(getExifValue "Description")" \
      -Notes="$notes" \
      -Subject="$(getExifValue "Subject")" \
      -Rating="$(getExifValue "Rating")" \
      -Colorlabels="$(getExifValue "Colorlabels")" \
      -Creator=$(getExifValue "Creator") \
      -Publisher="$(getExifValue "Publisher")" \
      -Copyright="$(getExifValue "Copyright")" \
      -overwrite_original \
      "$output"

    video "$output"
  else
    echo "$input is not a raw file"
  fi
}
