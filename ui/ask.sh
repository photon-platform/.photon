#!/usr/bin/env bash

LABEL_WIDTH=15
function get_label() {
  printf "${fgYellow}%*s: ${txReset}" $LABEL_WIDTH "$1"
}

function ask_value() {
  label=$(get_label "$1")
  default="${2#null}"
  read -p "$label" -e -i "$default"
  echo "$REPLY"
}

function ask_date() {
  label=$(get_label "$1")
  read -p "$label" -i $(date +%m/%d/%Y) -e startDate
  echo "$startDate"
}

function ask_truefalse() {
  label=$(get_label "$1 [y/n]")
  read -n1 -p "${label}"
  case $REPLY in
    y)
      echo "true"
      ;;
    *)
      echo "false"
      ;;
  esac
}

