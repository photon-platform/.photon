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
    pngs = list(sorted(pngs))
    pngs = [f for f in pngs if 'summary' not in f]

    files = [f for f in pngs if 'zoom' not in f]

    build_sequence_list(folder, files, scale, tempo)


def build_sequence_elements(d, scale, tempo, tick=True, music=True):
    '''will expect correct folders and files'''
    
    folder = 'sequences'
    d = os.path.abspath(d)
    folder = os.path.join(d, folder)
    console.rule(folder)

    pngs = [f.path for f in os.scandir(folder) if 'png' in f.path]
    pngs = list(sorted(pngs))
    pngs = [f for f in pngs if 'summary' not in f]

    files = [f for f in pngs if 'zoom' not in f]
    files = [f for f in files if 'line' in f or 'circle' in f or 'polygon' in f]

    build_sequence_list(folder, files, scale, tempo)



def build_sequence_list(folder, files, scale, tempo, tick=True, music=True):
    title = folder
    mf = pm.new_midi(title=title, tempo=tempo)
    M = 4 * mf.ticks_per_beat
    beat = mf.ticks_per_beat

    bass, vibes, horns, strings, kick, ride = build_band(mf)
    tick = pm.make_tick(mf)
    tick.set_volume(30, 0)

    os.makedirs(f'{folder}/build', exist_ok=True)
    with open(f'{folder}/build/build.lst', 'w') as lst:
        # filter files to find elements for held tones
        elements = [f for f in list(enumerate(files)) ]
        elements = [f for f in elements if 'line' in f[1] or 'circle' in f[1] or 'polygon' in f[1]]
        #  breakpoint()

        # start with summary image
        lst.write(f'file ../summary.png\n')
        img_beats = 4

        dur = pm.tick2second(img_beats * beat, beat, tempo)
        lst.write(f'duration { float(dur) }\n')

        dur = img_beats * beat
        tick.set_hits(img_beats * beat, img_beats)
        vibes.set_rest(dur)
        horns.set_rest(dur)
        strings.set_rest(dur)
        strings.set_volume(0, dur)
        horns.set_volume(0, dur)

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

            img_beats = 1
            if 'line' in f:
                img_beats = 2
                hold = img_beats
                # add beats to next element to hold
                for i, el in enumerate(elements):
                    if el[0] == f_id and i < len(elements) - 1:
                        hold += elements[i+1][0] - f_id - 1
                        break
                dur = hold * beat
                #  breakpoint()
                if tick:
                    tick.set_hits(img_beats * beat, 2)
                if music:
                    vibes.set_rest(img_beats * beat)

                    strings.set_note(note, dur)
                    set_volume_envelope(strings, dur)
                    
                    horns.set_rest(dur)
                    horns.set_volume(0, dur)
            elif 'circle' in f:
                img_beats = 2
                hold = img_beats
                # add beats to next element to hold
                for i, el in enumerate(elements):
                    if el[0] == f_id and i < len(elements) - 1:
                        hold += elements[i+1][0] - f_id - 1
                        break
                dur = hold * beat
                #  breakpoint()
                if tick:
                    tick.set_hits(img_beats * beat, 2)
                if music:
                    vibes.set_rest(img_beats * beat)

                    horns.set_note(note - 12, dur)
                    set_volume_envelope(horns, dur)

                    strings.set_rest(dur)
                    strings.set_volume(0, dur)
            elif 'polygon' in f:
                img_beats = 4
                dur = img_beats * beat
                if tick:
                    tick.set_hits(dur, 4)
                if music:
                    vibes.set_rest(dur)

                    strings.set_note(note, dur)
                    set_volume_envelope(strings, dur)
                
                    horns.set_note(note - 12 , dur)
                    set_volume_envelope(horns, dur)
            else:
                if tick:
                    tick.set_hit(beat)
                if music:
                    vibes.set_note(note + 12, beat)


            # append to concat list
            lst.write(f'file {png}\n')
            dur = pm.tick2second(img_beats * beat, beat, tempo)
            lst.write(f'duration { float(dur) }\n')

            print(dur, f)

        # rest horns and strings for last notes
        last_el = elements[-1][0]
        num_beats = len(files) - last_el
        dur = num_beats * beat
        horns.set_rest(dur)
        strings.set_rest(dur)
        strings.set_volume(40, dur)
        horns.set_volume(40, dur)

        # add summary
        lst.write(f'file ../summary.png\n')
        lst.write(f'duration 8\n')
        if tick:
            tick.set_hits(8 * beat, 8)
        if music:
            notes = []
            for i in [0, 2, 4, 6, 8, 10, 12]:
                notes.append(scale[i])
            horns.set_notes(notes[0:3], 8 * beat)
            set_volume_envelope(horns, 8 * beat)
            
            strings.set_rest(4 * beat)
            set_volume_envelope(strings, 4 * beat)
            strings.set_notes(notes[3:6], 4 * beat)
            set_volume_envelope(strings, 4 * beat)
            
            #  arp_notes = [n + 12 for n in notes]
            #  vibes.set_rest(4 * beat)
            #  pm.add_arp_up(vibes, scale, 4 * beat)

        tick.set_hits(4 * beat, 4)
        
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
    proc.append(f'{folder}/sequences.mp4')
    subprocess.run(proc)

