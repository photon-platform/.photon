import subprocess
import os as os
from rich import print, inspect
from rich.console import Console
console = Console()

from sessions.music import *
from sessions.sequences import *
from sessions.sections import *
from sessions.groups import *

import ffmpeg

root = pm.N.A3
octaves = 2
scale_type = pm.S.dorian
#  scale_type = pm.S.pentatonic_major
scale = pm.build_scale(
    root=root, 
    scale_type=scale_type, 
    octaves=octaves)


def build_session(session_dir, scale, tempo, tick=True, music=True):
    session_dir = os.path.abspath(session_dir)
    console.rule(session_dir)
    #  breakpoint()
    build_sequence(session_dir, scale, tempo, tick=tick, music=music)
    build_sections(session_dir, scale, tempo, tick=tick, music=music)
    build_groups(session_dir, scale, tempo, tick=tick, music=music)

    with open(f'{session_dir}/session.lst', 'w') as lst:
        lst.write('file sequences.mp4\n')
        lst.write('file sections.mp4\n')
        lst.write('file groups.mp4\n')

    proc = ['ffmpeg']
    proc.append('-y')
    proc.append('-hide_banner')
    proc.append('-f')
    proc.append('concat')
    proc.append('-i')
    proc.append(f'{session_dir}/session.lst')
    #  proc.append('-r')
    #  proc.append('60')
    proc.append(f'{session_dir}/session.mp4')
    subprocess.run(proc)


def build_project(project_dir, scale, tempo, tick=True, music=True):
    '''build all sessions in the project'''
    project_dir = os.path.abspath(project_dir)
    #  breakpoint()
    session_dirs = [d.path for d in os.scandir(project_dir) if d.is_dir()]
    print(session_dirs)

    for session_dir in sorted(list(session_dirs)):
        build_session(session_dir, scale, tempo, tick=tick, music=music)
