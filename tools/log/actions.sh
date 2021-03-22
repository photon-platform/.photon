#!/usr/bin/env bash

#run `ffmpeg -sources pulse` to list the system audio devices
MIC="alsa_input.usb-046d_HD_Pro_Webcam_C920_B11A2C0F-02.analog-stereo"
BLUE="alsa_input.usb-BLUE_MICROPHONE_Blue_Snowball_201305-00.analog-stereo"
AUDIO_SYSTEM="alsa_output.pci-0000_0a_00.6.analog-stereo.monitor"

FRAMERATE=24

function tools_log_actions() {
  declare -A actions
  actions['?']="help"
  actions[q]="quit"
  actions[y]="screenkeys on"
  actions[t]="set_term"
  actions[s]="screen_main"
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
    y) sk; tools_log_actions ;;
    t) set_term; tools_log_actions ;;
    s) screen_main;  tools_log_actions; ;;
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

  AUDIO_OFFSET="0.33"
  output="$HOME/Logs/$( make_logname ).mp4"

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

# function set_term() {
  # gnome-terminal --geometry=86x44+0+800 --hide-menubar --zoom=1.2 &
# }


# system represents two monitors as a combined space
# function tools_log_screen() {

  # h1 "audio: 0-none 1-mic 2-internal 3-both"
  # read -s -n1  action
  # case $action in
    # q) clear; ;; # quit
    # 0) ffmpeg -video_size 1920x1080 -framerate 25 \
      # -f x11grab -i :1+0,768 "$output"
          # ;;
    # 1) screen_rec
          # ;;
    # 2) ffmpeg -video_size 1920x1080 -framerate 25 \
      # -f x11grab -i :1+0,768 \
      # -f pulse -ac 2 -i $AUDIO_SYSTEM "$output"
          # ;;
    # 3) ffmpeg -video_size 1920x1080 -framerate 25 \
      # -f x11grab -i :1+0,768 \
      # -f pulse -ac 2 -i $AUDIO_SYSTEM \
      # -f pulse -ac 2 -i $MIC "$output"
          # ;;
  # esac
# }

