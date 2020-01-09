#!/usr/bin/env bash

source ~/.photon/photon/plugins/create_submodule.sh
source ~/.photon/photon/plugins/remove_submodule.sh
source ~/.photon/photon/plugins/restore_submodule.sh

function display_plugins_list() {
  plugins=$(find . \
    -maxdepth 1 \
    -mindepth 1 \
    -not -path "./LOGS" \
    -not -path "./grav" \
    -type d \
    | sort)

  i=1
  dirs=()

  ui_banner "plugins:"

  for plugin in $plugins
  do
    filename=$(basename -- "$plugin")
    extension="${filename##*.}"
    filename="${filename%.*}"
    dir=$(dirname "$plugin")
    dirs+=( $dir )

    # gscount=$(git status -sb $dir | wc -l)
    ((gscount--))

    if (( gscount > 0 ));
    then
      gscount=" [$gscount]"
    else
      gscount=""
      fi

    # echo -e "$i\t$title $gscount"
    ui_list_item_number $i "$plugin"
    ((i++))
  done
  echo
}
function pl() {
  cd $PLUGINS_DIR
  clear
  ui_banner PLUGINS
  echo

  display_plugins_list

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
