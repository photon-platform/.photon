#!/usr/bin/env bash

source ~/.photon/sites/site/themes/theme/actions.sh
source ~/.photon/sites/site/themes/theme/siblings.sh

function theme() {
  clear -x
  
  ui_header "THEME $SEP $PROJECT"

  show_dir
  theme_siblings

  cat blueprints.yaml | head -n 12
  echo

  theme_actions
  tab_title
}
