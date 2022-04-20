import os as os
from rich import print, inspect
from rich.console import Console
console = Console()

import ffmpeg

def generate_session(d):
    '''will expect correct folders and files'''
    d = os.path.abspath(d)
    frames = []
    console.rule(d, align='left')
    d_seq = os.path.join(d, 'sequences')
    console.print(d_seq)
    #  stream = ffmpeg.Stream()
    stream = None
    #  files = [d.path for d in os.scandir(d_seq) if d.is_file()]
    for root, dirs, files in os.walk(d_seq):
        #  elements = [f for f in files if ('circle' in f or 'line' in f) and 'zoom' not in f]
        #  files = [f for f in files if ('circle' in f or 'line' in f) ]
        files = [f for f in files if '.png' in f]
        files = [f for f in files if 'zoom' not in f]
        for f in sorted(files):
            png = os.path.join(d_seq, f)
            #  frames.append(ffmpeg.input(png))
            #  png_stream = ffmpeg.input(png)
            png_stream = ffmpeg.input(png, r=60, vframes=120)
            if stream:
                stream = ffmpeg.concat(stream, png_stream)
            else:
                stream = png_stream

            #  frames.append(ffmpeg.input(png, r=1))
            #  frames.append(ffmpeg.input(os.path.join(d_seq, f), frames=24))
            f = os.path.splitext(f)[0] 
            #  num, *type = f.split('-')
            #  print(int(num), *type)
    #  stream = ffmpeg.concat(*frames)
    stream = ffmpeg.output(stream, f'{d}/sequences2.mp4')
    stream = ffmpeg.overwrite_output(stream)
    ffmpeg.run(stream)

dirs = [d.path for d in os.scandir() if d.is_dir()]

print(dirs)
for d in sorted(list(dirs)):
    generate_session(d)
