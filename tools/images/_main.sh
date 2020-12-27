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

  folder_siblings
  h2 "$(( siblings_index + 1 )) ${fgg08}of${txReset} $siblings_count"
  show_dir

  images_list

  images_actions

  tab_title
}
