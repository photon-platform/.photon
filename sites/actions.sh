#!/usr/bin/env bash

function sites_actions() {
  declare -A actions
  actions[\?]="help"
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

  actions[F]="folder"
  actions[I]="images"
  actions[G]="git"

  actions[n]="create new site"
  actions[s]="restore site from github"

  echo
  hr
  P=" ${fgYellow}SITES${txReset}"
  read -s -n1 -p "$P > " action
  printf " $SEP ${actions[$action]}\n\n"
  case $action in
    \?)
      for key in "${!actions[@]}"; do
        key_item $key "${actions[$key]}"
      done
      sites_actions
      ;;
    q) clear -x; ;;
    /) search; sites ;;

    n) sites_new; site ;;
    s) sites_restore; site ;;

    r) ranger_dir;  sites ;;
    t) tre; sites; ;;
    l) ll; sites_actions ;;

    e) v README.md; sites; ;;
    C) v CHANGELOG.md; sites; ;;

    '#')
      read -p "enter number: " number
      if [[ ${sites[$((number - 1))]} ]]; then
        dir="$(dirname ${sites[((number-1))]})"
        if [[ -d "$dir" ]]; then
          cd "$dir"
        fi
      fi
      site
      ;;
    [1-9]*)
      if [[ ${sites[$((action - 1))]} ]]; then
        dir="$(dirname ${sites[((action-1))]})"
        if [[ -d "$dir" ]]; then
          cd "$dir"
        fi
      fi
      site
      ;;
    0)
      last=$(( ${#sites[@]} - 1 ))
      cd $(dirname ${sites[ last ]})
      site
      ;;
    g)
      echo
      dir=$(sites_dirs | sed -e "s|$SITESROOT/\(.*\)/user/.photon|\1|" | fzf )
      cd "$SITESROOT/$dir/user"
      site
      ;;
    F) folder; ;;
    I) images; ;;
    G)
      clear -x
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
      sites
      ;;
    *)
      echo
      echo " '$action' ${fgRed}not a command${txReset}"
      sites_actions
      ;;
  esac
}
