#!/usr/bin/env bash

source ~/.photon/sites/site/plugins/plugin/actions.sh
source ~/.photon/sites/site/plugins/plugin/siblings.sh

function plugin() {
  ui_banner "$PROJECT * PLUGIN "

  show_dir
  plugin_siblings

  gsss
  plugin_actions
}
