#!/usr/bin/env bash



# keyboard
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
function v0off() {
  if [[ $PID_v0 ]]; then
    kill $PID_v0
    unset -v PID_v0
  fi 
}

# main camera
function v2() {
  v2off
  SIZE=1024x768
  ffplay -noborder -hide_banner -loglevel quiet \
    -video_size $SIZE \
    -framerate $FRAMERATE \
    -i /dev/video2 \
    -vf "hflip, crop=940:500, hue=s=0, eq=contrast=2:brightness=-.5" \
    -left 1040 -top 900 &
  export PID_v2=$!
}
function v2off() {
  if [[ $PID_v2 ]]; then
    kill $PID_v2
    unset -v PID_v2
  fi 
}

# sky cam
function v4() {
  v4off
  SIZE=1024x768
  ffplay -noborder -hide_banner -loglevel quiet \
    -video_size $SIZE \
    -framerate $FRAMERATE \
    -i /dev/video4 \
    -vf "crop=940:500, hue=s=0, eq=contrast=2:brightness=-.5" \
    -left 1040 -top 900 &
  export PID_v4=$!
}
function v4off() {
  if [[ $PID_v4 ]]; then
    kill $PID_v4
    unset -v PID_v4
  fi 
}

function alter() {
  alteroff
  SIZE=1024x768
  ffplay -noborder -hide_banner -loglevel quiet \
    -video_size $SIZE \
    -framerate $FRAMERATE \
    -i /dev/video2 \
    -c:v rawvideo -pix_fmt rgb24 \ 
    -vf "crop=940:500, hue=s=0, eq=contrast=2:brightness=-.5" \
    -window_size 80x25 -f caca \ 
    -left 1040 -top 900 &
  export PID_alter=$!
}
function alteroff() {
  if [[ $PID_alter ]]; then
    kill $PID_alter
    unset -v PID_alter
  fi 
}
function other_cam() {
  ffmpeg -i $CAMERA -c:v rawvideo -pix_fmt rgb24 -vf "hflip, hue=s=0, eq=contrast=2:brightness=-.5" -window_size 80x25 -f caca - -top 900
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