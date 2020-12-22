#!/usr/bin/env bash

# TODO convert aliases to actions
alias serve="php -S localhost:${PORT} system/router.php"
alias archive="cp -r ${PROJECT_DIR} ~/SITES/.archive/$PROJECT.$(date +"%Y%m%d")"

alias grav-cc="cd ${PROJECT_DIR};bin/grav clearcache"
alias grav-log="cd ${PROJECT_DIR};bin/grav logviewer"

function site_actions() {

  echo
  hr
  P=" ${fgYellow}SITE${txReset}"
  read -s -n1 -p "$P > " action
  case $action in
    q) clear -x; ;;
    /) search; site; ;;

    r) ranger; site; ;;
    t) tre; site; ;;
    d) ll; echo; site_actions; ;;

    g) zd; folder;;
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

    p) cd pages; pages; ;;
    u) cd plugins; plugins; ;;
    m) cd themes; themes; ;;
    c) cd config; folder; site; ;;

    e) vim README.md; site; ;;
    l) vim CHANGELOG.md; site; ;;
    .) vim .photon; site; ;;

    h) sites; ;;
    j)
      next=$( dirname "${siblings[$((siblings_index + 1))]}" )
      echo $next
      if [[ -d "$next" ]]
      then
        cd ${next}
      fi
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
      site
      ;;
    
    f) vf; site;;
    v) vr; site;;
    V) tools_grav; site ;;
    F) folder; ;;
    I) images; ;;
    G) tools_git; site ;;
    w) 
      gnome-terminal --working-directory=$PWD -- bash -c "source ~/.bashrc; swatch; exec bash"
      site
      ;;
    *)
      echo
      echo " not a command"
      site_actions
      ;;
  esac
}
