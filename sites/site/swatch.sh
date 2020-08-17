#!/usr/bin/env bash

function swatch() {
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
