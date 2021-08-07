#!/usr/bin/env bash

source ~/.photon/tools/ffmpeg/actions.sh
source ~/.photon/tools/ffmpeg/cameras.sh

WEBCAM="alsa_input.usb-046d_HD_Pro_Webcam_C920_B11A2C0F-02.analog-stereo"
BLUE="alsa_input.usb-BLUE_MICROPHONE_Blue_Snowball_201305-00.analog-stereo"
AUDIO_SYSTEM="alsa_output.pci-0000_0a_00.6.analog-stereo.monitor"

MAIN="/dev/video2"
SIDE="/dev/video0"

AUDIO_OFFSET="0.16"


FRAMERATE=24

function tools_ffmpeg() {
  clear -x
  ui_header "FFMPEG $SEP $PWD"

  ffmpeg -hide_banner -sources pulse
  echo
  ffmpeg -hide_banner -sources video4linux2
  
  tools_ffmpeg_actions

  tab_title "$PWD"
}
alias ff=tools_ffmpeg

function tools_ffmpeg_static() {
  # https://www.reddit.com/r/ffmpeg/comments/hic1vg/how_to_simulate_tv_static_using_ffmpeg_on_windows/
  ffmpeg -f lavfi -i nullsrc=s=1920x1080 -filter_complex "geq=random(1)*255:128:128;aevalsrc=-2+random(0)" -t 0.5 static.mp4
}
