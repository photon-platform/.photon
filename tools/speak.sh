#!/usr/bin/env bash

function speak() {
  espeak -v mb-en1 -s 150  "$*" 

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
