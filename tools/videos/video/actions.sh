#!/usr/bin/env bash

source ~/.photon/tools/videos/video/video_process.sh
source ~/.photon/tools/videos/video/video_migrate.sh

function video_actions() {
  declare -A actions
  actions['?']="help"
  actions[q]="quit"

  actions[l]="losslesscut"
  actions[s]="shotcut"
  actions[p]="mpv"
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
  printf " $SEP ${actions[$action]}\n\n"
  case $action in
    \?)
      for key in "${!actions[@]}"; do
        key_item $key "${actions[$key]}"
      done
      video_actions
      ;;
    q) videos; ;;
    n) image_rename "$file"; videos; ;;
    r) video_process "$file"; ;;
    e) video_edl "$file"; video "$file" $video_index; ;;
    m) video_melt_py "$file"; video "$file" $video_index; ;;
    b) video_build "$file"; ;;
    X) video_extract_video "$file"; ;;
    w) video_wrap "$file"; ;;
    i) video_migrate "$file"; videos; ;;
    x) video_trash "$file"; videos; ;;
    l) losslesscut "$file"; video "$file" $video_index; ;;
    p) mpv "$file" --keep-open=yes; video "$file" $video_index; ;;
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


function video_melt() {
  tr=12
  
  cmd="melt "
  video_file=$1
  edl_file="${video_file%.*}-llc-edl.csv"
  tracks=()
  clip_in=0
  clip_out=0
  clip_offset=0
  clip_track=0
  clip_length=0

  vfr="$( getExifValue "VideoFrameRate")"
  echo vfr: $vfr

  track_ctr=0

  if [[ -f "$edl_file" ]]; then
    echo $edl_file
    mapfile -t segments \
      < <( awk -F, -v vfr=$vfr '{printf "%8s,%8s,%s\n", int(vfr*$1), int(vfr*$2), $3}' "$edl_file" )
    # segments_count=${#segments[@]}
    for segment in "${segments[@]}"; do
      echo $segment
      in=$( echo $segment | awk -F, '{print $1}' )
      in=$(( in * 1 ))
      out=$( echo $segment | awk -F, '{print $2}' )
      out=$(( out * 1 ))
      action=$( echo $segment | awk -F, '{print $3}' )
      action_cmd=$( echo $action | awk -F ": " '{print $1}' )
      # echo $action
      case $action_cmd in
        'clip' )
          text=$( echo $action | awk -F": " '{print $2}' )

          clip_track=$track_ctr
          (( track_ctr++ ))

          clip_offset=$(( clip_offset + clip_length ))
          cmd+=" -track -blank $clip_offset "$video_file" in=$in out=$out "
          clip_in=$in
          clip_out=$out
          clip_length=$(( out - in ))
          ;;
        'img' )
          img=$( echo $action | awk -F": " '{print $2}' )
          img=$( echo -e "$img" | sed 's/^[[:blank:]]*//;s/[[:blank:]]*$//' )
          in=$(( in - clip_in ))
          out=$(( out - clip_in ))
          # track=" -track -blank $in $caption_file bgcolour=0x00000000 out=44"
          cmd+="    -attach watermark:$img in=$in out=$out -transition luma a_track=0 b_track=1 \ \n"
          ;;
        'audio' )
          audio_file=$( echo $action | awk -F": " '{print $2}' )
          in=$(( in - clip_in ))
          out=$(( out - clip_in ))
          cmd+="  -track -blank $(( clip_offset + in )) "$audio_file" -attach avfilter.volume av.volume=.5  "
          cmd+="    -transition mix  in=$(( clip_offset + in ))  a_track=$clip_track b_track=$track_ctr"
          (( track_ctr++ ))
          ;;
        'mp4' )
          mp4=$( echo $action | awk -F": " '{print $2}' )
          mp4=$( echo -e "$mp4" | sed 's/^[[:blank:]]*//;s/[[:blank:]]*$//' )
          in=$(( in - clip_in ))
          out=$(( out - clip_in ))
          # track=" -track -blank $in $caption_file bgcolour=0x00000000 out=44"
          cmd+="    -attach watermark:$mp4 in=$in out=$out -transition luma a_track=0 b_track=1 "
          ;;
        'volume' )
          volume=$( echo $action | awk -F": " '{print $2}' )
          volume=$( echo -e "$volume" | sed 's/^[[:blank:]]*//;s/[[:blank:]]*$//' )
          in=$(( in - clip_in ))
          out=$(( out - clip_in ))
          cmd+="    -attach avfilter.volume av.volume=$volume in=$in out=$out "
          ;;
        'title' )
          text=$( echo $action | awk -F": " '{print $2}' )
          ((img_ctr++))
          img_file="${video_file%.*}.$(printf "%02d" $img_ctr).png"
          overlay_img=$( overlay_title "$text" )
          in=$(( in - clip_in ))
          out=$(( out - clip_in ))
          cmd+="    -attach watermark:$overlay_img in=$in out=$out -transition luma a_track=0 b_track=1 "
          ;;
        'caption' | 'left' )
          text=$( echo $action | awk -F": " '{print $2}' )
          img_file="${video_file%.*}.$(printf "%02d" $track_ctr).png"
          overlay_img=$( overlay_left "$text" "$img_file" )
          in=$(( in - clip_in ))
          out=$(( out - clip_in ))
          cmd+="  -track -blank $(( clip_offset + in )) "$img_file" out=$((out - in))"
          cmd+="    -transition luma  in=$(( clip_offset + in )) out=$(( clip_offset + in + tr )) a_track=$clip_track b_track=$track_ctr"
          cmd+="    -transition luma  in=$(( clip_offset + out - tr )) out=$(( clip_offset + out + 1)) reverse=1 a_track=$clip_track b_track=$track_ctr"
          cmd+="    -transition composite  a_track=$clip_track b_track=$track_ctr"
          (( track_ctr++ ))
          ;;
        'right' )
          text=$( echo $action | awk -F": " '{print $2}' )
          img_file="${video_file%.*}.$(printf "%02d" $track_ctr).png"
          overlay_img=$( overlay_right "$text" "$img_file" )
          in=$(( in - clip_in ))
          out=$(( out - clip_in ))
          cmd+="  -track -blank $(( clip_offset + in )) "$img_file" out=$((out - in))"
          cmd+="    -transition luma  in=$(( clip_offset + in )) out=$(( clip_offset + in + tr )) a_track=$clip_track b_track=$track_ctr"
          cmd+="    -transition luma  in=$(( clip_offset + out - tr )) out=$(( clip_offset + out + 1)) reverse=1 a_track=$clip_track b_track=$track_ctr"
          cmd+="    -transition composite  a_track=$clip_track b_track=$track_ctr"
          (( track_ctr++ ))
          ;;
        'alter' )
          text=$( echo $action | awk -F": " '{print $2}' )
          # file="${video_file%.*}.$(printf "%02d" $track_ctr).png"
          audio_file=$( speak_wav "$text" )
          in=$(( in - clip_in ))
          out=$(( out - clip_in ))
          cmd+="  -track -blank $(( clip_offset + in )) "$audio_file" out=$((out - in))"
          # cmd+="    -transition luma  in=$(( clip_offset + in )) out=$(( clip_offset + in + tr )) a_track=$clip_track b_track=$track_ctr"
          # cmd+="    -transition luma  in=$(( clip_offset + out - tr )) out=$(( clip_offset + out + 1)) reverse=1 a_track=$clip_track b_track=$track_ctr"
          cmd+="    -transition mix  a_track=$clip_track b_track=$track_ctr"
          (( track_ctr++ ))
          ;;
      esac
    done
  fi
  cmd+="  -consumer xml:"$PWD/$video_file.mlt" "

  echo "$cmd"
  echo
  $cmd

  # melt $video_file in=$main_in out=$main_out ${tracks[@]} -consumer xml:"$PWD/$video_file.mlt"
  melt "$video_file.mlt"
}

function video_build() {
  # remove extension
  video_file=${1%.*}
  out_file="$video_file.mlt.${1##*.}"
  melt "$video_file.mlt" -consumer avformat:"$out_file" 
  video "$out_file"
}

function video_extract_video() {
  # remove extension
  video_stem=${1%.*}
  out_file="$video_stem.video.${1##*.}"
  echo extract $1 
  echo to $out_file
  pause_any

  ffmpeg -i "$1" -c copy -an "$out_file" 
  video "$out_file"
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
function video_trash() {
  img=$1

  hr
  ui_banner "TRASH $SEP $img"
  echo

  if [[ "$( ask_truefalse "continue" )" == "true" ]]; then
    gio trash "$img"
  fi
}
