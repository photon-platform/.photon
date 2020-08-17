#!/usr/bin/env bash

source ~/.photon/sites/site/plugins/plugin/actions.sh
source ~/.photon/sites/site/plugins/plugin/siblings.sh

function plugin() {
  ui_banner "$PROJECT * PLUGIN "
  tab_title "$PROJECT * PLUGIN "

  show_dir
  plugin_siblings

  cat blueprints.yaml | head -n 12
  echo

  gsss
  plugin_actions
  tab_title
}
