#!/usr/bin/env bash

function swatch() {

  clear
  ui_header "$PROJECT * SWATCH "
  tab_title "$PROJECT * SWATCH "

  show_dir
  h2 "start time: $( date )"
  echo

  sass --watch $(swatch_dirs)
}

function swatch_dirs() {

  find $PROJECT_DIR/user/plugins -maxdepth 2 -type d -wholename *photon*/scss \
    | sed 's|/scss||' \
    | sed 's|\(.*\)|\1/scss:\1/assets|' \
    | sed 's|\n||'

  find $PROJECT_DIR/user/themes -maxdepth 2 -type d -wholename *photon*/scss  \
    | sed 's|/scss||' \
    | sed 's|\(.*\)|\1/scss:\1/css|' \
    | sed 's|\n||'
}
