#!/usr/bin/env bash

function site_actions() {

  # TODO: show all menu options on '?'
  ui_banner "SITE actions: "

  read -n1  action
  case $action in
    q)
      clear
      echo "exiting SITE"
      echo "type "site" to reeneter"
      ;;
    x)
      clear
      ui_banner "Site DELETE"
      echo 
      gss
      echo 
      echo check git status above before continuing.
      echo
      read -n1 -p "Proceed?:  " -e response
      if [[ $response == "y" ]]; then
        echo
      fi

      ;;
    o)
      echo open
      select target in local localadmin server serveradmin
      do
        case $target in
          local)
            open $LOCAL
            ;;
          localadmin)
            open $LOCAL/admin
            ;;
          server)
            open $SERVER
            ;;
          serveradmin)
            open $SERVER/admin
            ;;
        esac
        break
      done
      site
      ;;
    p)
      cd pages
      clear
      pages
      ;;
    u)
      cd plugins
      clear
      plugins
      ;;
    t)
      cd themes
      clear
      vf
      clear
      site
      ;;
    c)
      cd config
      clear
      vf
      clear
      site
      ;;
    e)
      vim README.md
      clear
      site
      ;;
    l)
      vim CHANGELOG.md
      clear
      site
      ;;
    .)
      vim .photon
      clear
      site
      ;;

    f)
      find_from_dir
      ;;
    d)
      echo
      ls -hA
      echo
      site_actions
      ;;
    h)
      clear
      sites
      ;;
    j)
      next=$( dirname "${siblings[$((siblings_index + 1))]}" )
      echo $next
      if [[ -d "$next" ]]
      then
        cd ${next}
      fi
      clear
      site
      ;;
    k)
      prev=$( dirname "${siblings[$((siblings_index - 1))]}" )
      echo $prev
      if [[ -d "$prev" ]]
      then
        cd ${prev}
      fi
      clear
      site
      ;;
    G)
      clear
      echo
      gss
      echo
      read -p "Add and commit this folder [y]:  " -e commit
      if [[ $commit == "y" ]]; then
        gacp
        echo
        read -n1 -p "press any key to continue"
      fi
      clear
      site
      ;;
    *)
      echo
      echo "not a command"
      site_actions
      ;;
  esac
}