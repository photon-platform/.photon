#!/usr/bin/env bash

declare -A PID=()
declare -A SIZES=()


function camera_show() {
  CAMERA=${1:-$MAIN}
  camera_off "$CAMERA"
  SIZE=1024x768
  HFLIP="hflip, "
  ffplay -noborder -hide_banner -loglevel quiet \
    -video_size $SIZE \
    -framerate $FRAMERATE \
    -i $CAMERA \
    -vf "$HFLIP crop=940:500, hue=s=0, eq=contrast=2:brightness=-.5" \
    -left 1040 -top 900 &
  PID[$CAMERA]=$!
}

function camera_full() {
  CAMERA=${1:-$MAIN}
  camera_off "$CAMERA"
  SIZE=1920x1080
  ffplay -fs -noborder -hide_banner -loglevel quiet \
    -video_size $SIZE \
    -framerate $FRAMERATE \
    -i $CAMERA \
    -vf "$VF" \
    &
  PID[$CAMERA]=$!
}

function camera_off() {
  CAMERA=$1
  if [[ ${PID[$CAMERA]} ]]; then
    kill ${PID[$CAMERA]}
    PID[$CAMERA]=""
  fi 
}

function v0() {
  v0off
  SIZE=1280x1024
  ffplay -noborder -hide_banner -loglevel quiet \
    -video_size $SIZE \
    -framerate $FRAMERATE \
    -i /dev/video0 \
    -vf "crop=940:500, hue=s=0, eq=contrast=2:brightness=-.5" \
    -left 1040 -top 900 &
  export PID_v0=$!
}

function v0a() {
  v0off
  SIZE=1280x1024
  ffplay -noborder -hide_banner -loglevel quiet \
    -video_size $SIZE \
    -framerate $FRAMERATE \
    -i /dev/video0 \
    -vf "hue=s=0, eq=contrast=2:brightness=-.5" \
    -left 1040 -top 900 &
  export PID_v0=$!
}

function v0off() {
  if [[ $PID_v0 ]]; then
    kill $PID_v0
    unset -v PID_v0
  fi 
}

function v0b() {
  SIZE=1280x1024
  ffplay -noborder -hide_banner -loglevel quiet \
    -video_size $SIZE \
    -framerate $FRAMERATE \
    -i /dev/video0 \
    -vf "crop=940:500, hue=s=0, eq=contrast=2:brightness=-.5" \
    -left 1040 -top 900 
}

# sky camera
function v2() {
  v2off
  SIZE=1024x768
  ffplay -noborder -hide_banner -loglevel quiet \
    -video_size $SIZE \
    -framerate $FRAMERATE \
    -i /dev/video2 \
    -vf "crop=940:500, hue=s=0, eq=contrast=2:brightness=-.5" \
    -left 1040 -top 900 &
  export PID_v2=$!
}
function v2full() {
  v2off
  SIZE=1920x1080
  ffplay -noborder -hide_banner -loglevel quiet \
    -video_size $SIZE \
    -framerate $FRAMERATE \
    -i /dev/video2 \
    -vf "hue=s=0, eq=contrast=2:brightness=-.5" \
    &
  export PID_v2=$!
}
function v2off() {
  if [[ $PID_v2 ]]; then
    kill $PID_v2
    unset -v PID_v2
  fi 
}




function alter_cam() {
  v4off
  # window proportion 16x5
  ffmpeg -hide_banner -loglevel quiet \
    -i $MAIN -c:v rawvideo -pix_fmt rgb24 \
    -vf "hue=s=0, eq=contrast=2:brightness=-.5" \
    -window_size 112x35 \
    -window_title 'ALTER' \
    -f caca - -top 820 
}

function sky_cam() {
  ffplay -noborder -hide_banner  \
    -i /dev/video4 \
    -video_size 800x448 \
    -left 1040 -top 900 &
}

function timelapse() {
  output="$( make_filename ).mp4"
  ffmpeg -framerate 1 -f v4l2  \
    -i $CAMERA \
    -vf settb=\(1/30\),setpts=N/TB/30 \
    -r 30 -vcodec libx264 -crf 0 -preset ultrafast -threads 0 \
    $output
}
