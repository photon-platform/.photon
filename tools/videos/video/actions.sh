#!/usr/bin/env bash

source ~/.photon/tools/videos/video/video_process.sh
source ~/.photon/tools/videos/video/video_migrate.sh

function video_actions() {
  declare -A actions
  actions['?']="help"
  actions[q]="quit"

  actions[l]="losslesscut"
  actions[s]="shotcut"
  actions[o]="mpv"
  actions[r]="video_process"
  actions[e]="video_edl"
  actions[m]="video_melt"
  actions[b]="video_build"
  actions[i]="video_migrate"
  actions[x]="video_trash"
  actions[X]="video_extract_video"

  actions[h]="back to videos"
  actions[j]="move to next sibling video"
  actions[k]="move to prev sibling video"
  actions['#']="select child by number (multi-digit, type enter)"

  actions[E]="Exif"

  echo
  hr
  P=" ${fgYellow}VIDEO${txReset}"
  read -n1 -p "$P > " action
  if [[ $action ]]; then
    action_desc=${actions[$action]}
  else
    action_desc=${actions[o]}
  fi
  printf " $SEP $action_desc\n\n"
  case $action in
    \?)
      for key in "${!actions[@]}"; do
        key_item $key "${actions[$key]}"
      done
      video_actions
      ;;
    q) videos; ;;
    r) image_rename "$file"; videos; ;;
    F) video_process "$file"; ;;
    e) video_edl "$file"; video "$file" $video_index; ;;
    m) video_melt_py "$file"; video "$file" $video_index; ;;
    b) video_build "$file"; ;;
    X) video_extract_video "$file"; ;;
    w) video_wrap "$file"; ;;
    i) video_migrate "$file"; videos; ;;
    x) trash "$file"; videos; ;;
    l) losslesscut "$file" 2> /dev/null; video "$file" $video_index; ;;
    ""|o) 
      #hit enter for open
      mpv "$file" --keep-open=yes; video "$file" $video_index; ;;
    s) shotcut "$file"; video "$file" $video_index; ;;
    h) videos ;;
    j)
      id=$((video_index + 1))
      if [[ ${list[$id]} ]]; then
        video "${list[$id]}" $id
      else
        video "$file" $video_index
      fi
      ;;
    k)
      id=$((video_index - 1))
      if [[ ${list[$id]} ]]; then
        video "${list[$id]}" $id
      else
        video "$file" $video_index
      fi
      ;;
    i) exiftool "$file" | less ; video "$file" $video_index; ;;
    E) tools_exif_actions;
      video "$file" $video_index
      ;;
    0)
      exiftool -Rating= "$file" -overwrite_original
      video "$file" $video_index
      ;;
    [1-9])
      exiftool -Rating=$action "$file" -overwrite_original
      video "$file" $video_index
      ;;
    *)
      video "$file" $video_index;
      ;;
  esac
}


function video_edl() {
  file=$1
  edl_file="${file%.*}-proj.llc"
  if [[ -f "$edl_file" ]]; then
      vim "$edl_file"
  fi
}


function video_melt_py() {
  python3 ~/.photon/tools/videos/video/llc.py "$1"
}


function video_build() {
  # remove extension
  video_file=${1%.*}
  out_file="$video_file.mlt.${1##*.}"
  melt "$video_file.mlt" -consumer avformat:"$out_file" 
  exiftool -tagsFromFile "$1" "$out_file" -overwrite_original
  video "$out_file"
}

function video_extract_video() {
  # remove extension
  video_stem=${1%.*}
  out_file="$video_stem.video.${1##*.}"
  echo extract $1 
  echo to $out_file
  if [[ "$( ask_truefalse "continue" )" == "true" ]]; then
    ffmpeg -i "$1" -c copy -an "$out_file" 
    exiftool -tagsFromFile "$1" "$out_file" -overwrite_original
    video "$out_file"
  else
    video "$1"
  fi

}

function video_wrap() {
  video_file=$1
  # -attach watermark:21.221.134012.creating-a-digital-archive.png in=100 out=144 -transition luma a_track=0 b_track=1 \
  melt ~/Media/photon-logo.mp4 \
  "$video_file.mlt" \
  -mix 48 -mixer luma -mixer mix:-1 \
  ~/Media/photon-logo.reversed.mp4 \
  -mix 48 -mixer luma -mixer mix:-1 \
  -consumer avformat:build.mp4
  video build.mp4

}
