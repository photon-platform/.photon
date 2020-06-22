#!/usr/bin/bash




function ui_banner() {
  width=$(tput cols)
  sty="${bgYellow}${black}"
  fmt="${sty} %-*s${txReset}\n"
  printf "$fmt" $((width - 1)) "$1"
  echo
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
