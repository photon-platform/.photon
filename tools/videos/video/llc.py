import json5 
import sys, os
import subprocess
from geometor.title import *
from slugify import slugify

current_folder = os.path.abspath('.')

video_filename = sys.argv[1]

try:
    response =  subprocess.check_output(["exiftool", "-VideoFrameRate", video_filename])
except:
    print('exiftool error')

response = response.decode("utf-8") 
vfr = str(response).split(': ')[1]
vfr = float(vfr)

print('VideoFrameRate:', vfr)

video_llc = os.path.splitext(video_filename)[0]+'-proj.llc'

with open(video_llc) as llc_file:
    js = json5.load(llc_file)
    segments = js['cutSegments']


cmd = ['melt']
tracks = []
track_ctr = 0
clip_in = 0
clip_out = 0
clip_offset = 0
clip_track = 0
clip_length = 0

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
        #  cmd += f' -track -blank {clip_offset} "{video_filename}" in={start} out={end} '
        steps = [
                '-track', '-blank', str(clip_offset), 
                video_filename, f'in={start}', f'out={end}'
        ]
        cmd.extend(steps)
        clip_in = start
        clip_out = end
        clip_length = end - start
    elif action == 'img':
        start = start - clip_in
        end = end - clip_in
        # track=" -track -blank $in $caption_file bgcolour=0x00000000 out=44"
        #  cmd += f'    -attach watermark:{data} in={start} out={end} -transition luma a_track=0 b_track=1 \ \n'
        steps = [
                '-attach', f'watermark:{data}', f'in={start}', f'out={end}', 
                '-transition', 'luma', 'a_track=0', 'b_track=1', 
        ]
        cmd.extend(steps)
    elif action == 'caption':
        #  title = data
        #  img_filename = f'{slugify(data)}.png'
        #  plot_overlay(title, current_folder, img_filename) 
        script = os.path.expanduser('~')
        script = os.path.join(script, '.photon/tools/overlays/overlay_left.sh')
        response = ''
        print(script)
        from subprocess import Popen, PIPE

        session = subprocess.Popen([ script, data ], stdout=PIPE, stderr=PIPE)
            #  response = subprocess.check_output(
                    #  ['bash', script, f'"{data}"']
                    #  )
        stdout, stderr = session.communicate()

        if stderr:
            raise Exception("Error "+str(stderr))
        img_filename = stdout.decode('utf-8').strip()
        #  try:
            #  response = subprocess.check_output(
                    #  ['bash', script, f'"{data}"']
                    #  )
        #  except:
            #  print('overlay error')

        #  img_filename = response.decode("utf-8") 
        #  img_filename = response
        print('img_filename: ', img_filename)

        start = start - clip_in
        end = end - clip_in
        tr = 12
        steps = [
                '-track', '-blank', str(clip_offset + start), img_filename, f'out={end - start}',
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

        
        #  cmd += f'  -track -blank { clip_offset + start } "{img_filename}" out={ end - start }'
        #  cmd += f'    -transition luma  in={ clip_offset + start } out={ clip_offset + start + tr } a_track={ clip_track } b_track={ track_ctr}'
        #  cmd += f'    -transition luma  in={ clip_offset + out - tr } out={ clip_offset + out + 1} reverse=1 a_track={clip_track} b_track={track_ctr}'

        #  cmd+="    -transition composite  a_track={clip_track} b_track={track_ctr}"
        
mlt_file = video_filename + '.mlt'
steps = ['-consumer', f'xml:{mlt_file}']
cmd.extend(steps)
print()
print(cmd)
with open('mlt.sh', 'w') as f:
    f.write(' '.join(cmd))

subprocess.run(cmd)

subprocess.run(['melt', mlt_file])

'''

  case $action_cmd in
    'clip' )
      text=$( echo $action | awk -F": " '{print $2}' )

      clip_track=$track_ctr
      (( track_ctr++ )me)

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

'''
