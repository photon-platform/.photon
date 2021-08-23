#!/usr/bin/env bash

function audio_actions() {
  declare -A actions
  actions['?']="help"
  actions[q]="quit"

  actions[l]="losslesscut"
  actions[u]="audacity"
  actions[p]="mpv"
  actions[r]="audio_process"
  actions[e]="audio_edl"
  actions[m]="audio_migrate"
  actions[x]="audio_trash"

  actions[h]="back to audios"
  actions[j]="move to next sibling audio"
  actions[k]="move to prev sibling audio"
  actions['#']="select child by number (multi-digit, type enter)"

  actions[E]="Exif"

  echo
  hr
  P=" ${fgYellow}AUDIO${txReset}"
  read -n1 -p "$P > " action
  printf " $SEP ${actions[$action]}\n\n"
  case $action in
    \?)
      for key in "${!actions[@]}"; do
        key_item $key "${actions[$key]}"
      done
      audio_actions
      ;;
    q) audios; ;;
    n) image_rename "$file"; audios; ;;
    m) audio_migrate "$file"; audios; ;;
    r) audio_process "$file"; ;;
    e) audio_edl "$file"; audio "$file" $audio_index; ;;
    # m) audio_melt "$file"; audio "$file" $audio_index; ;;
    # b) audio_build "$file"; audio "$file" $audio_index; ;;
    x) audio_trash "$file"; audios; ;;
    l) losslesscut "$file"; audio "$file" $audio_index; ;;
    u) audacity "$file"; audio "$file" $audio_index; ;;
    p) mpv "$file" --keep-open=yes; audio "$file" $audio_index; ;;
    h) audios ;;
    j)
      id=$((audio_index + 1))
      if [[ ${list[$id]} ]]; then
        audio "${list[$id]}" $id
      else
        audio "$file" $audio_index
      fi
      ;;
    k)
      id=$((audio_index - 1))
      if [[ ${list[$id]} ]]; then
        audio "${list[$id]}" $id
      else
        audio "$file" $audio_index
      fi
      ;;
    i) exiftool "$file" | less ; audio "$file" $audio_index; ;;
    E) tools_exif_actions;
      audio "$file" $audio_index
      ;;
    *)
      audio "$file" $audio_index;
      ;;
  esac
}

function audio_migrate() {
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


# af="highpass=f=100, volume=volume=5dB, afftdn, deesser=i=1" 
# af="adeclick,deesser=i=1,afftdn=nr=80:nf=-20:nt=w:om=o,highpass=f=70,loudnorm=I=-16:TP=-1.5:LRA=14" 

AUDIO_FILTERS=()
# AUDIO_FILTERS+=("deesser=i=1")
AUDIO_FILTERS+=("highpass=f=70")
AUDIO_FILTERS+=("lowpass=f=3000")
AUDIO_FILTERS+=("afftdn")
AUDIO_FILTERS+=("volume=volume=7dB")
AF=$(printf '%s,' "${AUDIO_FILTERS[@]}")
AF="${AF%,}"

function audio_process() {
  input=$1
  if [[ "$input" == *.raw.m4a ]]; then
    output="${input%.raw.m4a}.m4a"

    if [[ $output ]]; then
      mv $output $output.bak
    fi

    # af="highpass=f=100, volume=volume=5dB, afftdn" 
    # af="$AF" 
    # dur=$(ffprobe -hide_banner -i "$input"  -show_entries format=duration -v quiet -of csv="p=0")

    echo
    ui_banner "process audio: "
    h1 "$AF"

    ffmpeg -y  -hide_banner \
      -i "$input" \
      -map_metadata 0 \
      -af "$AF" \
      "$output" 

    echo

    getExif "$input"
    notes="$(getExifValue "Notes")"
    processed="processed $( date +"%g.%j.%H%M%S" ) : af='$AF' "
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

    audio "$output"
  else
    echo "$input is not a raw file"
  fi
}

function audio_edl() {
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

function audio_melt() {
  file=$1
  edl_file="${file%.*}-llc-edl.csv"
  tracks=()
  main_in=0
  main_out=0
  main_offset=0

  if [[ -f "$edl_file" ]]; then
    echo $edl_file
    mapfile -t segments \
      < <( awk -F, '{printf "%s,%s,%s\n", $1, $2, $3}' "$edl_file" )
    # segments_count=${#segments[@]}
    for segment in "${segments[@]}"; do
      echo $segment
      in=$( echo $segment | awk -F, '{print $1}' )
      in=$(( in * 1 ))
      out=$( echo $segment | awk -F, '{print $2}' )
      out=$(( out * 1 ))
      action=$( echo $segment | awk -F, '{print $3}' )
      cmd=$( echo $action | awk -F ": " '{print $1}' )
      # echo $action
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
          img=$( echo $action | awk -F":" '{print $2}' )
          img=$( echo -e "$img" | sed 's/^[[:blank:]]*//;s/[[:blank:]]*$//' )
          in=$(( in - main_offset ))
          out=$(( out - main_offset ))
          # track=" -track -blank $in $caption_file bgcolour=0x00000000 out=44"
          track=" -attach watermark:$img in=$in out=$out -transition luma a_track=0 b_track=1"
          tracks+=( $track )
          ;;
        'mp4' )
          mp4=$( echo $action | awk -F":" '{print $2}' )
          mp4=$( echo -e "$mp4" | sed 's/^[[:blank:]]*//;s/[[:blank:]]*$//' )
          in=$(( in - main_offset ))
          out=$(( out - main_offset ))
          # track=" -track -blank $in $caption_file bgcolour=0x00000000 out=44"
          track=" -attach watermark:$mp4 in=$in out=$out -transition luma a_track=0 b_track=1"
          tracks+=( $track )
          ;;
        'title' )
          text=$( echo $action | awk -F":" '{print $2}' )
          overlay_img=$( overlay_title "$text" )
          in=$(( in - main_offset ))
          out=$(( out - main_offset ))
          track=" -attach watermark:$overlay_img in=$in out=$out -transition luma a_track=0 b_track=1"
          tracks+=( $track )
          echo $overlay_img
          ;;
        'caption' )
          text=$( echo $action | awk -F":" '{print $2}' )
          overlay_img=$( overlay_left "$text" )
          in=$(( in - main_offset ))
          out=$(( out - main_offset ))
          track=" -attach watermark:$overlay_img in=$in out=$out -transition luma a_track=0 b_track=1 in=0 out=24"
          tracks+=( $track )
          echo $overlay_img
          ;;
      esac
    done
  fi
  echo ${tracks[@]}
  melt $file in=$main_in out=$main_out ${tracks[@]} -consumer xml:"$PWD/$file.mlt"
  melt "$file.mlt"
}

function audio_trash() {
  img=$1

  hr
  ui_banner "TRASH $SEP $img"
  echo

  if [[ "$( ask_truefalse "continue" )" == "true" ]]; then
    gio trash "$img"
  fi
}
