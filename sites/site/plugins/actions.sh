#!/usr/bin/env bash

function plugins_actions() {

  hr
  P=" ${fgYellow}PLUGINS${txReset}"
  read -s -n1 -p "$P > " action
  case $action in
    q) clear; ;;
    @) clear; site ;;
    /) search; clear; plugins; ;;

    r) ranger; clear; plugins; ;;
    t) tre; clear; plugins; ;;
    d) ll; echo; plugins_actions; ;;
    I) images; ;;

    h) clear; site; ;;
    j) cd ../pages; clear; pages; ;;
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
