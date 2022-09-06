#!/usr/bin/env bash


title() {
  clear -x
  ui_banner "$1"
  echo 

  echo $1 >> LOG
  echo "=========/n" >> LOG
}

function h1() {
  echo
  fmt="${txBold} %s${txReset}\n"
  printf "$fmt" "$1"
  echo

  echo $1 >> LOG
  echo >> LOG
}

