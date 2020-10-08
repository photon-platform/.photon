#!/usr/bin/env bash

function plugins_actions() {

  # TODO: show all menu options on '?'
  ui_banner "PLUGINS actions: "

  read -n1  action
  case $action in
    q) clear; ;;
    @) clear; site ;;
    /) search; clear; plugins; ;;
    r) ranger; clear; plugins; ;;
    d) clear; echo; la; echo; plugins_actions; ;;
    h) clear; site; ;;
    j) cd ../pages; clear; pages; ;;
    k) cd ../themes; clear; themes; ;;
    '#')
      read -p "enter number: " number
      dir="$(dirname ${list[((number-1))]})"
      cd $dir
      clear
      plugin
      ;;
    [1-9]*)
      cd "$( dirname ${list[(($action-1))]} )"
      # read
      clear
      plugin
      ;;
    f) vf; clear; plugins;;
    g) zd; clear; plugin ;;
    G)
      tools_git
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

}
