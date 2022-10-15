"""
translate edl from losslesscut json5 file
to a melt file to render video
"""
import json5
import sys, os
from pathlib import Path
import subprocess
from geometor.title import *
from slugify import slugify

OVERLAY_SCRIPT = Path('~/.photon/tools/overlays/overlay_left.sh').expanduser()

def read_videoframerate(video_path) -> float:
    """TODO: Docstring for read_videoframerate.
    :video_path: str or Path
    :returns: TODO

    """
    video_path = Path(video_path)
    if video_path.is_file():
        try:
            cmd = ["exiftool", "-VideoFrameRate", str(video_path)]
            response =  subprocess.check_output(cmd)
        except:
            print('ERROR: exiftool ')
            print(response)
            return 0

        response = response.decode("utf-8")
        vfr = str(response).split(': ')[1]
        vfr = float(vfr)
        return vfr
    else:
        print(video_path, "is not a file.")
        return 0


def read_llc_segments(video_path) -> list:
    """open the corresponding llc file for the ``video_path``

    :video_path: TODO
    :returns: TODO

    """
    segments = []
    video_path = Path(video_path)
    parent = video_path.resolve().parent
    stem = video_path.stem

    video_llc_path = parent.joinpath(stem + '-proj.llc')

    with open(video_llc_path) as llc_file:
        js = json5.load(llc_file)
        segments = js['cutSegments']

    return segments


def get_caption_overlay(caption: str) -> str:
    """TODO: generate a transparent png with caption on left

    :caption: str
    :returns: str

    """
    from subprocess import Popen, PIPE

    session = subprocess.Popen([ OVERLAY_SCRIPT, caption ], stdout=PIPE, stderr=PIPE)
    stdout, stderr = session.communicate()
    if stderr:
        raise Exception("Error "+str(stderr))

    img_filename = stdout.decode('utf-8').strip()
    return img_filename



def llc_to_mlt(video_path):
    """TODO: Docstring for llc_to_melt.
    :returns: TODO

    """
    video_path = Path(video_path)

    vfr = read_videoframerate(video_path)
    if vfr:
        print('VideoFrameRate:', vfr)
    else:
        print('error reading VideFrameRate')
        return

    cmd = ['melt']
    tracks = []
    track_ctr = 0
    clip_in = 0
    clip_out = 0
    clip_offset = 0
    clip_track = 0
    clip_length = 0

    segments = read_llc_segments(video_path)
    for seg in segments:
        start = int(seg['start'] * vfr)
        end = int(seg['end'] * vfr)
        label = seg['name']
        action, data = label.split(': ')
        data = data.strip()
        print( start, end, action, data )

        if action == 'clip':
            clip_track = track_ctr
            track_ctr += 1

            # add previous clip length to offest
            clip_offset += clip_length
            steps = ['-track']
            if clip_offset:
                steps.extend(['-blank', str(clip_offset)])

            steps.extend([ str(video_path), f'in={start}', f'out={end}' ])

            cmd.extend(steps)
            clip_in = start
            clip_out = end
            clip_length = end - start

        elif action == 'img':
            start = start - clip_in
            end = end - clip_in
            steps = [
                    '-attach', f'watermark:{data}', f'in={start}', f'out={end}',
                    '-transition', 'luma', 'a_track=0', 'b_track=1',
            ]
            cmd.extend(steps)

        elif action == 'caption':
            img_filename = get_caption_overlay(data)
            print('img_filename: ', img_filename)

            start = start - clip_in
            end = end - clip_in
            tr = 12
            steps = [
                    '-track',
                    '-blank', str(clip_offset + start),
                    img_filename, f'out={end - start}',
                    '-transition', 'luma',
                        f'in={clip_offset + start}', f'out={clip_offset + start + tr}',
                        f'a_track={clip_track}', f'b_track={track_ctr}',
                    '-transition', 'luma',
                        f'in={clip_offset + end - tr}', f'out={clip_offset + end + 1}',
                        'reverse=1',
                        f'a_track={clip_track}', f'b_track={track_ctr}',
                    '-transition', 'composite',
                        f'a_track={clip_track}', f'b_track={track_ctr}',
            ]
            cmd.extend(steps)
            track_ctr += 1

    #  suffix = video_path.suffix
    mlt_path = video_path.with_suffix('.mlt')
    mlt_file = str(mlt_path)
    #  sh_file = str(sh_path)

    steps = ['-consumer', f'xml:{mlt_file}']
    cmd.extend(steps)

    print()
    print(cmd)
    # write command to file
    #  sh_path = video_path.with_suffix('.mlt.sh')
    #  #  with sh_path.open('w') as f:
        #  #  f.write(' '.join(cmd))
    #  sh_path.write_text(' '.join(cmd))
    #  sh_path.chmod(0o777)

    # generate mlt file
    subprocess.run(cmd)

    # play melt file
    subprocess.run(['melt', mlt_file])



if __name__ == '__main__':
    video_path = Path(sys.argv[1])
    llc_to_mlt(video_path)

'''

      case $action_cmd in
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

    '''
