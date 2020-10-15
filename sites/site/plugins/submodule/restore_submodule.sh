#!/usr/bin/env bash

function plugin_restore_submodule() {
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
