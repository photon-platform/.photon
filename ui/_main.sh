#!/usr/bin/bash

source ~/.photon/ui/color.sh
source ~/.photon/ui/ask.sh

SEP="${fgg08}•${txReset}"

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
  # width=$(tput cols)
  # width=$((width - 2))
  width=3
  char="━"
  # char="─"
  
  # sty="${fgYellow}"
  sty="${fgg08}"
  fmt="${sty} %-${width}s${txReset} \n"
  printf -v spaces "%-${width}s"
  printf "$fmt" "${spaces// /${char}}"
}

function hr_prompt() {
  width=$(tput cols)
  width=$((width / 2 - 4))
  char="─"
  
  printf -v spaces "%-${width}s"

  fmt=" %s "
  printf "$fmt" "${spaces// /${char}}"
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
  printf "       %s${txReset}\n" "$1"
}

function ui_list_item_number() {
  fmt="${fgYellow}%4d${txReset} ${SEP} ${txBold}%s${fgAqua}%s${txReset}\n"
  printf "$fmt" "$1" "$2"
}

function key_item() {
  fmt="${fgYellow}%6s${txReset} ${SEP} %s\n"
  printf "$fmt" "$1" "$2"
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
