#!/usr/bin/env bash

function speak() {
  # espeak -v mb-en1 -s 150 -m "$*" 
  espeak -s 150 -m "$*" 
}

function speak_wav() {
  text="$*"
  slug=$( slugify "$text" )
  espeak -v mb-en1 -s 150 -w "$slug.wav"  "$*" 
  echo $slug.wav
}

function now() {
  speak "$(date "+%A, %B %e, %I:%M %p")"
}

function speak_file() {
  while read line 
  do 
      speak "$line" 
  done < $1
}
