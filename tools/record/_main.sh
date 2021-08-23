#!/usr/bin/env bash

source ~/.photon/tools/record/actions.sh

alias R=tools_record
alias record=tools_record

function tools_record() {
  clear -x
  ui_header "RECORD $SEP $PWD"
  
  videos_list
  audios_list

  tools_record_actions

  tab_title "$PWD"
}

