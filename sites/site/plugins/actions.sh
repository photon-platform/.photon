#!/usr/bin/env bash

function plugins_actions() {

  # TODO: show all menu options on '?'
  ui_banner "PLUGINS actions: "

  read -n1  action
  case $action in
    q)
      clear
      echo "exiting PLUGINS"
      echo "type "plugins" to reeneter"
      ;;
    f)
      find_from_dir
      clear
      plugins
      ;;
    r)
      ranger
      clear
      plugins
      ;;
    d)
      clear
      echo
      la
      echo
      plugins_actions
      ;;
    h)
      # nav up
      clear
      site
      ;;
    j)
      cd ../pages
      clear
      pages
      ;;
    k)
      cd ../pages
      clear
      pages
      ;;
    [1-9]*)
      cd "$( dirname ${list[(($action-1))]} )"
      # read
      clear
      plugin
      ;;
    g)
      echo
      # read -p "Enter child number: " -e num
      # cd "${dirs[(($num-1))]}"
      zd
      clear
      plugin
      ;;
    G)
      clear
      echo
      gss
      read -p "Add and commit this branch [y]:  " -e commit
      if [[ $commit == "y" ]]; then
        gacp
        echo
        read -p "press any key to continue"
      fi
      clear
      plugins
      ;;
    n)
      # new plugin from template
      pr
      bin/plugin photon newplugin
      ;;
    c)
      # create submodule
      # TODO this is a function for the plugin modul
        if [ $2 ]
        then
          echo ""
          pl $2
          plugin_create_submodule $2
        else
          echo "format: pl create ${yellow}pluginname"
        fi
      ;;
    b)
      # restore submodule
      # TODO this is a function for the plugin modul
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
      clear
      plugins
      ;;
  esac

  if [ $1 ]
  then
    case $1 in

      new)
        ;;

      create)
        ;;

      restore)
        # initialize a submodule
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
