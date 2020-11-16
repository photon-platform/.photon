#!/usr/bin/env bash

# TODO convert aliases to actions
alias serve="php -S localhost:${PORT} system/router.php"
alias archive="cp -r ${PROJECT_DIR} ~/SITES/.archive/$PROJECT.$(date +"%Y%m%d")"

alias grav-cc="cd ${PROJECT_DIR};bin/grav clearcache"
alias grav-log="cd ${PROJECT_DIR};bin/grav logviewer"

function site_actions() {

  # TODO: show all menu options on '?'
  ui_footer "SITE actions: q p u t c h j k g f o e . l / d G V"

  read -s -n1 -p " > "  action
  case $action in
    q) clear; ;;
    r) ranger; clear; site; ;;
    f) vf; clear; site;;
    g) zd; clear; ;;
    x)
      clear
      ui_banner "Site DELETE"
      echo 
      gss
      echo 
      echo check git status above before continuing.
      echo
      read -s -n1 -p "Proceed?:  " -e response
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
    p) cd pages; clear; pages; ;;
    u) cd plugins; clear; plugins; ;;
    t) cd themes; clear; themes; ;;
    c) cd config; clear; vf; clear; site; ;;
    e) vim README.md; clear; site; ;;
    l) vim CHANGELOG.md; clear; site; ;;
    .) vim .photon; clear; site; ;;

    #TODO: conflict on t action
    t) tre ; clear; site; ;;
    /) search; clear; site; ;;
    d) echo; la; echo; site_actions; ;;
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
    w) clear; swatch; ;;
    *)
      echo
      echo " not a command"
      site_actions
      ;;
  esac
}
