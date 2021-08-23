#!/usr/bin/env bash


function tools_record_actions() {
  declare -A actions
  actions['?']="help"
  actions[q]="quit"
  actions[a]="record_audio"
  actions[c]="record_camera"
  actions[s]="record_screen"

  actions[y]="screenkeys on"
  actions[t]="set_term"
  actions[v]="camera preview"

  actions[F]="folder"
  actions[I]="images"
  actions[V]="videos"
  actions[A]="audios"

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
    a) record_audio;  tools_record_actions; ;;
    c) record_camera;  tools_record_actions; ;;
    s) record_screen;  tools_record_actions; ;;
    y) sk; tools_record_actions ;;
    t) set_term; tools_record_actions ;;
    v) camera_full; tools_record_actions ;;
    G) tools_git; record; ;;
    F) folder; ;;
    A) audios; ;;
    V) videos; ;;
    I) images; ;;
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
  
  raw="$ts.$slug.raw.mp4"
  output="$ts.$slug.mp4"
  af="highpass=f=100, volume=volume=5dB, afftdn" 

  countdown

  ffmpeg -y -hide_banner \
    -video_size 1920x1080 \
    -framerate $FRAMERATE \
    -f x11grab -i :1+0,768 \
    -f pulse -i $BLUE \
    "$raw"

  exiftool \
    -Title="$title" \
    -Description="$ts" \
    -Creator="phi ARCHITECT" \
    -Copyright="$(date +%Y --date="$createdt") • phiarchitect.com" \
    -DateTimeOriginal="$( date "+%Y:%m:%d %H:%M:%S" --date="$createdt")" \
    -overwrite_original \
    "$raw"

  ffmpeg -hide_banner \
    -i "$raw" -itsoffset $AUDIO_OFFSET \
    -i "$raw" \
    -map 0:v -map 1:a  \
    -af "$af" \
    $output

  getExif "$raw"
  notes="$(getExifValue "Notes")"
  processed="processed $( date +"%g.%j.%H%M%S" ) : af='$af' "
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

  echo file $output >> .record
  video "$output"
}

alias Ra=record_audio
function record_audio() {
  clear -x
  ui_banner "RECORD • audio"
  echo

  read -p " title: " title
  createdt=$( date )
  ts=$( date +"%g.%j.%H%M%S" --date="$createdt" )

  slug=$( slugify "$title" )
  
  raw="$ts.$slug.raw.m4a"
  output="$ts.$slug.m4a"
  # af="$AF"

  countdown

  ffmpeg -y -hide_banner \
    -f pulse -i $BLUE \
    $raw

  exiftool \
    -Title="$title" \
    -Description="$ts" \
    -Creator="phi ARCHITECT" \
    -Copyright="$(date +%Y --date="$createdt") • phiarchitect.com" \
    -DateTimeOriginal="$( date "+%Y:%m:%d %H:%M:%S" --date="$createdt")" \
    -overwrite_original \
    "$raw"

  # ffmpeg -y -hide_banner \
    # -i $raw \
    # -af "$af" \
    # "$output" 

  # getExif "$raw"
  # notes="$(getExifValue "Notes")"
  # processed="processed $( date +"%g.%j.%H%M%S" ) : af='$af' "
  # if [[ $notes == "" ]]; then
    # notes="$processed"
  # else
    # notes+=" | $processed"
  # fi

  # exiftool -ec \
    # -DateTimeOriginal="$(getExifValue "DateTimeOriginal")" \
    # -Title="$(getExifValue "Title")" \
    # -Description="$(getExifValue "Description")" \
    # -Notes="$notes" \
    # -Subject="$(getExifValue "Subject")" \
    # -Rating="$(getExifValue "Rating")" \
    # -Colorlabels="$(getExifValue "Colorlabels")" \
    # -Creator=$(getExifValue "Creator") \
    # -Publisher="$(getExifValue "Publisher")" \
    # -Copyright="$(getExifValue "Copyright")" \
    # -overwrite_original \
    # "$output"

  echo file $raw >> .record
  audio "$raw"
}

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

  echo file $output >> .record
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

