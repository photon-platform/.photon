#!/usr/bin/env bash

function plugin_restore_submodule() {

  echo
  echo "*** add repo as submodule"
  git submodule add --force https://github.com/photon-platform/grav-plugin-photon-$1.git photon-$1

  echo
  echo "*** update submodules within submodule"
  git submodule update --init --recursive

  echo
  echo "*** push to repo"

  git add .
  git commit -m "add submodule plugin: photon-$1"
  git push -fu origin master

  # git gc --aggressive --prune=all
}
