#!/usr/bin/env bash

alias starter="sites starter"
alias photon="sites photon-platform"
alias illumiphi="sites illumiphi"
alias geometor="sites geometor"
alias presence="sites presence"
alias port="sites port-of-alsea"
alias jill="sites jill-moser"
alias gbp="sites gerdemann"
alias ona="sites ona"

alias audio="cd ~/SITES/audio"
alias constructions="cd ~/SITES/constructions;source .photon"

alias inmotion="ssh illumiphi.com"

alias sites-conf="cd /etc/apache2/sites-available"
alias hosts="sudo vim /etc/hosts"
alias restart="sudo apache2ctl restart"

alias grav-core="wget -O _grav-core.zip https://getgrav.org/download/core/grav/1.6.9 "
alias grav-admin="wget -O _grav-admin.zip https://getgrav.org/download/core/grav/1.6.9 "
alias grav-update="cd ~/SITES/grav;bin/gpm self-upgrade;"

function sites() {

  if [ $1 ]
  then
    case $1 in
      new)
        ~/.photon/sites/new.sh "$2" "$3"
        sites "$2"
        ;;
      newhost)
        ~/.photon/sites/newhost.sh "$2" "$3"
        cd ~/SITES/$2
        ;;
      restore)
        ~/.photon/sites/restore.sh "$2" "$3"
        sites "$2"
        ;;
      status)
        cd ~/SITES
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
        cd ~/SITES
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
        cd ~/SITES/$1/user
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
    cd ~/SITES
    ls
  fi
}