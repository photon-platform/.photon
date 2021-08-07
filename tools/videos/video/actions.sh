#!/usr/bin/env bash

function video_actions() {
  declare -A actions
  actions['?']="help"
  actions[q]="quit"

  actions[l]="losslesscut"
  actions[s]="shotcut"
  actions[p]="mpv"
  actions[r]="process_video"
  actions[e]="video_edl"
  actions[b]="video_build"
  actions[m]="video_migrate"
  actions[x]="video_trash"

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
    l) losslesscut "$file"; video_actions; ;;
    s) shotcut "$file"; video_actions; ;;
    r) process_video "$file"; video_actions; ;;
    e) video_edl "$file"; video_actions; ;;
    b) video_build "$file"; video_actions; ;;
    m) video_migrate "$file"; videos; ;;
    x) video_trash "$file"; videos; ;;
    p) mpv "$file" --keep-open=yes; video "$file" $video_index; ;;
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
    b) process_video "$file" ;;
    i) exiftool "$file" | less ; video "$file" $video_index; ;;
    E) tools_exif_actions;
      video "$file" $video_index
      ;;
    *)
      video "$file" $video_index;
      ;;
  esac
}

function video_migrate() {
  img=$1

  hr
  ui_banner "MIGRATE $SEP $img"
  echo

  ext=${img##*.}
  ext=$( slugify "$ext" )

  project=$( ask_value "project" "$project" )
  project=$( slugify "$project" )

  activity=$( ask_value "activity" "$activity" )
  activity=$( slugify "$activity" )

  img_dt=$( exiftool -DateTimeOriginal "$img" -S | \
    sed -n 's/^DateTimeOriginal\: \(.*\)/\1/p' | \
    tr ":" " "  \
    )
  img_folder="$HOME/Media/$project/"
  img_folder+=$( echo $img_dt | awk '{printf "%s/%s/%s/", $1, $2, $3}' )

  img_file=$( echo $img_dt | awk '{printf "%s%s%s", $4, $5, $6}' )
  img_file+="-$activity"

  img_path="$img_folder$img_file"

  c=1
  while [[ -f "$img_path.$ext" ]]; do
    img_path="$img_folder$img_file.$c"
    (( c++ ))
  done
  img_path+=".$ext"

  echo
  img_path=$( ask_value "migrate to" "$img_path" ) 
  mkdir -p "$img_folder"
  mv "$img" "$img_path"
}

function video_edl() {
  video_file=$1
  edl_file="${video_file%.*}-llc-edl.csv"
  awk -F, '{printf "%8s %8s %s\n", int(24*$1), int(24*$2), $3}' "$edl_file"
  if [[ -f "$edl_file" ]]; then
    mapfile  segments \
      < <( awk -F, '{printf "%8s %8s %s\n", int(24*$1), int(24*$2), $3}' "$edl_file" )
    # segments_count=${#segments[@]}
    # for segment in "${segments[@]}"; do
      # echo $segment
    # done
    if [[ "$( ask_truefalse "edit?" )" == "true" ]]; then
      vim "$edl_file"
    fi
  fi
}

# melt 21.207.130205.offset-test.mp4   \
  # -attach watermark:caption.one.png in=44 out=66 -transition luma a_track=0 b_track=1 \
  # -attach watermark:caption.two.png in=66 out=88 -transition luma a_track=0 b_track=1 \
  # -consumer xml:melt.mlt

function video_build() {
  video_file=$1
  edl_file="${video_file%.*}-llc-edl.csv"
  tracks=()
  main_in=0
  main_out=0
  main_offset=0

  if [[ -f "$edl_file" ]]; then
    echo $edl_file
    mapfile -t segments \
      < <( awk -F, '{printf "%8s,%8s,%s\n", int(24*$1), int(24*$2), $3}' "$edl_file" )
    # segments_count=${#segments[@]}
    for segment in "${segments[@]}"; do
      echo $segment
      in=$( echo $segment | awk -F, '{print $1}' )
      in=$(( in * 1 ))
      out=$( echo $segment | awk -F, '{print $2}' )
      out=$(( out * 1 ))
      action=$( echo $segment | awk -F, '{print $3}' )
      cmd=$( echo $action | awk -F ": " '{print $1}' )
      echo $action
      case $cmd in
        'trim' )
          # echo trim!
          text=$( echo $action | awk -F":" '{print $2}' )
          if [[ $text == *start ]]; then
            main_in=$out
            main_offset=$(( main_offset + main_in ))
            
            # echo "trim: start - $main_in"
          fi
          if [[ $text == *end ]]; then
            main_out=$in
            # echo "trim: end - $main_out"
          fi
          ;;
        'img' )
          text=$( echo $action | awk -F":" '{print $2}' )
          caption_file=$( img_caption "IMG: $text" )
          # track=" -track -blank $in $caption_file bgcolour=0x00000000 out=44"
          in=$(( in - main_offset ))
          out=$(( out - main_offset ))
          track=" -attach watermark:$caption_file in=$in out=$out -transition luma a_track=0 b_track=1"
          tracks+=( $track )
          ;;
        'mp4' )
          text=$( echo $action | awk -F":" '{print $2}' )
          caption_file=$( img_caption "MP4: $text" )
          # track=" -track -blank $in $caption_file bgcolour=0x00000000 out=44"
          in=$(( in - main_offset ))
          out=$(( out - main_offset ))
          track=" -attach watermark:$caption_file in=$in out=$out -transition luma a_track=0 b_track=1"
          tracks+=( $track )
          ;;
        'caption' )
          text=$( echo $action | awk -F":" '{print $2}' )
          caption_file=$( img_caption "$text" )
          # track=" -track -blank $in $caption_file bgcolour=0x00000000 out=44"
          in=$(( in - main_offset ))
          out=$(( out - main_offset ))
          track=" -attach watermark:$caption_file in=$in out=$out -transition luma a_track=0 b_track=1"
          tracks+=( $track )
          ;;
      esac
    done
  fi
  echo ${tracks[@]}
  melt $video_file in=$main_in out=$main_out ${tracks[@]} -consumer xml:"$PWD/$video_file.mlt"
  melt "$video_file.mlt"
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
