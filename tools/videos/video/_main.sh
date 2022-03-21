#!/usr/bin/env bash

source ~/.photon/tools/videos/video/actions.sh

function video() {
  clear -x

  file=$1
  video_index=$2

  ui_header "video $SEP $file"

  if test -f "$file";
  then
    getExif "$file"

    mimetype="$(file -b -i "$file")"

    w=$(tput cols)
    w=$((w - 1))
    h=$(tput lines)
    # h=$((h / 2))

    ffmpeg -hide_banner -loglevel quiet -y -i "$file"  -vf  "thumbnail,scale=640:360" -frames:v 1 .thumb.jpg
    chafa -c 240 -s "$wx$h" .thumb.jpg
    rm .thumb.jpg

    echo
    h1 "$file"
    img_dt=$(date -d"$( getExifValue "DateTimeOriginal" | tr ":" " " |  awk '{printf "%s/%s/%s %s:%s:%s", $2, $3, $1, $4, $5, $6}' )" )
    echo " $img_dt"

    hr
    size="$( getExifValue "ImageWidth" )${fgg08}x${txReset}$( getExifValue "ImageHeight" )"
    vfr="$( getExifValue "VideoFrameRate")"
    echo " $size $SEP $vfr f/s ${fgg08}[${txReset} $( getExifValue "FileSize" ) ${fgg08}]${txReset}"
    
    duration=$( getExifValue "Duration")
    if [[ "$duration" == *"s" ]]; then
      seconds=${duration% s}
      hms=$( convertsecstohours $seconds )
    else
      hms=$duration
      # IFS=':' read -r -a parts <<< "$duration"
      # h=$(( ${parts[0]} * 3600 ))
      # m=$(( ${parts[1]} * 60 ))
      # s=${parts[2]}
      # seconds=$(( h + m + s ))

    fi
    # frames=$( echo "$seconds * $vfr" | bc )

    # echo " $hms $SEP $seconds s $SEP $frames frames"
    echo " $duration"
    # echo " $hms $SEP $seconds s $SEP $frames frames"

    echo -n " $( getExifValue "Make" ) $SEP $( getExifValue "Model" )"
    echo " $SEP $( getExifValue "Aperture" ) $SEP $( getExifValue "ShutterSpeed" ) $SEP $( getExifValue "FocalLength" )"
    hr

    echo
    exif_keyvalue Title
    exif_keyvalue Description
    exif_keyvalue Notes
    exif_keyvalue Subject
    exif_keyvalue Rating
    exif_keyvalue Colorlabels
    exif_keyvalue Creator
    exif_keyvalue Publisher
    exif_keyvalue Copyright

    video_actions
  else
    h1 "video not found"
  fi
  tab_title
}

function exif_keyvalue() {
    echo " ${fgg12}$1 $SEP $( getExifValue "$1" ) "
}

function check_sound() {
  file=${1:-$file}
  ffmpeg -hide_banner -i $file  -filter_complex volumedetect -c:v copy -f null /dev/null

}
