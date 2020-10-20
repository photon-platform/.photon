#!/usr/bin/env bash


#  based on https://gist.github.com/myusuf3/7f645819ded92bda6677
function plugin_remove_submodule() {

  ui_banner "REMOVE plugin submodule"

  if [[ $1 ]]; then
    name=$1
  else
    read -p "enter plugin name : " name
  fi

  if [ -d "$PLUGINS_DIR/${name}" ]
  then

    D=$(date +"%Y%m%d-%T")
    cd $PROJECT_DIR/user

    echo
    echo "*** Delete ${name} from the .gitmodules file"
    sed -i.$D.bak -e "/${name}/d" .gitmodules
    # TODO: use git submodules deinit -f plugins/$1
    # instead of sed

    echo
    echo "*** Stage the .gitmodules changes"
    git add .gitmodules

    # Delete the relevant section from .git/config.
    echo
    echo "*** Delete ${name} from .git/config"
    sed -i.$D.bak -e "/${name}/d" .git/config

    # Run git rm --cached path_to_submodule (no trailing slash).
    echo
    echo "*** git rm --cached $PLUGINS_DIR/${name}"
    git rm --cached "$PLUGINS_DIR/${name}"

    # Run rm -rf .git/modules/path_to_submodule (no trailing slash).
    echo
    echo "*** rm -rf .git/modules/${name}"
    rm -rf ".git/modules/${name}"

    # Commit git commit -m "Removed submodule "
    echo
    echo "*** commit"
    git commit -m "Removed submodule "

    echo
    echo "*** rm -rf $PLUGINS_DIR/${name}"
    rm -rf "$PLUGINS_DIR/${name}"

    echo
    echo "*** git gc --aggressive --prune=all"
    git gc --aggressive --prune=all

  fi
}
