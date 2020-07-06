#!/usr/bin/env bash

function pages_actions() {

  # TODO: show all menu options on '?'
  ui_banner "PAGES actions: "

  read -n1  action
  case $action in
    q)
      clear
      echo "exiting PAGES"
      echo "type "pages" to reeneter"
      ;;
    f)
      find_from_dir
      ;;
    d)
      clear
      echo
      ls -hA
      echo
      pages_actions
      ;;
    h)
      cd ..
      clear
      site
      ;;
    j)
      clear
      plugins
      ;;
    k)
      clear
      plugins
      ;;
    [1-9]*)
      cd $(dirname ${children[$((action - 1))]})
      clear
      page
      ;;
    g)
      echo
      # read -p "Enter child number: " -e num
      # cd "${dirs[(($num-1))]}"
      zd
      clear
      page
      ;;
    G)
      clear
      echo
      gss
      read -p "Add and commit this branch [y]:  " -e commit
      if [[ $commit == "y" ]]; then
        gacp
        echo
        read -p "press any key to continue"
      fi
      clear
      pages
      ;;
    r)
      clear
      renumber_children_list
      clear
      clear
      pages
      ;;
    n)
      clear
      pages_new
      clear
      page
      ;;
    *)
      clear
      pages
      ;;
  esac
}
