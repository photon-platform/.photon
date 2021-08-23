#!/usr/bin/env bash

source ~/.photon/tools/videos/actions.sh
source ~/.photon/tools/videos/list.sh
source ~/.photon/tools/videos/video/_main.sh

alias V=videos
function videos() {
  clear -x

  ui_header "VIDEOS $SEP $PWD"

  folder_siblings
  h2 "$(( siblings_index + 1 )) ${fgg08}of${txReset} $siblings_count"
  show_dir

  videos_list

  videos_actions

  tab_title
}
