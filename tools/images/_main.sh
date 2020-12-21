#!/usr/bin/env bash

source ~/.photon/tools/images/actions.sh
source ~/.photon/tools/images/list.sh
source ~/.photon/tools/images/convert.sh
source ~/.photon/tools/images/image/_main.sh
source ~/.photon/tools/images/exif/_main.sh

alias I=images
function images() {
  clear -x

  ui_header "IMAGES $SEP $PWD"

  images_list

  images_actions

  tab_title
}
