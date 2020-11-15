#!/usr/bin/bash

source ~/.photon/ui/color.sh
source ~/.photon/ui/ask.sh

fmt_child="${fgYellow}%3d)${txReset} %s${fgAqua}%s${txReset}\n"
fmt_child2="     %s\n"

function h1() {
  fmt="${txBold} %s${txReset}\n"
  printf "$fmt" "$1"
}

function h2() {
  fmt=" %s${txReset}\n"
  printf "$fmt" "$1"
}

function hr() {
  width=$(tput cols)
  width=$((width - 2))
  sty="${txBold}${fgYellow}"
  fmt="${sty} %-${width}s${txReset} \n"
  printf -v spaces "%-${width}s"
  printf "$fmt" "${spaces// /━}"
}

function ui_header() {
  hr
  ui_banner "$1"
  hr
  echo
}

function ui_footer() {
  hr
  ui_banner "$1"
}

function ui_banner() {
  width=$(tput cols)
  width=$((width - 2))
  sty="${txBold}${fgYellow}"
  fmt="${sty} %-${width}s${txReset} \n"
  printf "$fmt" "$1"
}

function ui_list_item() {
  printf "     %s${txReset}\n" "$1"
}

function ui_list_item_number() {
  fmt="${fgYellow}%3d)${txReset} ${txBold}%s${fgAqua}%s${txReset}\n"
  printf "$fmt" $1 "$2"
}

function ui_display_numbered_list() {
  echo
}

function tab_title {
  if [ -z "$1" ]
  then
    title=${PWD} # current directory
  else
    title=$1 # first param
  fi
  echo -n -e "\033]0;$title\007"
}
