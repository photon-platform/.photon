#!/usr/bin/env bash

function images_screen() {
  if [[ $1 ]]; then
    convert $1 -gravity Center -crop 1920x1080+0+0 +repage $1.screen.png
  else
    echo "Specify file to convert"
  fi
}
alias iscr=images_screen

function images_square() {
  if [[ $1 ]]; then
    convert $1 -gravity Center -crop 1000x1000+0+0 +repage $1.square.png
  else
    echo "Specify file to convert"
  fi
}
alias isqr=images_square

function images_ico() {
  if [[ $1 ]]; then
    convert $1 -define icon:auto-resize=64,48,32,16 favicon.ico
  else
    echo "Specify file to convert"
  fi
}
alias iico=images_ico
