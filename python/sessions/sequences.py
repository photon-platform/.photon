import subprocess
import os as os
import ffmpeg
from rich import print, inspect
from rich.console import Console
console = Console()

from sessions.music import *

def set_volume_envelope(inst, dur):
    b = dur/ 32
    #  dur_in = dur / 8
    #  dur_out = 7 * dur / 8
    #  steps = np.arange(32, 96, 4)
    #  for val in steps:
    val = 32
    for _ in range(8):
        inst.set_volume(val, b)
        val += 6
    for _ in range(24):
        inst.set_volume(val, b)
        val -= 2

def build_sequence(d, scale, tempo, tick=True, music=True):
    '''will expect correct folders and files'''
    
    folder = 'sequences'
    d = os.path.abspath(d)
    folder = os.path.join(d, folder)
    console.rule(folder)

    pngs = [f.path for f in os.scandir(folder) if 'png' in f.path]
    pngs = list(sorted(pngs))
    pngs = [f for f in pngs if 'summary' not in f]

    title = folder
    mf = pm.new_midi(title=title, tempo=tempo)
    M = 4 * mf.ticks_per_beat
    beat = mf.ticks_per_beat

    bass, vibes, horns, strings, kick, ride = build_band(mf)
    tick = pm.make_tick(mf)
    tick.set_volume(30, 0)

    os.makedirs(f'{folder}/build', exist_ok=True)
    with open(f'{folder}/build/build.lst', 'w') as lst:
        frames = []
        files = [f for f in pngs if 'zoom' not in f]
        elements = [f for f in list(enumerate(files)) ]
        elements = [f for f in elements if 'line' in f[1] or 'circle' in f[1] or 'polygon' in f[1]]
        #  breakpoint()

        # rest horns and strings until first note
        dur = 2 * beat
        horns.set_rest(dur)
        strings.set_rest(dur)
        strings.set_volume(0, dur)
        horns.set_volume(0, dur)

        for f_id, f in enumerate(files):
            png = os.path.join(folder, f)
            note_id = f_id % len(scale)
            note = scale[note_id]

            r = 2
            if 'line' in f:
                hold = 2
                for i, el in enumerate(elements):
                    if el[0] == f_id and i < len(elements) - 1:
                        hold += elements[i+1][0] - f_id - 1
                        break
                r = 1
                dur = hold * beat
                #  breakpoint()
                if tick:
                    tick.set_hits(2 * beat, 2)
                if music:
                    vibes.set_rest(2 * beat)

                    strings.set_note(note, dur)
                    set_volume_envelope(strings, dur)
                    
                    horns.set_rest(dur)
                    horns.set_volume(0, dur)
            elif 'circle' in f:
                r = 1
                hold = 2
                for i, el in enumerate(elements):
                    if el[0] == f_id and i < len(elements) - 1:
                        hold += elements[i+1][0] - f_id - 1
                        break
                r = 1
                dur = hold * beat
                #  breakpoint()
                if tick:
                    tick.set_hits(2 * beat, 2)
                if music:
                    vibes.set_rest(2 * beat)

                    horns.set_note(note - 12, dur)
                    set_volume_envelope(horns, dur)

                    strings.set_rest(dur)
                    strings.set_volume(0, dur)
            elif 'polygon' in f:
                r = 1 / 2
                dur = 4 * beat
                if tick:
                    tick.set_hits(dur, 4)
                if music:
                    vibes.set_rest(dur)

                    strings.set_note(note, dur)
                    set_volume_envelope(strings, dur)
                
                    horns.set_note(note - 12 , dur)
                    set_volume_envelope(horns, dur)
            else:
                r = 2
                if tick:
                    tick.set_hit(beat)
                if music:
                    vibes.set_note(note, beat)


            lst.write(f'file {png}\n')
            lst.write(f'duration { float( 1 / r ) }\n')

            print(f' • {f}')

            #  f = os.path.splitext(f)[0] 
            #  #  num, *type = f.split('-')
            #  #  print(int(num), *type)

        # rest horns and strings for last notes
        dur = beat
        horns.set_rest(dur)
        strings.set_rest(dur)
        strings.set_volume(40, dur)
        horns.set_volume(40, dur)

        # add summary
        lst.write(f'file ../summary.png\n')
        lst.write(f'duration 4\n')
        if tick:
            tick.set_hits(4 * beat, 4)
        if music:
            notes = []
            for i in [0, 2, 4, 6, 8, 10, 12]:
                notes.append(scale[i])
            horns.set_notes(notes[0:3], 8 * beat)
            set_volume_envelope(horns, 8 * beat)
            
            strings.set_rest(beat)
            strings.set_notes(notes[2:4], 7 * beat)
            set_volume_envelope(strings, beat)
            
            arp_notes = [n + 12 for n in notes]
            vibes.set_rest(6 * beat)
            pm.add_arp_up(vibes, scale, 2 * beat)
        
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

