import subprocess
import os as os
import ffmpeg
from rich import print, inspect
from rich.console import Console
console = Console()

from sessions.music import *

def build_groups(d, scale, tempo, tick=True, music=True):
    '''will expect correct folders and files'''
    
    folder = 'groups'
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
        for f_id, f in enumerate(sorted(files)):
            png = os.path.join(folder, f)
            mp4 = f'{folder}/build/{f}.mp4'
            notes = []
            notes.append(random.choice(scale))
            notes.append(random.choice(scale))

            r = 2
            if tick:
                ride.set_hit(beat)
            if music:
                pm.add_arp_up(vibes, notes, beat)
                strings.set_notes(notes, beat)

            lst.write(f'file {png}\n')
            lst.write(f'duration { float( 1 / r ) }\n')

            print(f' • {f}')

            f = os.path.splitext(f)[0] 

        # add summary
        lst.write(f'file {d}/sections/summary.png\n')
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
        
    #  midi_path = pm.save_midi(mf, f'{folder}/build', 'build.mid')
    midi_path = f'{folder}/build/build.mid'
    mf.save(midi_path)

    proc = ['timidity', '-c', '~/.photon/timidity.cfg', ]
    proc.append('-Ov')
    proc.append(midi_path)
    subprocess.run(proc)

    #  breakpoint()
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
    proc.append(f'{d}/groups.mp4')
    subprocess.run(proc)

