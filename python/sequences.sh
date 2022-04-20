#!/usr/bin/env bash
if [[ $1 != '' ]];
then
  cd $1

  pwd

  find sequences -name '*.png' | grep -v zoom | sort | sed 's/^/file /' > sequences.lst
  find sequences -name '00000.png' | grep -v zoom | sort | sed 's/^/file /' >> sequences.lst

  cat sequences.lst
   
  # ffmpeg -y -f concat -safe 0 -r 24 -i sequences.lst -s 960x540 sequences.gif
  # ffmpeg -y -f concat -safe 0 -r 24 -i sequences.lst sequences-large.gif
  ffmpeg -y -f concat -safe 0 -r 24 -i sequences.lst sequences.mp4

  # sxiv -bfa  sequences.gif
  find sequences -name '*.png' | grep zoom | sort | sed 's/^/file /' > sequences.lst
  find sequences -name '00000.png' | grep -v zoom | sort | sed 's/^/file /' >> sequences.lst

  ffmpeg -y -f concat -safe 0 -r 24 -i sequences.lst sequences-zoom.mp4

  # sxiv -bfa  sequences-large.gif
  mpv --fs  --keep-open=yes sequences.mp4
fi
