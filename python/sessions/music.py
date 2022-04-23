import os
import sys
pm_path = os.path.expanduser('~/Projects/phi-midi')
sys.path.append(pm_path)

import phimidi as pm
import math as math
import subprocess as subprocess
import numpy as np
import itertools as itertools
import random as random

def build_band(mf):
    bass = pm.make_bass(mf, 1)
    vibes = pm.make_vibes(mf, 2)
    horns = pm.make_horns(mf, 3)
    strings = pm.make_strings(mf, 4)

    kick = pm.make_kick(mf)
    #  snare = pm.make_snare(mf)
    ride = pm.make_ride(mf)
    #  hihat_closed = pm.make_hihat_closed(mf)

    #  choir = pm.make_choir_swell(mf)
    #  solo = pm.make_solo_aah(mf)
    return bass, vibes, horns, strings, kick, ride

#  PROJECT = 'phi-midi'
#  NAME = 'root3'

#  folder = f'{PROJECT}/{NAME}'
#  filename = f'{NAME}.mid'
#  title = f'{PROJECT} - {NAME}'



#  perms = list(itertools.combinations(scale, 4))
#  random.shuffle(perms)

#  choir = strings

#  print(f'steps: {len(steps)}')
#  print(steps)

#  chords = pm.progressions.i_vi_ii_V(root)


