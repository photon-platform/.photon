#!/usr/bin/env bash

#run `ffmpeg -sources pulse` to list the system audio devices
MIC="alsa_input.usb-046d_HD_Pro_Webcam_C920_B11A2C0F-02.analog-stereo"
BLUE="alsa_input.usb-BLUE_MICROPHONE_Blue_Snowball_201305-00.analog-stereo"
AUDIO_SYSTEM="alsa_output.pci-0000_0a_00.6.analog-stereo.monitor"

FRAMERATE=24

# mapfile -t media < <(find . -type f -name "*.mkv" -or -name "*.opus" -or -name "*.mp3" | sort)

function tools_log_actions() {

  hr
  P=" ${fgYellow}LOG${txReset}"
  read -s -n1 -p "$P > " action
  case $action in
    q) clear; ;; # quit
    y) sk2; tools_log_actions ;;
    t) set_term; tools_log_actions ;;
    s) screen_main;  tools_log_actions; ;;
    *) clear; tools_log ;;
  esac
}

function make_logname() {
  ts=$( date +%g-%j )
  read  -p " log title: " -i "${ts}-" -e title
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
  output="$HOME/Logs/$( make_logname ).mkv"

  countdown

  ffmpeg -y -hide_banner \
    -video_size 1920x1080 \
    -framerate $FRAMERATE \
    -f x11grab -i :1+0,768 \
    -f pulse -i $BLUE \
    tmp.mkv

  ffmpeg -hide_banner \
    -i tmp.mkv -itsoffset $AUDIO_OFFSET \
    -i tmp.mkv \
    -map 0:v -map 1:a  \
    -af "highpass=f=100, volume=volume=5dB, afftdn" \
    $output

  echo $output >> .log
  rm tmp.mkv

  mpv $output
}


# function screen_full() {
  # output="$( make_filename ).mkv"
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

