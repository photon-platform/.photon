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
    i) camera_show; tools_record_actions ;;
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

  AUDIO_OFFSET="0.33"
  # AUDIO_OFFSET="0.153"
  # AUDIO_OFFSET="0.0"

  createdt=$( date )
  ts=$( date +"%g.%j.%H%M%S" --date="$createdt" )

  read -p " title: " title
  slug=$( slugify "$title" )
  
  raw="$ts.$slug.raw.mp4"
  output="$ts.$slug.mp4"

  countdown

  #use 
  # pacmd list-sources | grep "name: <alsa"
  SYS_AUDIO=alsa_output.pci-0000_0a_00.6.analog-stereo.monitor

  ffmpeg -y -hide_banner \
    -video_size 1920x1080 \
    -framerate $FRAMERATE \
    -f x11grab -i :1+0,768 \
    -f pulse -i $BLUE \
    "$raw"
  
  # ffmpeg -y -hide_banner \
    # -video_size 1920x1080 \
    # -framerate $FRAMERATE \
    # -f x11grab -i :1+0,768 \
    # -f pulse -i $BLUE \
    # -f pulse -i $SYS_AUDIO \
    # -filter_complex "[1:a:0][2:a:0]amix=2[aout]" -map 0:V:0 -map "[aout]" \
    # "$raw"

  ll $raw
  echo
  h1 "Press ENTER to complete metadata"
  pause_enter
  echo

  exiftool \
    -Title="$title" \
    -Description="$ts" \
    -Creator="phi ARCHITECT" \
    -Copyright="$(date +%Y --date="$createdt") • phiarchitect.com" \
    -DateTimeOriginal="$( date "+%Y:%m:%d %H:%M:%S" --date="$createdt")" \
    -overwrite_original \
    "$raw"

  AF=$(printf '%s,' "${AUDIO_FILTERS[@]}")
  AF="${AF%,}"
  ffmpeg -hide_banner \
    -i "$raw" -itsoffset $AUDIO_OFFSET \
    -i "$raw" \
    -map 0:v -map 1:a  \
    -af "$AF" \
    "$output"

  getExif "$raw"
  notes="$(getExifValue "Notes")"
  processed="processed $( date +"%g.%j.%H%M%S" ) : af='$AF' "
  if [[ $notes == "" ]]; then
    notes="$processed"
  else
    notes+=" | $processed"
  fi

  exiftool -tagsFromFile "$raw" "$output" -overwrite_original
  exiftool -ec \
    -Notes="$notes" \
    -overwrite_original \
    "$output"

  video "$output"
}

alias Ra=record_audio
function record_audio() {
  EXT=m4a

  clear -x
  ui_banner "RECORD • audio"
  echo

  createdt=$( date )
  ts=$( date +"%g.%j.%H%M%S" --date="$createdt" )

  read -p " title: " title
  slug=$( slugify "$title" )
  
  raw="$ts.$slug.raw.$EXT"
  output="$ts.$slug.$EXT"

  countdown

  ffmpeg -y -hide_banner \
    -f pulse -i $BLUE \
    "$raw"

  ll $raw
  echo
  h1 "Press ENTER to complete metadata"
  pause_enter
  echo

  exiftool \
    -Title="$title" \
    -Description="$ts" \
    -Creator="phi ARCHITECT" \
    -Copyright="$(date +%Y --date="$createdt") • phiarchitect.com" \
    -DateTimeOriginal="$( date "+%Y:%m:%d %H:%M:%S" --date="$createdt")" \
    -overwrite_original \
    "$raw"

  AF=$(printf '%s,' "${AUDIO_FILTERS[@]}")
  AF="${AF%,}"
  ffmpeg -hide_banner \
    -i "$raw" \
    -af "$AF" \
    $output

  getExif "$raw"
  notes="$(getExifValue "Notes")"
  processed="processed $( date +"%g.%j.%H%M%S" ) : af='$AF' "
  if [[ $notes == "" ]]; then
    notes="$processed"
  else
    notes+=" | $processed"
  fi

  exiftool -tagsFromFile "$raw" "$output" -overwrite_original
  exiftool -ec \
    -Notes="$notes" \
    -overwrite_original \
    "$output"

  audio "$output"
}

alias Rc=record_camera
function record_camera() {
  CAMERA=${1:-$MAIN}
  MIC=${2:-$BLUE}
  TRIM_END=0
  SIZE="1920x1080"

  createdt=$( date )
  ts=$( date +"%g.%j.%H%M%S" --date="$createdt" )

  read -p " title: " title
  slug=$( slugify "$title" )
  
  raw="$ts.$slug.raw.mp4"
  output="$ts.$slug.mp4"

  echo
  ui_banner "recording: $output"
  countdown

  ffmpeg  -hide_banner \
    -framerate $FRAMERATE \
    -video_size $SIZE \
    -f v4l2 -input_format mjpeg -i $CAMERA \
    -f pulse  -ac 2  -i $MIC \
    "$raw" 

  ll $raw
  echo
  h1 "Press ENTER to complete metadata"
  pause_enter
  echo

  exiftool \
    -Title="$title" \
    -Description="$ts" \
    -Creator="phi ARCHITECT" \
    -Copyright="$(date +%Y --date="$createdt") • phiarchitect.com" \
    -DateTimeOriginal="$( date "+%Y:%m:%d %H:%M:%S" --date="$createdt")" \
    -overwrite_original \
    "$raw"

  echo
  ui_banner "offset: $AUDIO_OFFSET"
  AF=$(printf '%s,' "${AUDIO_FILTERS[@]}")
  AF="${AF%,}"
  ffmpeg -hide_banner \
    -i "$raw" -itsoffset $AUDIO_OFFSET \
    -i "$raw" \
    -map 0:v -map 1:a  \
    -af "$AF" \
    $output

  getExif "$raw"
  notes="$(getExifValue "Notes")"
  processed="processed $( date +"%g.%j.%H%M%S" ) : af='$af' "
  if [[ $notes == "" ]]; then
    notes="$processed"
  else
    notes+=" | $processed"
  fi

  exiftool -tagsFromFile "$raw" "$output" -overwrite_original
  exiftool -ec \
    -Notes="$notes" \
    -overwrite_original \
    "$output"

  video "$output"
}

