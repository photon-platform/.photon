#!/usr/bin/env bash

source ~/.photon/sites/site/plugins/plugin/actions.sh
source ~/.photon/sites/site/plugins/plugin/siblings.sh

function plugin() {
  clear -x

  ui_header "PLUGINS $SEP $PROJECT"

  show_dir
  plugin_siblings

  cat blueprints.yaml | head -n 12 | awk '{printf "  %s\n", $0}'
  # | xargs printf "    %s"
  echo

  plugin_actions
  tab_title
}
