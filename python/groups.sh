#!/usr/bin/env bash
if [[ $1 != '' ]];
then
  cd $1

  pwd

  find sequences -name '00000.png' | grep -v zoom | sort --reverse | sed 's/^/file /' > groups.lst
  find groups -name '*.png' | grep -v zoom | sort --reverse | sed 's/^/file /' >> groups.lst
  find sections -name 'all.png' | grep -v zoom | sort --reverse | sed 's/^/file /' >> groups.lst
   
  # ffmpeg -y -f concat -safe 0 -r 24 -i groups.lst -s 960x540 groups.gif
  # ffmpeg -y -f concat -safe 0 -r 24 -i groups.lst group-large.gif
  ffmpeg -y -f concat -safe 0 -r 24 -i groups.lst groups.mp4

  # sxiv -bfa  groups.gif
  # sxiv -bfa  group-large.gif
  mpv --fs  --keep-open=yes groups.mp4
fi
