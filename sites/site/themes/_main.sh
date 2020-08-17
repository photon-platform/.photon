#!/usr/bin/env bash

source ~/.photon/sites/site/themes/list.sh
source ~/.photon/sites/site/themes/actions.sh
source ~/.photon/sites/site/themes/theme/_main.sh
source ~/.photon/sites/site/themes/submodule/create_submodule.sh
source ~/.photon/sites/site/themes/submodule/remove_submodule.sh
source ~/.photon/sites/site/themes/submodule/restore_submodule.sh

function themes() {
  @
  source .photon
  cd themes

  clear
  ui_banner "$PROJECT * THEMES"
  tab_title "$PROJECT * THEMES"

  show_dir

  gsss

  themes_list

  themes_actions

  tab_title
}
