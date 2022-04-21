import phimidi as pm
import math as math
import subprocess as subprocess
import numpy as np
import itertools as itertools
import random as random

PROJECT = 'phi-midi'
NAME = 'house'

folder = f'{PROJECT}/{NAME}'
filename = f'{NAME}.mid'
title = f'{PROJECT} - {NAME}'

bpm = 90
tempo = int(pm.bpm2tempo(bpm))

root = pm.N.D3
octaves = 2
scale_type = pm.S.dorian
scale_type = pm.S.pentatonic_major
scale_type = pm.S.minor

scale = pm.build_scale(
    root=root, 
    scale_type=scale_type, 
    octaves=octaves)

#  perms = list(itertools.combinations(scale, 4))
#  random.shuffle(perms)

mf = pm.new_midi(title=title, tempo=tempo)
M = 4 * mf.ticks_per_beat

vibes = pm.make_vibes(mf, 1)
bass = pm.make_bass(mf, 2)
horns = pm.make_horns(mf, 3)
strings = pm.make_strings(mf, 4)

kick = pm.make_kick(mf)
snare = pm.make_snare(mf)
ride = pm.make_ride(mf)
hihat_closed = pm.make_hihat_closed(mf)

choir = pm.make_choir_swell(mf)
solo = pm.make_solo_aah(mf)
#  choir = strings

steps = np.arange(32, 96, 4)
print(f'steps: {len(steps)}')
print(steps)

chords = pm.progressions.i_vi_ii_V(root)

for cycle in range(4):
    for chord in chords:
        # bass, horn, drum loops
        # bass, drums fill on 4
        for m in range(4):
            if m == 3:
                # fill
                bass.set_note(chord[0] - 24, M/8, velocity=90)
                bass.set_note(chord[3] - 24, M/8, velocity=50)
                bass.set_note(chord[2] - 24, M/8, velocity=80)
                bass.set_note(chord[1] - 24, M/8, velocity=50)
                bass.set_note(chord[0] - 24, M/8, velocity=90)
                bass.set_note(chord[3] - 24, M/8, velocity=50)
                bass.set_note(chord[2] - 24, M/8, velocity=80)
                bass.set_note(chord[1] - 24, M/8, velocity=50)
                # swap ride and snare
                pm.funky_drummer(M, kick, ride, hihat_closed, snare )
            else:
                bass.set_note(chord[0] - 12, M/2, velocity=80)
                bass.set_note(chord[2] - 24, M/2, velocity=50)
                pm.funky_drummer(M, kick, snare, hihat_closed, ride)
            if cycle > 0:
                #  horns.set_rest(M/4)
                horns.set_note(chord[1], M/4)
                #  horns.set_rest(M/4)
                horns.set_note(chord[3], 3 * M/4)
            else:
                horns.set_rest(M)
        for val in steps:
            horns.set_volume(val, 1 * M/len(steps))
        for val in reversed(steps):
            horns.set_volume(val, 3 * M/len(steps))

        #vibes
        vibes.set_volume(steps[0], 0)
        chord = [note + 12 for note in chord]
        
        pm.add_arp_up(vibes, chord, M)
        vibes.set_notes(chord, M, velocity=70)
        vibes.set_notes(chord, M, velocity=80)
        pm.add_arp_down(vibes, chord, M)
        for val in steps:
            vibes.set_volume(val, 4 * M/len(steps))

        # strings
        if cycle > 1:
            for m in range(4):
                strings.set_notes(chord[0:m+1], M)
        else:
            strings.set_rest(4 * M)
        for val in steps:
            strings.set_volume(val, 1 * M/len(steps))
        for val in reversed(steps):
            strings.set_volume(val, 3 * M/len(steps))

        # solo
        if cycle > 2:
            solo.set_rest(M/4)
            solo.set_note(chord[0], 3 * M/4)
            solo.set_note(chord[2], 1 * M/4)
            solo.set_rest(M/4)
            solo.set_note(chord[2], 2 * M/4)
            solo.set_note(chord[1], 1 * M/4)
            solo.set_rest(M/4)
            solo.set_note(chord[0], 1 * M/4)
            solo.set_note(chord[2], 5 * M/4)
        else:
            solo.set_rest(4 * M)



filepath = pm.save_midi(mf, folder, filename)

#  subprocess.run(["timidity", filepath, "-c", "voices.cfg", '-OF'])
subprocess.run(["timidity", '-in', "-c", "~/.photon/timidity.cfg", filepath])
