import subprocess
import os as os
from rich import print, inspect
from rich.console import Console
console = Console()

from session_music import *

import ffmpeg

MUSIC = True
TICK = True

root = pm.N.A3
octaves = 2
scale_type = pm.S.dorian
#  scale_type = pm.S.pentatonic_major

scale = pm.build_scale(
    root=root, 
    scale_type=scale_type, 
    octaves=octaves)

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
        mf = pm.new_midi(title=title, tempo=tempo)
        M = 4 * mf.ticks_per_beat
        beat = mf.ticks_per_beat

        vibes = pm.make_vibes(mf, 1)
        bass = pm.make_bass(mf, 2)
        horns = pm.make_horns(mf, 3)
        strings = pm.make_strings(mf, 4)

        kick = pm.make_kick(mf)
        #  snare = pm.make_snare(mf)
        ride = pm.make_ride(mf)
        #  hihat_closed = pm.make_hihat_closed(mf)

        #  choir = pm.make_choir_swell(mf)
        #  solo = pm.make_solo_aah(mf)
        
        #  files = [f for f in files if ('circle' in f or 'line' in f) ]
        files = [f for f in files if '.png' in f]
        files = [f for f in files if 'zoom' not in f]
        os.makedirs(f'{d}/output', exist_ok=True)
        with open(f'{d}/output/sequence.lst', 'w') as lst:
            for f_id, f in enumerate(sorted(files)):
                png = os.path.join(d_seq, f)
                mp4 = f'{d}/output/{f}.mp4'
                note_id = f_id % len(scale)
                note = scale[note_id]

                r = 2
                if 'line' in f:
                    r = 1
                    hold = 0
                    #  for f in files[f_id+1:]:
                        #  if 'line' not in f and 'circle' not in f and 'polygon' not in f:
                            #  hold += 1
                        #  else:
                            #  break
                    #  dur = (2 + hold - 1) * beat
                    dur = 2 * beat
                    breakpoint()
                    if TICK:
                        #  ride.set_hits(dur, 2 + hold - 1)
                        ride.set_hits(dur, 2)
                    if MUSIC:
                        strings.set_note(note, dur)
                        horns.set_rest(dur)
                        vibes.set_rest(dur)
                elif 'circle' in f:
                    r = 1
                    hold = 0
                    #  for f in files[f_id:]:
                        #  if 'line' not in f and 'circle' not in f and 'polygon' not in f:
                            #  hold += 1
                        #  else:
                            #  break
                    #  dur = (2 + hold - 1) * beat
                    dur = 2 * beat
                    if TICK:
                        #  ride.set_hits(dur, 2 + hold - 1)
                        ride.set_hits(dur, 2)
                    if MUSIC:
                        horns.set_note(note - 12, dur)
                        strings.set_rest(dur)
                        vibes.set_rest(dur)

                elif 'polygon' in f:
                    r = 1 / 2
                    dur = 4 * beat
                    if TICK:
                        ride.set_hits(dur, 4)
                    if MUSIC:
                        strings.set_note(note, dur)
                        horns.set_note(note - 12 , dur)
                        vibes.set_rest(dur)
                else:
                    r = 2
                    if TICK:
                        ride.set_hit(beat)
                    if MUSIC:
                        vibes.set_note(note, beat)
                        horns.set_rest(beat)
                        strings.set_rest(beat)

                #  frame = ffmpeg.input(png, r=r)
                #  frame = ffmpeg.output(frame, mp4)
                #  ffmpeg.run(frame, quiet=True,  overwrite_output=True,)

                lst.write(f'file {png}\n')
                lst.write(f'duration { float( 1 / r ) }\n')

                print(f' • {f}')

                f = os.path.splitext(f)[0] 
                #  num, *type = f.split('-')
                #  print(int(num), *type)

    #  midi_path = pm.save_midi(mf, f'{d}/output', 'sequence.mid')
    midi_path = f'{d}/output/sequence.mid'
    mf.save(midi_path)

    proc = ['timidity', '-c', '~/.photon/timidity.cfg', ]
    proc.append('-Ov')
    proc.append(midi_path)
    subprocess.run(proc)

    proc = ['ffmpeg']
    proc.append('-y')
    proc.append('-hide_banner')
    proc.append('-f')
    proc.append('concat')
    proc.append('-safe')
    proc.append('0')
    proc.append('-i')
    proc.append(f'{d}/output/sequence.lst')
    proc.append('-i')
    proc.append(f'{d}/output/sequence.ogg')
    proc.append('-r')
    proc.append('60')
    #  proc.append(f'{d}/output/sequence_v.mp4')
    proc.append(f'{d}/sequences.mp4')
    subprocess.run(proc)

    #  seq_v = ffmpeg.input(f'{d}/output/sequence_v.mp4')
    #  seq_a = ffmpeg.input(f'{d}/output/sequence.ogg')
    #  stream = ffmpeg.output(seq_v, seq_a, f'{d}/sequence.mp4')
    #  ffmpeg.run(stream, overwrite_output=True)


def process_all():
    dirs = [d.path for d in os.scandir() if d.is_dir()]

    print(dirs)
    for d in sorted(list(dirs)):
        generate_sequence(d)
