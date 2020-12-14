#!/usr/bin/env bash

function sites_actions() {

  hr
  P=" ${fgYellow}SITES${txReset}"
  read -s -n1 -p "$P > " action
  case $action in
    \?)
      echo
      key_item q quit
      key_item / search

      key_item r ranger
      key_item t tree
      key_item d "list current dir"


      key_item "1-9" "select site"
      key_item "#" "select site"
      key_item "0" "select last site"
      key_item g "select by folder name"

      key_item n "create new site"
      key_item s "restore site from github"

      key_item I "images"
      key_item G "git tools"
      echo
      sites_actions
      ;;
    q) clear -x; ;;
    /) search; sites ;;

    n) sites_new; site ;;
    s) sites_restore; site ;;

    r) ranger;  sites ;;
    t) tre; sites; ;;
    d) ll; sites_actions ;;
    I) images; sites;;

    '#')
      read -p "enter number: " number
      if [[ ${sites[$((number - 1))]} ]]; then
        dir="$(dirname ${sites[((number-1))]})"
        if [[ -d "$dir" ]]; then
          cd "$dir"
        fi
      fi
      site
      ;;
    [1-9]*)
      if [[ ${sites[$((action - 1))]} ]]; then
        dir="$(dirname ${sites[((action-1))]})"
        if [[ -d "$dir" ]]; then
          cd "$dir"
        fi
      fi
      site
      ;;
    0)
      last=$(( ${#sites[@]} - 1 ))
      cd $(dirname ${sites[ last ]})
      site
      ;;
    g)
      echo
      dir=$(sites_dirs | sed -e "s|$SITESROOT/\(.*\)/user/.photon|\1|" | fzf )
      cd "$SITESROOT/$dir/user"
      site
      ;;
    G)
      clear
      ui_banner "git SITES"
      echo
      i=1
      for site in ${sites[@]}
      do
        dir=$(dirname "$site")
        cd $dir

        title=$(sed -n -e 's/title: \(.*\)/\1/p' "$dir/config/site.yaml")

        ui_banner  "$i $title"
        echo "   ${dir}"
        echo
        gss
        echo
        ((i++))
      done
      read -n1 -p "press any key to continue"
      sites
      ;;
    *)
      echo
      echo " '$action' ${fgRed}not a command${txReset}"
      sites_actions
      ;;
  esac
}
