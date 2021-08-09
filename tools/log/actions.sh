#!/usr/bin/env bash


function tools_log_actions() {
  declare -A actions
  actions['?']="help"
  actions[q]="quit"
  actions[r]="rc"
  actions[s]="screen_main"
  actions[y]="screenkeys on"
  actions[t]="set_term"
  actions[c]="log_concat"

  echo
  hr
  P=" ${fgYellow}LOG${txReset}"
  read -n1 -p "$P > " action
  printf " $SEP ${actions[$action]}\n\n"
  case $action in
    \?)
      for key in "${!actions[@]}"; do 
        key_item $key "${actions[$key]}"
      done
      tools_log_actions
      ;;
    q) clear -x; ;; # quit
    r) rc;  tools_log_actions; ;;
    s) screen_main;  tools_log_actions; ;;
    y) sk; tools_log_actions ;;
    t) set_term; tools_log_actions ;;
    c) log_concat; ;; 
    *) clear -x; tools_log ;;
  esac
}

function log_concat() {
  ffmpeg -f concat -safe 0 -i .log  -c copy ~/Logs/$(basename $PWD).mp4
}

function log_date() {
  date +%g-%j 
}

function make_logname() {
  read  -p " log title: " -i "$( log_date )-" -e title
  title=$( slugify "$title" )
  # [[ $title ]] && title="-$title"
  echo "${title}"
}

function countdown() {
  printf "\nCountdown: "
  
  for (( i = 5; i > 0; i-- )); do
    printf "$i "
    sleep 1
  done
  echo
}

function screen_main() {
  clear -x
  ui_banner "log main screen"
  echo

  read  -p " log title: " -i "$( log_date )-" -e title
  title=$( slugify "$title" )
  echo "${title}"
  
  output="$title.mp4"

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

  echo file $output >> .log
  rm tmp.mp4

  exiftool -DateTimeOriginal="$( date -r "$output" "+%Y:%m:%d %H:%M:%S" )" "$output"

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

