#!/usr/bin/env bash

function page_actions() {

  # TODO: show all menu options on '?'
  ui_banner "PAGE actions: "

  read -n1  action
  case $action in
    q)
      clear
      echo "exiting PAGE"
      echo "type "page" to reeneter"
      ;;
    e)
      vim *.md
      clear
      page
      ;;
    v)
      sxiv *.jpg
      clear
      page
      ;;
    t)
      tre
      # clear
      page_actions
      ;;
    /)
      search
      clear
      page
      ;;
    d)
      clear
      echo
      ls -hA
      echo
      page
      ;;
    m)
      clear
      page_siblings_move
      ;;
    y)
      if [[ $PAGESYAML == true ]]
      then
        PAGESYAML=false
      else
        PAGESYAML=true
      fi

      echo
      echo "set PAGESYAML=$PAGESYAML"
      page_actions
      ;;
    h)
      # if parent equals pages call pages
      cd ..
      clear
      if [[ $(pwd) == "$PROJECT_DIR/user/pages" ]]; then
        pages
      else
        page
      fi
      ;;
    j)
      next=$(dirname ${siblings[$((siblings_index + 1))]})
      if [[ -d "$next" ]]
      then
        cd "$next"
      fi
      clear
      page
      ;;
    k)
      prev=$(dirname ${siblings[$((siblings_index - 1))]})
      if [[ -d "$prev" ]]
      then
        cd "$prev"
      fi
      clear
      page
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
      page
      ;;
    r)
      clear
      renumber_children_list
      clear
      page
      ;;
    n)
      clear
      pages_new
      clear
      page
      ;;
    *)
      clear
      page
      ;;
  esac
}
