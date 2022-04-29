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


def get_summary(folder):
    # sequences
    d = folder + '/sequences'
    pngs = [f.path for f in os.scandir(d) if 'png' in f.path]
    pngs = list(sorted(pngs))
    pngs = [f for f in pngs if 'summary' not in f]

    files = [f for f in pngs if 'zoom' not in f]

    lines = [f for f in files if 'line' in f]
    circles = [f for f in files if 'circle' in f]
    points = [f for f in files if 'point' in f]
    polygons = [f for f in files if 'polygon' in f]

    summary = {}
    summary['lines'] = len(lines)
    summary['circles'] = len(circles)
    summary['points'] = len(points)
    summary['polygons'] = len(polygons)
    summary['total'] = len(files)

    return summary


def get_summary_golden(folder):
    # sections
    d = folder + '/sections'
    pngs = [f.path for f in os.scandir(d) if 'png' in f.path]
    pngs = [f for f in pngs if 'summary' not in f]
    files = [f for f in pngs if 'zoom' not in f]

    summary = {}
    summary['sections'] = len(files)
    
    # grousp
    d = folder + '/groups'
    pngs = [f.path for f in os.scandir(d) if 'png' in f.path]
    pngs = [f for f in pngs if 'summary' not in f]

    files = [f for f in pngs if 'zoom' not in f]
    summary['groups'] = len(files)

    return summary



def build_titles_music(num_images, folder):
    """TODO: Docstring for build_titles_music.

    :arg1: TODO
    :returns: TODO

    """
    bpm = 120
    tempo = int(pm.bpm2tempo(bpm))

    mf = pm.new_midi(title='title', tempo=tempo)
    M = 4 * mf.ticks_per_beat
    beat = mf.ticks_per_beat

    kick = pm.make_kick(mf)
    tick = pm.make_tick(mf)
    tick.set_volume(30, 0)
    kick.set_volume(90, 0)

    img_beats = 4
    dur = img_beats * beat

    for _ in range(num_images):
        kick.set_hit(dur, velocity=100)
        tick.set_hits(dur, 4)

    midi_path = f'{folder}/titles.mid'
    mf.save(midi_path)

    proc = ['timidity', '-c', '~/.photon/timidity.cfg', ]
    proc.append('-Ov')
    proc.append(midi_path)
    subprocess.run(proc)

    return f'{folder}/titles.ogg'

def build_titles(session_dir):
    """TODO: Docstring for build_title.

    :session_dir: TODO
    :returns: TODO

    """
    session_dir = os.path.abspath(session_dir)
    titles_dir = os.path.join(session_dir, 'titles')
    os.makedirs(titles_dir, exist_ok=True)

    geometor_png = plot_title('G E O M E T O R', titles_dir, 'geometor.png')

    project_folder = os.path.basename(session_dir)
    project_png = plot_title(project_folder, titles_dir, 'project.png')

    summary = get_summary(session_dir)
    seq_summary = ''
    for key, val in summary.items():
        seq_summary += f'{key} • {val}\n'

    summary_png  = plot_title(seq_summary, titles_dir, 'seq_summary.png')
    
    summary = get_summary_golden(session_dir)
    golden_summary = ''
    for key, val in summary.items():
        golden_summary += f'{key} • {val}\n'

    golden_summary_png  = plot_title(golden_summary, titles_dir, 'golden_summary.png')
    
    num_images = 6
    titles_ogg = build_titles_music(num_images, titles_dir)

    secs = 2

    with open(f'{titles_dir}/titles.lst', 'w') as lst:
        lst.write(f'file {geometor_png}\n')
        lst.write(f'duration { float(secs) }\n')

        lst.write(f'file {project_png}\n')
        lst.write(f'duration { float(secs) }\n')

        lst.write(f'file {summary_png}\n')
        lst.write(f'duration { float(secs) }\n')

        file = session_dir + "/sequences/summary.png"
        lst.write(f'file {file}\n')
        lst.write(f'duration { float(secs) }\n')

        lst.write(f'file {golden_summary_png}\n')
        lst.write(f'duration { float(secs) }\n')

        file = session_dir + "/sections/summary.png"
        lst.write(f'file {file}\n')
        lst.write(f'duration { float(secs) }\n')

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
    proc.append('-i')
    proc.append(f'{titles_dir}/titles.ogg')
    proc.append('-t')
    proc.append(f'{num_images * secs}')
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

