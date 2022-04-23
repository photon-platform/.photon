import subprocess
import os as os
import ffmpeg
from rich import print, inspect
from rich.console import Console
console = Console()

from sessions.music import *

def build_sequence(d, scale, tempo, tick=True, music=True):
    '''will expect correct folders and files'''
    
    folder = 'sequences'
    d = os.path.abspath(d)
    folder = os.path.join(d, folder)
    console.rule(folder)

    pngs = [f.path for f in os.scandir(folder) if 'png' in f.path]

    title = folder
    mf = pm.new_midi(title=title, tempo=tempo)
    M = 4 * mf.ticks_per_beat
    beat = mf.ticks_per_beat

    bass, vibes, horns, strings, kick, ride = build_band(mf)
    steps = np.arange(32, 96, 4)

    os.makedirs(f'{folder}/build', exist_ok=True)
    with open(f'{folder}/build/build.lst', 'w') as lst:
        frames = []
        files = [f for f in pngs if 'zoom' not in f]
        files = list(sorted(files))
        elements = [f for f in list(enumerate(files)) ]
        elements = [f for f in elements if 'line' in f[1] or 'circle' in f[1] or 'polygon' in f[1]]
        #  breakpoint()
        for f_id, f in enumerate(files):
            png = os.path.join(folder, f)
            note_id = f_id % len(scale)
            note = scale[note_id]

            r = 2
            if 'line' in f:
                hold = 2
                for i, el in enumerate(elements):
                    if el[0] == f_id and i < len(elements) - 2:
                        hold += elements[i+1][0] - f_id
                        break
                r = 1
                dur = hold * beat
                #  breakpoint()
                if tick:
                    ride.set_hits(dur, 2)
                if music:
                    vibes.set_rest(2 * beat)
                    strings.set_note(note, dur)
                    horns.set_rest(dur)
                    for val in steps:
                        strings.set_volume(val, dur)
                    for val in steps:
                        horns.set_volume(val, dur)
            elif 'circle' in f:
                r = 1
                hold = 2
                for i, el in enumerate(elements):
                    if el[0] == f_id and i < len(elements) - 2:
                        hold += elements[i+1][0] - f_id
                        break
                r = 1
                dur = hold * beat
                #  breakpoint()
                if tick:
                    ride.set_hits(dur, 2)
                if music:
                    vibes.set_rest(2 * beat)
                    horns.set_note(note - 12, dur)
                    strings.set_rest(dur)
                    for val in steps:
                        strings.set_volume(val, dur/len(steps))
                    for val in steps:
                        horns.set_volume(val, dur/len(steps))
            elif 'polygon' in f:
                r = 1 / 2
                dur = 4 * beat
                if tick:
                    ride.set_hits(dur, 4)
                if music:
                    strings.set_note(note, dur)
                    horns.set_note(note - 12 , dur)
                    vibes.set_rest(dur)
                    for val in steps:
                        strings.set_volume(val, dur/len(steps))
                    for val in steps:
                        horns.set_volume(val, dur/len(steps))
            else:
                r = 2
                if tick:
                    ride.set_hit(beat)
                if music:
                    vibes.set_note(note, beat)
                    #  horns.set_rest(beat)
                    #  strings.set_rest(beat)
                    dur = beat
                    for val in steps:
                        strings.set_volume(val, dur/len(steps))
                    for val in steps:
                        horns.set_volume(val, dur/len(steps))


            lst.write(f'file {png}\n')
            lst.write(f'duration { float( 1 / r ) }\n')

            print(f' • {f}')

            f = os.path.splitext(f)[0] 
            #  num, *type = f.split('-')
            #  print(int(num), *type)

        # add summary
        lst.write(f'file ../summary.png\n')
        lst.write(f'duration 4\n')
        if tick:
            ride.set_hits(4 * beat, 4)
        if music:
            notes = []
            for i in [1, 3, 5, 7, 9, 11, 13]:
                notes.append(scale[i])
            horns.set_notes(notes[0:3], 4 * beat)
            strings.set_rest(beat)
            strings.set_notes(notes[2:4], 3 * beat)
            vibes.set_rest(2 * beat)
            pm.add_arp_up(vibes, notes, 2 * beat)
            #  vibes.set_notes(notes[4:7], 2 * beat)
            dur = 4 * beat
            for val in steps:
                strings.set_volume(val, dur)
            for val in steps:
                horns.set_volume(val, dur)
        
    #  midi_path = pm.save_midi(mf, f'{folder}/build', 'build.mid')
    midi_path = f'{folder}/build/build.mid'
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
    proc.append(f'{folder}/build/build.lst')
    proc.append('-i')
    proc.append(f'{folder}/build/build.ogg')
    proc.append('-r')
    proc.append('60')
    proc.append(f'{d}/sequences.mp4')
    subprocess.run(proc)

