
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

