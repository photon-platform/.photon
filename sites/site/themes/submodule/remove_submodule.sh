#!/usr/bin/env bash

# function theme_remove_submodule() {

# #  based on https://gist.github.com/myusuf3/7f645819ded92bda6677



  # D=$(date +"%Y%m%d-%T")
  # cd $PROJECT_DIR/user

  # echo
  # echo "*** Delete photon-${1} from the .gitmodules file"
  # sed -i.$D.bak -e "/photon-${1}/d" .gitmodules
  # # TODO: use git submodules deinit -f plugins/photon-$1
  # # instead of sed

  # echo
  # echo "*** Stage the .gitmodules changes"
  # git add .gitmodules

  # # Delete the relevant section from .git/config.
  # echo
  # echo "*** Delete photon-${1} from .git/config"
  # sed -i.$D.bak -e "/photon-${1}/d" .git/config

  # # Run git rm --cached path_to_submodule (no trailing slash).
  # echo
  # echo "*** git rm --cached $PLUGINS_DIR/photon-${1}"
  # git rm --cached "$PLUGINS_DIR/photon-${1}"

  # # Run rm -rf .git/modules/path_to_submodule (no trailing slash).
  # echo
  # echo "*** rm -rf .git/modules/photon-${1}"
  # rm -rf ".git/modules/photon-${1}"

  # # Commit git commit -m "Removed submodule "
  # echo
  # echo "*** commit"
  # git commit -m "Removed submodule "

  # echo
  # echo "*** rm -rf $PLUGINS_DIR/photon-${1}"
  # rm -rf "$PLUGINS_DIR/photon-${1}"

  # echo
  # echo "*** git gc --aggressive --prune=all"
  # git gc --aggressive --prune=all

# }
