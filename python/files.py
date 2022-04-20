import subprocess
import os as os
from rich import print, inspect
from rich.console import Console
console = Console()

import ffmpeg

def generate_sequence(d):
    '''will expect correct folders and files'''
    d = os.path.abspath(d)
    console.rule(d, align='left')
    d_seq = os.path.join(d, 'sequences')
    console.print(d_seq)
    #  stream = None
    #  files = [d.path for d in os.scandir(d_seq) if d.is_file()]
    frames = []

    for root, dirs, files in os.walk(d_seq):
        #  files = [f for f in files if ('circle' in f or 'line' in f) ]
        files = [f for f in files if '.png' in f]
        files = [f for f in files if 'zoom' not in f]
        with open(f'{d}/output/sequence.lst', 'w') as lst:
            for f in sorted(files):
                png = os.path.join(d_seq, f)
                mp4 = f'{d}/output/{f}.mp4'
                frame = ffmpeg.input(png, r=1)
                frame = ffmpeg.output(frame, mp4)
                frame = ffmpeg.overwrite_output(frame)
                ffmpeg.run(frame)
                #  frames.append(frame)

                lst.write(f'file {mp4}\n')
                #  frames.append(ffmpeg.input(png, r=1))
                #  frames.append(ffmpeg.input(os.path.join(d_seq, f), frames=24))
                f = os.path.splitext(f)[0] 
                #  num, *type = f.split('-')
                #  print(int(num), *type)

    #  out = ffmpeg.merge_outputs(*frames)
    #  print(ffmpeg.get_args(out))
    #  out = ffmpeg.concat(*frames)
    #  out = ffmpeg.input('output/sequence.lst', f='concat')
    #  out = ffmpeg.input('output/sequence.lst')
    #  out = ffmpeg.output(out, 'sequences3.mp4', unsafe=False)

    #  files = [f.path for f in list(os.scandir('output')) if '.mp4' in f.path]
    #  stream = ''
    #  inputs = []
    #  for f in files:
        #  inputs.append(ffmpeg.input(f))

    #  out = ffmpeg.output(*inputs, 'sequences3.mp4')
    #  ffmpeg.run(out)
    proc = ['ffmpeg']
    proc.append('-f')
    proc.append('concat')
    proc.append('-i')
    proc.append('output/sequence.lst')
    proc.append('-r')
    proc.append('60')
    proc.append('sequence4.mp4')
    subprocess.run(proc)


def process_all():
    dirs = [d.path for d in os.scandir() if d.is_dir()]

    print(dirs)
    for d in sorted(list(dirs)):
        generate_session(d)
