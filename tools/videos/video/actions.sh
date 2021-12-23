#!/usr/bin/env bash

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
    m) video_melt "$file"; video "$file" $video_index; ;;
    b) video_build "$file"; ;;
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
  file=$1
  edl_file="${file%.*}-llc-edl.csv"
  if [[ -f "$edl_file" ]]; then
    awk -F, '{printf "%8s %8s %s\n", int(24*$1), int(24*$2), $3}' "$edl_file"
    # mapfile  segments \
      # < <( awk -F, '{printf "%8s %8s %s\n", int(24*$1), int(24*$2), $3}' "$edl_file" )
    # segments_count=${#segments[@]}
    # for segment in "${segments[@]}"; do
      # echo $segment
    # done
    echo
    if [[ "$( ask_truefalse "edit?" )" == "true" ]]; then
      vim "$edl_file"
    fi
  fi
}

# vf="hue=s=0, eq=contrast=2:brightness=-.5" 
VIDEO_FILTERS=()
# VIDEO_FILTERS+=("hue=s=0")
VIDEO_FILTERS+=("eq=contrast=2:brightness=-.5")
VF=$(printf '%s,' "${VIDEO_FILTERS[@]}")
VF="${VF%,}"

function video_process() {
  input=$1
  if [[ "$input" == *.raw.mp4 ]]; then
    output="${input%.raw.mp4}.mp4"

    if [[ $output ]]; then
      mv $output $output.bak
    fi

    # dur=$(ffprobe -hide_banner -i "$input"  -show_entries format=duration -v quiet -of csv="p=0")

    echo
    ui_banner "process video: "
    h1 "vf=$VF"
    h1 "af=$AF"
    ffmpeg -y  -hide_banner \
      -i "$input" \
      -map_metadata 0 \
      -vf "$VF" \
      -af "$AF" \
      "$output" 

    echo

    getExif "$input"
    notes="$(getExifValue "Notes")"
    processed="processed $( date +"%g.%j.%H%M%S" ) : vf='$VF' : af='$AF' "
    if [[ $notes == "" ]]; then
      notes="$processed"
    else
      notes+=" | $processed"
    fi

    exiftool -ec \
      -DateTimeOriginal="$(getExifValue "DateTimeOriginal")" \
      -Title="$(getExifValue "Title")" \
      -Description="$(getExifValue "Description")" \
      -Notes="$notes" \
      -Subject="$(getExifValue "Subject")" \
      -Rating="$(getExifValue "Rating")" \
      -Colorlabels="$(getExifValue "Colorlabels")" \
      -Creator=$(getExifValue "Creator") \
      -Publisher="$(getExifValue "Publisher")" \
      -Copyright="$(getExifValue "Copyright")" \
      -overwrite_original \
      "$output"

    video "$output"
  else
    echo "$input is not a raw file"
  fi
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
  video_file=$1
  melt "$video_file.mlt"  -consumer avformat:"$video_file.mlt.mp4" 
  video "$video_file.mlt.mp4"
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
