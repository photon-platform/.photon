#!/usr/bin/env bash


function tools_record_actions() {
  declare -A actions
  actions['?']="help"
  actions[q]="quit"
  actions[c]="record_camera"
  actions[s]="record_camera"
  actions[y]="screenkeys on"
  actions[t]="set_term"

  echo
  hr
  P=" ${fgYellow}record${txReset}"
  read -n1 -p "$P > " action
  printf " $SEP ${actions[$action]}\n\n"
  case $action in
    \?)
      for key in "${!actions[@]}"; do 
        key_item $key "${actions[$key]}"
      done
      tools_record_actions
      ;;
    q) clear -x; ;; # quit
    r) rc;  tools_record_actions; ;;
    s) record_screen;  tools_record_actions; ;;
    y) sk; tools_record_actions ;;
    t) set_term; tools_record_actions ;;
    *) clear -x; tools_record ;;
  esac
}

function countdown() {
  printf "\nCountdown: "
  
  for (( i = 5; i > 0; i-- )); do
    printf "$i "
    sleep 1
  done
  echo
}

alias Rs=record_screen
function record_screen() {
  clear -x
  ui_banner "RECORD • main screen"
  echo

  read -p " title: " title
  createdt=$( date )
  ts=$( date +"%g.%j.%H%M%S" --date="$createdt" )

  slug=$( slugify "$title" )
  
  output="$ts.$slug.raw.mp4"

  countdown

  ffmpeg -y -hide_banner \
    -video_size 1920x1080 \
    -framerate $FRAMERATE \
    -f x11grab -i :1+0,768 \
    -f pulse -i $BLUE \
    tmp.mp4

  ffmpeg -hide_banner \
    -i tmp.mp4 -itsoffset $AUDIO_OFFSET \
    -i tmp.mp4 \
    -map 0:v -map 1:a  \
    -af "highpass=f=100, volume=volume=5dB, afftdn" \
    $output

  echo file $output >> .record
  rm tmp.mp4

  exiftool \
    -Title="$title" \
    -Description="$ts" \
    -Creator="phi ARCHITECT" \
    -Copyright="$(date +%Y --date="$createdt") • phiarchitect.com" \
    -DateTimeOriginal="$( date "+%Y:%m:%d %H:%M:%S" --date="$createdt")" \
    -overwrite_original \
    "$output"

  video "$output"
}

# function screen_full() {
  # output="$( make_filename ).mp4"
  # ffmpeg -hide_banner \
    # -video_size 1920x1848 \
    # -framerate $FRAMERATE \
    # -f x11grab -i :1+0,0 \
    # -f pulse -i $BLUE \
    # "$output"
  # mpv "$output"
# }

alias Rc=record_camera
function record_camera() {
  CAMERA=${1:-$MAIN}
  MIC=${2:-$BLUE}
  TRIM_END=0
  SIZE="1920x1080"

  read -p "title: " title
  createdt=$( date )
  ts=$( date +"%g.%j.%H%M%S" --date="$createdt" )

  slug=$( slugify "$title" )
  
  output="$ts.$slug.raw.mp4"

  echo
  ui_banner "recording: $output"
  countdown

  ffmpeg  -hide_banner \
    -framerate $FRAMERATE \
    -video_size $SIZE \
    -f v4l2 -input_format mjpeg -i $CAMERA \
    -f pulse  -ac 2  -i $MIC \
    "$output" 

  echo
  ui_banner "offset: $AUDIO_OFFSET"
  ffmpeg -y  -hide_banner \
    -i "$output" -itsoffset $AUDIO_OFFSET \
    -i "$output" \
    -map_metadata 0 \
    -map 0:v -map 1:a  \
    -c copy \
    "tmp.mp4" 

  mv "tmp.mp4" "$output"

  exiftool \
    -Title="$title" \
    -Description="$ts" \
    -Creator="phi ARCHITECT" \
    -Copyright="$(date +%Y --date="$createdt") • phiarchitect.com" \
    -DateTimeOriginal="$( date "+%Y:%m:%d %H:%M:%S" --date="$createdt")" \
    -overwrite_original \
    "$output"

  video "$output"
}
