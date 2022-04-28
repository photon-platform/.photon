import subprocess
import os as os
from rich import print, inspect
from rich.console import Console
console = Console()

from sessions.music import *
from sessions.sequences import *
from sessions.sections import *
from sessions.groups import *
#  from sessions.splash import *

from geometor.title import *

import ffmpeg

root = pm.N.A3
octaves = 2
scale_type = pm.S.dorian
#  scale_type = pm.S.pentatonic_major
scale = pm.build_scale(
    root=root, 
    scale_type=scale_type, 
    octaves=octaves)


def build_titles(session_dir):
    """TODO: Docstring for build_title.

    :session_dir: TODO
    :returns: TODO

    """
    #  session_dir = os.path.abspath(session_dir)
    titles_dir = os.path.join(session_dir, 'titles')
    os.makedirs(titles_dir, exist_ok=True)
    
    geometor_png = plot_title('G E O M E T O R', titles_dir, 'geometor.png')

    project_folder = os.path.basename(session_dir)
    project_png = plot_title(project_folder, titles_dir, 'project.png')
    
    with open(f'{titles_dir}/titles.lst', 'w') as lst:
        lst.write(f'file {geometor_png}\n')
        lst.write(f'duration 4.0\n')
        lst.write(f'file {project_png}\n')
        lst.write(f'duration 4.0\n')
        lst.write('\n')
    
    mp4_file = f'{titles_dir}/titles.mp4'

    proc = ['ffmpeg']
    proc.append('-y')
    proc.append('-hide_banner')
    proc.append('-f')
    proc.append('concat')
    proc.append('-safe')
    proc.append('0')
    proc.append('-i')
    proc.append(f'{titles_dir}/titles.lst')
    proc.append('-r')
    proc.append('60')
    proc.append(mp4_file)
    subprocess.run(proc)

    return mp4_file

def build_session(session_dir, scale, tempo, tick=True, music=True):
    #  session_dir = os.path.abspath(session_dir)
    console.rule(session_dir)
    #  breakpoint()
    build_sequence(session_dir, scale, tempo, tick=tick, music=music)
    build_sections(session_dir, scale, tempo, tick=tick, music=music)
    build_groups(session_dir, scale, tempo, tick=tick, music=music)

    titles_mp4 = build_titles(session_dir)

    with open(f'{session_dir}/session.lst', 'w') as lst:
        lst.write(f'file /home/phi/Sessions/splash/session.mp4\n')
        lst.write(f'file {titles_mp4}\n')
        lst.write(f'file sequences/sequences.mp4\n')
        lst.write(f'file sections/sections.mp4\n')
        lst.write(f'file groups/groups.mp4\n')

    proc = ['ffmpeg']
    proc.append('-y')
    proc.append('-hide_banner')
    proc.append('-f')
    proc.append('concat')
    proc.append('-safe')
    proc.append('0')
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
        

def build_splash(session_dir, scale, tempo, tick=True, music=True):
    session_dir = os.path.abspath(session_dir)
    console.rule(session_dir)

    build_sequence_elements(session_dir, scale, tempo, tick=tick, music=music)
    build_groups(session_dir, scale, tempo, tick=tick, music=music)

    with open(f'{session_dir}/session.lst', 'w') as lst:
        lst.write('file sequences/sequences.mp4\n')
        lst.write('file groups/groups.mp4\n')

    proc = ['ffmpeg']
    proc.append('-y')
    proc.append('-hide_banner')
    proc.append('-f')
    proc.append('concat')
    proc.append('-safe')
    proc.append('0')
    proc.append('-i')
    proc.append(f'{session_dir}/session.lst')
    #  proc.append('-r')
    #  proc.append('60')
    proc.append(f'{session_dir}/session.mp4')
    subprocess.run(proc)

