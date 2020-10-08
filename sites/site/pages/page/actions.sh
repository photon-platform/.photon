#!/usr/bin/env bash

function page_actions() {

  # TODO: show all menu options on '?'
  ui_banner "PAGE actions: "

  read -s -n1  action
  case $action in
    q) clear; ;;
    e) vim *.md; clear; page; ;;
    v) sxiv *.jpg; clear; page; ;;
    t) tree; page_actions; ;;
    @) clear; site ;;
    /) search; clear; page; ;;
    r) ranger; clear; page; ;;
    d) la; echo; page_actions; ;;
    m) clear; page_siblings_move; ;;
    y)
      if [[ $PAGESYAML == true ]]
      then
        PAGESYAML=false
      else
        PAGESYAML=true
      fi

      echo
      echo "set PAGESYAML=$PAGESYAML"
      clear
      page
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
    f) vf; clear; page; ;;
    g) zd; clear; page; ;;
    o) page_open; page_actions ;;
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
    '#')
      read -p "enter number: " number
      dir="$(dirname ${children[((number-1))]})"
      cd $dir
      clear
      page
      ;;
    [1-9]*)
      cd $(dirname ${children[$((action - 1))]})
      clear
      page
      ;;
    0)
      last=$(( ${#children[@]} - 1 ))
      cd $(dirname ${children[ last ]})
      clear
      page
      ;;
    T) taxonomy; clear; page; ;;
    G)
      tools_git
      clear
      page
      ;;
    b)
      clear
      page_children_renumber
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

function page_open() {
  # walk up path
  url=${PWD#*/pages/}
  path="$( echo "$url" | sed -e 's|[0-9]\{2\}\.||g' )"
  path="$LOCAL/$path"
  echo opening $path
  open "$path"
  

  
}
