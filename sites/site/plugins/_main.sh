#!/usr/bin/env bash

source ~/.photon/sites/site/plugins/list.sh
source ~/.photon/sites/site/plugins/actions.sh
source ~/.photon/sites/site/plugins/plugin/_main.sh
# source ~/.photon/sites/site/plugins/submodule/create_submodule.sh
# source ~/.photon/sites/site/plugins/submodule/remove_submodule.sh

function plugins() {
  @
  source .photon
  cd plugins

  clear
  ui_banner "$PROJECT * PLUGINS"
  tab_title "$PROJECT * PLUGINS"
  show_dir

  gsss

  plugins_list

  plugins_actions
  tab_title

}

function plugin_restore() {
  ui_banner "restore plugin submodule"

  if [[ $1 ]]; then
    name=$1
  else
    read -p "enter plugin name (without photon-): " name
  fi

  echo
  echo "*** add repo as submodule"
  git submodule add --force https://github.com/photon-platform/grav-plugin-photon-$name.git photon-$name

  echo
  echo "*** update submodules within submodule"
  git submodule update --init --recursive

  echo
  echo "*** push to repo"

  git add .
  git commit -m "add submodule plugin: photon-$name"
  git push -fu origin master

  # git gc --aggressive --prune=all
}
