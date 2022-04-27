
def build_splash(session_dir, scale, tempo, tick=True, music=True):
    session_dir = os.path.abspath(session_dir)
    console.rule(session_dir)

    build_sequence(session_dir, scale, tempo, tick=tick, music=music)
    build_groups(session_dir, scale, tempo, tick=tick, music=music)

    with open(f'{session_dir}/session.lst', 'w') as lst:
        lst.write('file sequences.mp4\n')
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

