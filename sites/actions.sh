#!/usr/bin/env bash

function sites_actions() {

  ui_footer "SITES actions: h j k [le] # g G r d q n s ? "

  read -s -n1  action
  case $action in
    \?)
      echo
      h2 "q - quit"
      h2 "f - find from current directory"
      h2 "r - ranger"
      echo
      sites_actions
      ;;
    q) clear; ;;
    # @) clear; home ;;
    /) search; clear; sites ;;
    r) ranger; sites_actions ;;
    d) clear; echo; ls -hA; echo; sites_actions ;;
    h) cd ..; clear; la; ;;
    j) sites; ;;
    k) sites; ;;
    '#')
      read -p "enter number: " number
      dir="$(dirname ${sites[((number-1))]})"
      cd $dir
      clear
      site
      ;;
    [1-9]*)
      dir="$(dirname ${sites[((action-1))]})"
      cd $dir
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
    n)
      clear
      sites_new
      clear
      site
      ;;
    s)
      clear
      sites_restore
      # clear
      site
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
