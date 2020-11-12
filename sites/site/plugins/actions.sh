#!/usr/bin/env bash

function plugins_actions() {

  # TODO: show all menu options on '?'
  ui_footer "PLUGINS actions: "

  read -s -n1  action
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
    c) plugin_create_submodule ;;
    b) plugin_restore ;;
    remove) plugin_remove_submodule ;;
    *)
      clear
      plugins
      ;;
  esac

}
