#!/usr/bin/env bash

source ~/.photon/tools/audios/actions.sh
source ~/.photon/tools/audios/list.sh
source ~/.photon/tools/audios/audio/_main.sh

function audios() {
  clear -x

  ui_header "AUDIOS $SEP $PWD"

  folder_siblings
  h2 "$(( siblings_index + 1 )) ${fgg08}of${txReset} $siblings_count"
  show_dir

  audios_list

  audios_actions

  tab_title
}
