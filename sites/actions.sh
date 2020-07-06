#!/usr/bin/env bash

function sites_actions() {

  ui_banner "SITES actions: "

  read -n1  action
  case $action in
    q)
      clear
      echo "exiting SITES"
      echo "type "sites" to reeneter"
      ;;
    f)
      find_from_dir
      ;;
    d)
      clear
      echo
      ls -hA
      echo
      sites_actions
      ;;
    h)
      cd ..
      clear
      la
      ;;
    j)
      sites
      ;;
    k)
      sites
      ;;
    [1-9]*)
      # dirs=($(sites_dirs))
      cd "$(dirname ${sites[((action-1))]})"
      clear
      site
      ;;
    g)
      echo
      dir=$(sites_dirs | sed -e "s|$SITESROOT/\(.*\)/user|\1|" | fzf )
      cd "$SITESROOT/$dir/user"
      clear
      site
      ;;
    G)
      clear
      echo
      gss
      read -p "press any key to continue"
      clear
      sites
      ;;
    n)
      clear
      sites_new
      clear
      site
      ;;
    r)
      clear
      sites_restore
      # clear
      site
      ;;
    *)
      clear
      pages
      ;;
  esac

    case $1 in
      newhost)
        ~/.photon/sites/newhost.sh "$2" "$3"
        cd $SITESROOT/$2/user
        ;;
      status)
        cd $SITESROOT
        find . -maxdepth 1 -mindepth 1 \
          ! -name "LOGS" \
          ! -name ".archive" \
          ! -name ".backup" \
          ! -name "grav" \
          -type d \
          -exec sh -c '(echo {} && \
            cd {}/user && \
            sed -n "s/^\(\s*title:\s*\)\(.*\)/\2/p" config/site.yaml && \
            git status -sb && \
            echo)' \;
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
