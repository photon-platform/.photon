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
    choir = pm.make_choir_swell(mf)

    os.makedirs(f'{folder}/build', exist_ok=True)
    with open(f'{folder}/build/build.lst', 'w') as lst:
        files = [f for f in pngs if 'zoom' not in f]
        steps = np.linspace(32, 96, num=len(files), dtype=int)
        for f_id, f in enumerate(reversed(sorted(files))):
            png = os.path.join(folder, f)
            mp4 = f'{folder}/build/{f}.mp4'
            notes = []
            n1 = random.randint(0, len(scale) - 1)
            n2 = (n1 + 2) % len(scale)
            notes.append(scale[n1])
            notes.append(scale[n2])

            if tick:
                ride.set_hit(beat)
            if music:
                vibe_notes = [note + 24 for note in notes]
                pm.add_arp_up(vibes, vibe_notes, beat)
                strings.set_notes(notes, beat, velocity=40)

                vibes.set_volume(steps[f_id], beat)
                strings.set_volume(steps[f_id], beat)

            lst.write(f'file {png}\n')
            dur = pm.tick2second(beat, beat, tempo)
            lst.write(f'duration { float(dur) }\n')

            print(f' • {f}')

            f = os.path.splitext(f)[0] 

        # add summary
        lst.write(f'file {d}/sections/summary.png\n')
        dur = pm.tick2second(beat, beat, tempo)
        lst.write(f'duration { float(dur) }\n')
        num_beats = 32
        if tick:
            ride.set_hits(num_beats * beat, num_beats)
        if music:
            notes = []
            for i in [0, 2, 4, 6, 8, 10, 12]:
                notes.append(scale[i])
            strings.set_notes(notes[0:3], num_beats * beat)
            set_volume_envelope(strings, num_beats * beat)

            choir.set_rest(len(files) * beat)
            choir.set_notes(notes, num_beats * beat)
            set_volume_envelope_reverse(strings, num_beats * beat)

            #  num_beats = int(num_beats / 2)
            #  vibes.set_rest(num_beats * beat)
            #  pm.add_arp_up(vibes, notes, num_beats * beat)
            #  vibes.set_notes(notes[4:7], 2 * beat)
        ride.set_hits(num_beats * beat, num_beats)
        
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
    proc.append(f'{folder}/groups.mp4')
    subprocess.run(proc)

