#!/usr/bin/env bash

#run `ffmpeg -sources pulse` to list the system audio devices
MIC="alsa_input.usb-046d_HD_Pro_Webcam_C920_B11A2C0F-02.analog-stereo"
BLUE="alsa_input.usb-BLUE_MICROPHONE_Blue_Snowball_201305-00.analog-stereo"
AUDIO_SYSTEM="alsa_output.pci-0000_0a_00.6.analog-stereo.monitor"
CAMERA="/dev/video2"
ZIGGI="/dev/video0"

# mapfile -t media < <(find . -type f -name "*.mkv" -or -name "*.opus" -or -name "*.mp3" | sort)

function tools_ffmpeg_actions() {

  # TODO: show all menu options on '?'
  ui_footer "ffmpeg actions: q c d k y t s x"

  read -s -n1  action
  case $action in
    q) clear; ;; # quit
    c) rc2;  tools_ffmpeg_actions; ;;
    d) dbf_cam ;  tools_ffmpeg_actions;;
    k) kb_cam ;  tools_ffmpeg_actions;;
    y) sk2; tools_ffmpeg_actions ;; 
    t) set_term; tools_ffmpeg_actions ;; 
    x) dbfoff; kboff; skoff; tools_ffmpeg_actions;;
    s) screen_rec;  tools_ffmpeg_actions; ;;
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

# system represents two monitors as a combined space
function tools_ffmpeg_screen() {

  h1 "audio: 0-none 1-mic 2-internal 3-both"
  read -s -n1  action
  case $action in
    q) clear; ;; # quit
    0) ffmpeg -video_size 1920x1080 -framerate 25 \
      -f x11grab -i :1+0,768 "$output"
          ;;
    1) screen_rec
          ;;
    2) ffmpeg -video_size 1920x1080 -framerate 25 \
      -f x11grab -i :1+0,768 \
      -f pulse -ac 2 -i $AUDIO_SYSTEM "$output" 
          ;;
    3) ffmpeg -video_size 1920x1080 -framerate 25 \
      -f x11grab -i :1+0,768 \
      -f pulse -ac 2 -i $AUDIO_SYSTEM \
      -f pulse -ac 2 -i $MIC "$output" 
          ;;
  esac
}

function screen_rec() {
  output="$( make_filename ).mkv"
  ffmpeg -video_size 1920x1080 \
    -framerate 30 \
    -f x11grab -i :1+0,768 \
    -f pulse -i $BLUE \
    "$output" 
  mpv "$output"
}

function record_cam() {
  output="$( make_filename ).mkv"

  ui_banner "recording: $output"
  ffmpeg -y -hide_banner -i $CAMERA \
    -f pulse -ac 2 -i $MIC "$output" 

  ui_banner "fix offset"
  ffmpeg -y  -hide_banner -i "$output" -itsoffset 0.44 -i "$output" -map 0:v -map 1:a -c copy "tmp.mkv"
  # ffmpeg -y -i tmp.mkv -ss 3 -c copy $output

  ui_banner "trim 5 seconds off end"
  dur=$(ffprobe -hide_banner -i "tmp.mkv"  -show_entries format=duration -v quiet -of csv="p=0")
  trim=$( echo $dur - 5 | bc )
  ffmpeg -y -hide_banner -t $trim -i tmp.mkv -c copy $output
  rm tmp.mkv 
  
  mpv "$output"
}

function rc2() {
  AUDIO_OFFSET="0.33"
  TRIM_END=3
  SIZE="1920x1080"

  output="$( make_filename ).mkv"

  echo
  ui_banner "recording: $output"
  ffmpeg  -hide_banner \
    -framerate 30 \
    -video_size $SIZE \
    -f v4l2 -input_format mjpeg -i $CAMERA \
    -f pulse  -ac 2  -i $BLUE \
    "$output" 

  echo
  ui_banner "fix offset"
  ffmpeg -y  -hide_banner \
    -i "$output" -itsoffset $AUDIO_OFFSET \
    -i "$output" \
    -map 0:v -map 1:a  \
    -vf "hue=s=0, eq=contrast=2:brightness=-.5" \
    -af "highpass=f=100, volume=volume=5dB, afftdn" \
    "tmp.mkv"
  mv tmp.mkv "$output"

  # echo
  # ui_banner "trim $trim seconds off end"
  # dur=$(ffprobe -hide_banner -i "tmp.mkv"  -show_entries format=duration -v quiet -of csv="p=0")
  # trim=$( echo $dur - $TRIM_END | bc )
  # ffmpeg -y -hide_banner -t $trim \
    # -i tmp.mkv -c copy \
    # "$output"
  # rm tmp.mkv 

  
  mpv "$output"
}

function ra() {

  output="$( make_filename ).m4a"

  ui_banner "recording: $output"
  ffmpeg -y -hide_banner \
    -f pulse -ac 2 -i $MIC \
    "$output" 

  ffplay -i  "$output"
}

function rablue() {

  output="$( make_filename ).mp3"

  ui_banner "recording: $output"
  ffmpeg -y -hide_banner \
    -f pulse  -i $BLUE \
    "$output" 
    # -af "highpass=f=100, volume=volume=10dB, afftdn"

  ffplay -i  "$output"
}

function sk_top() {
  skoff
  screenkey --scr 1 -p fixed \
    --opacity 0.8 \
    -f 'Fira Mono' -s small \
    -g 1920x40+0+768 &
}
alias skoff="pkill -f screenkey"

function kb_cam() {
  SIZE=1280x1024
  ffplay -noborder -hide_banner  \
    -video_size $SIZE \
    -loglevel quiet \
    -i $ZIGGI \
    -vf "crop=940:500, hue=s=0, eq=contrast=2:brightness=-.5" \
    -left 1040  -top 1388 &
  export PID_KB=$!
}

function kboff() {
  if [[ $PID_KB ]]; then
    kill $PID_KB
    unset -v PID_KB
  fi 
}


function dbf_cam() {
  dbfoff
  ffplay -noborder -hide_banner  \
    -loglevel quiet \
    -video_size 1024x768 \
    -i $CAMERA \
    -vf "hflip, crop=940:500, hue=s=0, eq=contrast=2:brightness=-.5" \
    -left 1040 -top 900 &
  export PID_DBF=$!
}
function dbfoff() {
  if [[ $PID_DBF ]]; then
    kill $PID_DBF
    unset -v PID_DBF
  fi 
}

function other_cam() {
  ffmpeg -top 900 -i $CAMERA -c:v rawvideo -pix_fmt rgb24 -vf "hflip, hue=s=0, eq=contrast=2:brightness=-.5" -window_size 80x25 -f caca - -top 900
}

function sky_cam() {
  ffplay -noborder -hide_banner  \
    -i /dev/video4 \
    -video_size 800x448 \
    -left 1040 -top 900 &
}

function timelapse() {
  output="$( make_filename ).mkv"
  ffmpeg -framerate 1 -f v4l2  \
    -i $CAMERA \
    -vf settb=\(1/30\),setpts=N/TB/30 \
    -r 30 -vcodec libx264 -crf 0 -preset ultrafast -threads 0 \
    $output
}

function ffconcat() {
  output="$( make_filename ).mkv"
  ffmpeg -hide_banner \
    -f concat -safe 0 \
    -i <(for f in *.mkv; do echo "file '$PWD/$f'"; done) \
    -c copy \
    $output
}

function ffsnap() {
  ffmpeg -y -video_size 1920x1080 \
    -f video4linux2 -i $CAMERA  \
    -vframes 1 test.jpg; ffplay test.jpg
  # ffmpeg -y -f video4linux2 -i /dev/video0  -vframes 1 test.jpg

  
}