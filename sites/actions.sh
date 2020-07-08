#!/usr/bin/env bash

function sites_actions() {

  ui_banner "SITES actions [?] for help "

  read -n1  action
  case $action in
    \?)
      echo
      h2 "q - quit"
      h2 "f - find from current directory"
      h2 "r - ranger"
      echo
      sites_actions
      ;;
    q)
      clear
      echo "exiting SITES"
      echo "type "sites" to reeneter"
      ;;
    f)
      find_from_dir
      ;;
    r)
      ranger
      sites_actions
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
      dir="$(dirname ${sites[((action-1))]})"
      echo
      echo $dir
      cd $dir
      pwd
      # read -n1 -p "any key to continue..."
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
