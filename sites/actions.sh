#!/usr/bin/env bash

function sites_actions() {

  ui_footer "SITES actions: ? for help "

  read -s -n1 -p " > " action
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
    q) clear; ;;
    /) search; clear; sites ;;

    n) clear; sites_new; clear; site ;;
    s) clear; sites_restore; clear; site ;;

    r) ranger; clear; sites ;;
    t) tre; clear; sites; ;;
    d) ll; echo; sites_actions ;;
    I) images; clear; sites;;

    '#')
      read -p "enter number: " number
      if [[ ${sites[$((number - 1))]} ]]; then
        dir="$(dirname ${sites[((number-1))]})"
        if [[ -d "$dir" ]]; then
          cd "$dir"
        fi
      fi
      clear
      site
      ;;
    [1-9]*)
      if [[ ${sites[$((action - 1))]} ]]; then
        dir="$(dirname ${sites[((action-1))]})"
        if [[ -d "$dir" ]]; then
          cd "$dir"
        fi
      fi
      clear
      site
      ;;
    0)
      last=$(( ${#sites[@]} - 1 ))
      cd $(dirname ${sites[ last ]})
      clear
      site
      ;;
    g)
      echo
      dir=$(sites_dirs | sed -e "s|$SITESROOT/\(.*\)/user/.photon|\1|" | fzf )
      cd "$SITESROOT/$dir/user"
      # read -p continue
      clear
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
      clear
      sites
      ;;
    *)
      echo
      echo "not a command"
      sites_actions
      ;;
  esac

    case $1 in
      newhost)
        ~/.photon/sites/newhost.sh "$2" "$3"
        cd $SITESROOT/$2/user
        ;;
      archive)
        cd $SITESROOT
        if [[ $2 ]]; then
          D=$(date +"%Y%m%d-%T")
          cp -a "$2" .archive/$2.$D
          ls .archive | grep $2
        else
          echo "specify valid site: sites archive sitename"
          ls
        fi
        ;;
    esac


}
