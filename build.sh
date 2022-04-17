#!/usr/bin/env bash

cd $1

source ~/.bashrc

timidity *.mid -Ov 

ffmpeg -y -f concat -i sequence.txt -i sequence.ogg -r 60 sequence.mp4

mpv build.mp4 --keep-open=yes --fs
