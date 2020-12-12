#!/usr/bin/env bash

source ~/.photon/tools/images/actions.sh
source ~/.photon/tools/images/list.sh
source ~/.photon/tools/images/convert.sh
source ~/.photon/tools/images/image/_main.sh

function images() {
  clear

  ui_header "photon * IMAGES"
  tab_title "photon * IMAGES"

  show_dir

  images_list

  images_actions

  tab_title
}
