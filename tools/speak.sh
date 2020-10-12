#!/usr/bin/env bash

function speak() {
  espeak -v mb-en1  -k44 "$1" 

}

function now() {
  
  speak "$(date "+%A, %B %e, %I:%M %p")"
}
