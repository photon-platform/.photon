#!/usr/bin/bash


sty_banner="${bgYellow}${fgBlack}"
fmt_banner="${sty_banner} %-*s${txReset}\n"

sty_child="${fgYellow}"
fmt_child="${sty_child}%3d)${txReset} %s${fgAqua}%s${txReset}\n"
fmt_child2="     %s\n"

function ui_banner() {
  width=$(tput cols)
  printf "$fmt_banner" $((width - 1)) "$1"
  echo
}

function ui_list_item() {
  printf "$fmt_child2" "$1"
}

function ui_list_item_number() {
  printf "$fmt_child" $1 "$2"
}

function ui_display_numbered_list() {
  echo
}
