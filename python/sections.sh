#!/usr/bin/env bash
if [[ $1 != '' ]];
then
  cd $1

  pwd

  find sections -name '*.png' | grep -v zoom | sort | sed 's/^/file /' > sections.lst
  find sections -name '*.png' | grep zoom | sort | sed 's/^/file /' >> sections.lst
  find sections -name 'all.png' | grep -v zoom | sort | sed 's/^/file /' >> sections.lst

   
  # ffmpeg -y -f concat -safe 0 -r 24 -i sections.lst -s 960x540 sections.gif
  # ffmpeg -y -f concat -safe 0 -r 24 -i sections.lst sections-large.gif
  ffmpeg -y -f concat -safe 0 -r 24 -i sections.lst sections.mp4

  # sxiv -bfa  sections.gif
  # sxiv -bfa  sections-large.gif
  mpv --fs  --keep-open=yes sections.mp4


fi
