#!/usr/bin/env bash

# TODO convert aliases to actions
alias serve="php -S localhost:${PORT} system/router.php"
alias archive="cp -r ${PROJECT_DIR} ~/SITES/.archive/$PROJECT.$(date +"%Y%m%d")"

alias grav-cc="cd ${PROJECT_DIR};bin/grav clearcache"
alias grav-log="cd ${PROJECT_DIR};bin/grav logviewer"

function site_actions() {

  hr
  P=" ${fgYellow}SITE${txReset}"
  read -s -n1 -p "$P > " action
  case $action in
    q) clear; ;;
    /) search; clear; site; ;;

    r) ranger; clear; site; ;;
    t) tre; clear; site; ;;
    d) ll; echo; site_actions; ;;

    I) images; ;;
    f) vf; clear; site;;
    g) zd; clear; ;;
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

    p) cd pages; clear; pages; ;;
    u) cd plugins; clear; plugins; ;;
    m) cd themes; clear; themes; ;;
    c) cd config; clear; vf; clear; site; ;;

    e) vim README.md; clear; site; ;;
    l) vim CHANGELOG.md; clear; site; ;;
    .) vim .photon; clear; site; ;;

    h) clear; sites; ;;
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
      if [[ $siblings_index > 0 ]]; then
        prev=$( dirname "${siblings[$((siblings_index - 1))]}" )
        echo $prev
        if [[ -d "$prev" ]]
        then
          cd ${prev}
        fi
      fi
      clear
      site
      ;;
    V)
      clear
      tools_grav
      clear
      site
      ;;
    G)
      tools_git
      clear
      site
      ;;
    w) clear;
      gnome-terminal --working-directory=$PWD -- bash -c "source ~/.bashrc; swatch; exec bash"
      clear
      site
      ;;
    *)
      echo
      echo " not a command"
      site_actions
      ;;
  esac
}
