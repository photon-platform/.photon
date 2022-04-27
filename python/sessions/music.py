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

def set_volume_envelope_reverse(inst, dur):
    b = dur/ 32
    #  dur_in = dur / 8
    #  dur_out = 7 * dur / 8
    #  steps = np.arange(32, 96, 4)
    #  for val in steps:
    val = 32
    for _ in range(24):
        inst.set_volume(val, b)
        val += 2
    for _ in range(8):
        inst.set_volume(val, b)
        val -= 6

