#!/usr/bin/env bash

source ~/.photon/ui/_main.sh

title() {
  # clear -x
  echo
  ui_banner "$1"
  echo 

  echo >> $LOG
  echo >> $LOG
  echo $1 >> $LOG
  echo "=========" >> $LOG
  echo >> $LOG
}

function h1() {
  echo
  echo
  fmt="${txBold} %s${txReset}\n"
  printf "$fmt" "$1"
  echo

  echo >> $LOG
  echo $1 >> $LOG
  echo "---------" >> $LOG
}

