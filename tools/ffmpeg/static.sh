#!/usr/bin/env bash

# https://www.reddit.com/r/ffmpeg/comments/hic1vg/how_to_simulate_tv_static_using_ffmpeg_on_windows/

ffmpeg -f lavfi -i nullsrc=s=1920x1080 -filter_complex "geq=random(1)*255:128:128;aevalsrc=-2+random(0)" -t 0.5 static.mp4

