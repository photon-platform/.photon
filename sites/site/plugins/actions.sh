#!/usr/bin/env bash

function plugins_actions() {

  echo
  hr
  P=" ${fgYellow}PLUGINS${txReset}"
  read -s -n1 -p "$P > " action
  case $action in
    q) clear -x; ;;
    @) site ;;
    /) search; plugins; ;;

    r) ranger_dir; folder; ;;
    t) tre; plugins; ;;
    d) ll; plugins_actions; ;;
    I) images; ;;

    g) zd; folder ;;
    h) site; ;;
    j) cd ../pages; pages; ;;
    '#')
      read -p "enter number: " number
      dir="$(dirname ${list[((number-1))]})"
      cd $dir
      plugin
      ;;
    [1-9]*)
      cd "$( dirname ${list[(($action-1))]} )"
      # read
      plugin
      ;;

    f) vf; plugins;;
    v) vr; pages; ;;

    F) folder; ;;
    I) images; ;;
    G)
      tools_git
      plugins
      ;;
    n)
      # new plugin from template
      pr
      bin/plugin photon newplugin
      ;;
    c) plugin_create_submodule ;;
    b) plugin_restore;  ;;
    remove) plugin_remove_submodule ;;
    *)
      plugins
      ;;
  esac

}
