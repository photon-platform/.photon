#!/usr/bin/env bash

cd $1

source ~/.bashrc

timidity sequence.mid -Ov -c ~/.photon/timidity.cfg

ffmpeg -y -f concat -i sequence.txt -i sequence.ogg -r 60 sequence.mp4

mpv sequence.mp4 --keep-open=yes --fs
