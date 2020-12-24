#!/usr/bin/env bash

source ~/.photon/tools/videos/actions.sh
source ~/.photon/tools/videos/list.sh
source ~/.photon/tools/videos/video/_main.sh

function videos() {
  clear -x

  ui_header "VIDEOS $SEP $PWD"

  videos_list

  videos_actions

  tab_title
}
