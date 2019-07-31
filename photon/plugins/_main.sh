#!/usr/bin/env bash

source ~/.photon/photon/plugins/create_submodule.sh
source ~/.photon/photon/plugins/remove_submodule.sh
source ~/.photon/photon/plugins/restore_submodule.sh

function pl() {
  if [ $1 ]
  then
    case $1 in

      new)
        pr
        bin/plugin photon newplugin
        ;;
      create)
        # initialize a submodule
        if [ $2 ]
        then
          echo ""
          pl $2
          plugin_create_submodule $2
        else
          echo "format: pl create ${yellow}pluginname"
        fi
        ;;

      restore)
        # initialize a submodule
        if [ $2 ]
        then
          echo ""
          cd "$PLUGINS_DIR"
          plugin_restore_submodule $2
        else
          echo "format: pl restore ${yellow}pluginname"
        fi
        ;;

      remove)
        # initialize a submodule
        if [ $2 ]
        then
          echo ""
          cd "$PLUGINS_DIR"
          plugin_remove_submodule $2
        else
          echo "format: pl remove ${yellow}pluginname"
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
