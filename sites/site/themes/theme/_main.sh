#!/usr/bin/env bash

source ~/.photon/sites/site/themes/theme/actions.sh
source ~/.photon/sites/site/themes/theme/siblings.sh

function theme() {
  ui_header "$PROJECT * theme "
  tab_title "$PROJECT * theme "

  show_dir
  theme_siblings

  cat blueprints.yaml | head -n 12
  echo

  gsss
  theme_actions
  tab_title
}
