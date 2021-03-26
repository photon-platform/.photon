#!/usr/bin/env bash

# TODO convert aliases to actions
alias archive="cp -r ${PROJECT_DIR} ~/SITES/.archive/$PROJECT.$(date +"%Y%m%d")"

alias grav-log="cd ${PROJECT_DIR};bin/grav logviewer"

function site_actions() {
  declare -A actions
  actions['?']="help"
  actions[q]="quit"
  actions[/]="search"

  actions[r]="ranger_dir"
  actions[t]="tre"
  actions[l]="ll"

  actions[g]="zd"
  actions[h]="move to parent folder"
  actions[j]="move to next sibling folder"
  actions[k]="move to prev sibling folder"
  actions['1-9']="select child by number"
  actions['0']="select last child"
  actions['#']="select child by number (multi-digit, type enter)"

  actions[a]="open all text files in vim"
  actions[f]="vf; # select files for vim"
  actions[v]="vr; # select most recent foles for vim"

  actions[e]="vim README.md"
  actions[C]="vim CHANGELOG.md"
  actions[.]="vim .photon"
  
  actions[o]="open in browser"

  actions[p]="pages"
  actions[u]="plugins"
  actions[m]="themes"
  actions[c]="config"

  actions[w]="scss --watch"

  actions[F]="folder"
  actions[I]="images"
  actions[V]="videos"
  actions[A]="audios"
  actions[G]="git"

  echo
  hr
  P=" ${fgYellow}SITE${txReset}"
  read -s -n1 -p "$P > " action
  printf " $SEP ${actions[$action]}\n\n"
  case $action in
    \?)
      for key in "${!actions[@]}"; do
        key_item $key "${actions[$key]}"
      done
      site_actions
      ;;
    q) clear -x; ;;
    /) search; site; ;;

    r) ranger; site; ;;
    t) tre; site; ;;
    l) ll; echo; site_actions; ;;

    e) v README.md; site; ;;
    C) v CHANGELOG.md; site; ;;
    .) v .photon ; site; ;;

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
