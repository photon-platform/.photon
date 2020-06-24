#!/usr/bin/env bash

export SITESROOT=~/SITES
export ISLOCAL=true
if [[ "$HOSTNAME" =~ .*com$ ]]
then
  export SITESROOT=~
  export ISLOCAL=false
fi

source ~/.photon/sites/_aliases.sh
source ~/.photon/sites/list.sh
source ~/.photon/sites/new.sh
source ~/.photon/sites/restore.sh
source ~/.photon/sites/apache.sh
source ~/.photon/sites/site/_main.sh


alias sites-conf="cd /etc/apache2/sites-available"
alias hosts="sudo vim /etc/hosts"
alias restart="sudo apache2ctl restart"
# TODO how to get the latest version of a github release
# curl -s https://api.github.com/repos/jgm/pandoc/releases/latest \
# | grep "browser_download_url.*deb" \
# | cut -d : -f 2,3 \
# | tr -d \" \
# | wget -qi -

# alias grav-core="wget -O _grav-core.zip https://getgrav.org/download/core/grav/1.6.9 "
# alias grav-admin="wget -O _grav-admin.zip https://getgrav.org/download/core/grav/1.6.9 "
alias grav-update="cd $SITESROOT/grav;bin/gpm self-upgrade;"

function sites() {
  clear
  ui_banner SITES
  echo

  cd $SITESROOT

  if [ $1 ]
  then
    case $1 in
      new)
        sites_new "$2" "$3"
        cd $SITESROOT/$2/user
        ;;
      newhost)
        ~/.photon/sites/newhost.sh "$2" "$3"
        cd $SITESROOT/$2/user
        ;;
      restore)
        sites_restore "$2" "$3"
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
      *)
        clear
        cd $SITESROOT/$1/user
        ui_banner "photon SITE"
        pwd
        echo
        sed -n "s/^\(\s*title:\s*\)\(.*\)/\2/p" config/site.yaml
        echo
        source .photon
        git status -sb
        echo
        ;;
    esac
  else
    cd $SITESROOT
    sites_list
  fi
}
