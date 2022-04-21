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

PROJECT = 'phi-midi'
NAME = 'root3'

folder = f'{PROJECT}/{NAME}'
filename = f'{NAME}.mid'
title = f'{PROJECT} - {NAME}'

bpm = 120
tempo = int(pm.bpm2tempo(bpm))


#  perms = list(itertools.combinations(scale, 4))
#  random.shuffle(perms)

#  choir = strings

steps = np.arange(32, 96, 4)
print(f'steps: {len(steps)}')
print(steps)

#  chords = pm.progressions.i_vi_ii_V(root)


