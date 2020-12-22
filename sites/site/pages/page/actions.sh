#!/usr/bin/env bash

function page_actions() {

  echo
  hr
  P=" ${fgYellow}PAGE${txReset}"
  read -s -n1 -p "$P > " action
  case $action in
    q) clear -x; ;;
    e) vim *.md; page; ;;
    @) site ;;
    /) search; page; ;;

    r) ranger; page; ;;
    t) tre; page; ;;
    d) ll;  page_actions; ;;

    m) page_siblings_move; ;;
    y)
      if [[ $PAGESYAML == true ]]
      then
        PAGESYAML=false
      else
        PAGESYAML=true
      fi
      echo "set PAGESYAML=$PAGESYAML"
      page
      ;;
    g) zd; page; ;;
    h)
      # if parent equals pages call pages
      cd ..
      if [[ $(pwd) == "$PROJECT_DIR/user/pages" ]]; then
        pages
      else
        page
      fi
      ;;
    
    j) page_sibling_get $((siblings_index + 1)) ;;
    k) page_sibling_get $((siblings_index - 1)) ;;

    [1-9]*) page_child_get $((action - 1)) ;;
    0) page_child_get $(( ${#children[@]} - 1 )) ;;
    a) vim "${children[@]}" ;;
    '#')
      read -p "enter number: " number
      page_child_get $((number - 1))
      ;;

    f) vf; page; ;;
    v) vr; page; ;;

    o) page_open; page_actions ;;
    I) images; ;;
    F) folder; ;;
    L) tools_log; page; ;;
    T) taxonomy; page; ;;
    G) tools_git; page ;;
    b)
      clear
      page_children_renumber
      page
      ;;
    n)
      clear
      pages_new
      page
      ;;
    *)
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
