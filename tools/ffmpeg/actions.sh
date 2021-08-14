#!/usr/bin/env bash

function tools_ffmpeg_actions() {
  echo
  hr
  P=" ${fgYellow}FFMPEG${txReset}"
  read -n1 -p "$P > " action
  printf " $SEP ${actions[$action]}\n\n"
  case $action in
    \?)
      for key in "${!actions[@]}"; do 
        key_item $key "${actions[$key]}"
      done
      tools_ffmpeg_actions
      ;;
    q) clear; ;; # quit
    a) rablue;  tools_ffmpeg_actions; ;;
    c) rc;  tools_ffmpeg_actions; ;;
    s) screen_rec;  tools_ffmpeg_actions; ;;
    # d) dbf_cam ;  tools_ffmpeg_actions;;
    # k) kb_cam ;  tools_ffmpeg_actions;;
    y) sk; tools_ffmpeg_actions ;; 
    # t) set_term; tools_ffmpeg_actions ;; 
    x) dbfoff; kboff; skoff; tools_ffmpeg_actions;;
    *) clear; tools_ffmpeg ;;
  esac
}

function set_term() {
  gnome-terminal --geometry=86x44+0+800 --hide-menubar --zoom=1.2 &
}

function make_filename() {
  ts=$( timestamp )
  read -p "title: " title
  title=$( slugify "$title" )
  [[ $title ]] && title="-$title"
  echo "${ts}${title}"
}


function process_video() {
  input=$1
  # folder=$(dirname "$input")
  # file=$(basename "$input")
  # mkdir -p "$folder/processed"
  if [[ "$input" == *.raw.mp4 ]]; then
    output="${input%.raw.mp4}.mp4"

    if [[ $output ]]; then
      mv $output $output.bak
    fi

    vf="hue=s=0, eq=contrast=2:brightness=-.5" 
    af="highpass=f=100, volume=volume=5dB, afftdn" 
    # dur=$(ffprobe -hide_banner -i "$input"  -show_entries format=duration -v quiet -of csv="p=0")

    echo
    ui_banner "process video: bw"
    ffmpeg -y  -hide_banner \
      -i "$input" \
      -map_metadata 0 \
      -vf "$vf" \
      -af "$af" \
      "$output" 

    echo

    getExif "$input"
    notes="$(getExifValue "Notes")"
    processed="processed $( date +"%g.%j.%H%M%S" ) : vf='$vf' : af='$af' "
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

function audio_set() {
  AUDIO_OFFSET="0.33"
  ffmpeg -y  -hide_banner \
    -i "$1" -itsoffset $AUDIO_OFFSET \
    -i "$1" \
    -map 0:v -map 1:a  \
    -af "highpass=f=100, volume=volume=5dB, afftdn" \
    "out/$1"
}

function ra() {

  output="$( make_filename ).m4a"

  ui_banner "recording: $output"
  ffmpeg -y -hide_banner \
    -f pulse -ac 2 -i $MIC \
    -af "highpass=f=100, volume=volume=5dB, afftdn" \
    "$output" 

  ffplay -i  "$output"
}

function rablue() {

  output="$( make_filename ).mp3"
  mkdir -p out

  ui_banner "audio recording: $output"
  ffmpeg -y -hide_banner \
    -f pulse  -i $BLUE \
    "$output" 

  ffmpeg -y -hide_banner \
    -i $output \
    -af "highpass=f=100, volume=volume=5dB, afftdn" \
    "out/$output" 

  ffplay -i  "out/$output"
}

function sk() {
  pkill -f screenkey 
  screenkey --scr 1 -p fixed \
    --opacity 0.8 \
    -f 'Fira Mono' -s large \
    --font-color gold \
    -g 500x33+1050+768 &
}
alias skoff="pkill -f screenkey"


function ffconcat() {
  output="$( make_filename ).mp4"
  ffmpeg -hide_banner \
    -f concat -safe 0 \
    -i <(for f in *.mp4; do echo "file '$PWD/$f'"; done) \
    -c copy \
    $output
}

function ffsnap() {
  output="$( make_filename )"
  ffmpeg -y -video_size 1920x1080 \
    -f video4linux2 -i /dev/video4  \
    -vf "hflip, hue=s=0, eq=contrast=2:brightness=-.5" \
    -vframes 3 $output-%d.jpg
  sxiv $output-*.jpg
}

# create virtual camera on video6 with desktop - for zoom, etc
function virtual_desktop() {
  sudo modprobe v4l2loopback devices=2
  ffmpeg -f x11grab -r 15 -s 1920x1080 \
    -i :1+0,768 -vcodec rawvideo -pix_fmt yuv420p \
    -threads 0 -f v4l2 /dev/video6
}
function virtual_cam() {
  CAMERA=${1:-$MAIN}
  SIZE="1920x1080"

  sudo modprobe v4l2loopback exclusive_caps=1 video_nr="44" card_label="Main BW" max_buffers=2
  ffmpeg -f v4l2 -i $CAMERA -pix_fmt yuyv422 -vf "hue=s=0, eq=contrast=2:brightness=-.5" \
    -f v4l2 /dev/video44 
}
