#!/usr/bin/env bash

source ~/.photon/sites/site/themes/list.sh
source ~/.photon/sites/site/themes/actions.sh
source ~/.photon/sites/site/themes/theme/_main.sh

function themes() {
  @
  source .photon
  cd themes
  clear -x

  ui_header "THEMES $SEP $PROJECT"

  show_dir

  themes_list

  themes_actions

  tab_title
}
