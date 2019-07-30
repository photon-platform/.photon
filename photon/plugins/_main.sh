#!/usr/bin/env bash

source ~/.photon/photon/plugins/create_submodule.sh

function pl() {
  if [ $1 ]
  then
    case $1 in

      new)
        pr
        bin/plugin photon newplugin
        ;;
      sub)
        # initialize a submodule
        if [ $2 ]
        then
          echo ""
          pl $2
          pl_sub $2
        else
          echo "format: pl sub pluginname"
        fi
        ;;

      *)
        # jump to plugin
        cd "$PLUGINS_DIR/photon-$1"
        head -n 2 blueprints.yaml
        echo
        git status -sb .
        ;;


    esac
  else
    cd $PLUGINS_DIR
    git status -sb .
  fi
}
