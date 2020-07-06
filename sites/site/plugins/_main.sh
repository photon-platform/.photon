#!/usr/bin/env bash

source ~/.photon/sites/site/plugins/list.sh
source ~/.photon/sites/site/plugins/actions.sh
source ~/.photon/sites/site/plugins/plugin/_main.sh
source ~/.photon/sites/site/plugins/submodule/create_submodule.sh
source ~/.photon/sites/site/plugins/submodule/remove_submodule.sh
source ~/.photon/sites/site/plugins/submodule/restore_submodule.sh

function plugins() {
  @
  source .photon
  cd $PROJECT_DIR/user/plugins

  clear
  ui_banner "$PROJECT * PLUGINS"

  h1 "plugins root"
  echo

  plugins_list

  plugins_actions

}

