#!/usr/bin/env bash

#run `ffmpeg -sources pulse` to list the system audio devices
MIC="alsa_input.usb-046d_HD_Pro_Webcam_C920_B11A2C0F-02.analog-stereo"
BLUE="alsa_input.usb-BLUE_MICROPHONE_Blue_Snowball_201305-00.analog-stereo"
AUDIO_SYSTEM="alsa_output.pci-0000_0a_00.6.analog-stereo.monitor"
CAMERA="/dev/video4"
ZIGGI="/dev/video0"

FRAMERATE=24

# mapfile -t media < <(find . -type f -name "*.mkv" -or -name "*.opus" -or -name "*.mp3" | sort)

function tools_ffmpeg_actions() {

  hr
  P=" ${fgYellow}FFMPEG${txReset}"
  read -s -n1 -p "$P > " action
  case $action in
    q) clear; ;; # quit
    a) rablue;  tools_ffmpeg_actions; ;;
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
    -f 'Fira Mono' -s small \
    -g 1920x33+0+768 &
}
alias skoff="pkill -f screenkey"


function ffconcat() {
  output="$( make_filename ).mkv"
  ffmpeg -hide_banner \
    -f concat -safe 0 \
    -i <(for f in *.mkv; do echo "file '$PWD/$f'"; done) \
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
function virtual_cam() {
  ffmpeg -f x11grab -r 15 -s 1920x1080 -i :1+0,768 -vcodec rawvideo -pix_fmt yuv420p -vf "hflip" -threads 0 -f v4l2 /dev/video6

  
}
