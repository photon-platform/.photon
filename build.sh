#!/usr/bin/env bash

cd $1

source ~/.bashrc

timidity *.mid -Ov -c ~/.photon/timidity.cfg

ffmpeg -y -f concat -i sequence.txt -i dorian-144-$1.ogg -r 60 build.mp4

mpv build.mp4 --keep-open=yes
