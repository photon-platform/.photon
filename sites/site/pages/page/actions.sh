#!/usr/bin/env bash

function page_actions() {

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
    d) ll; echo; page_actions; ;;
    I) images; ;;

    m) page_siblings_move; ;;
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
    f) vf; page; ;;
    g) zd; page; ;;
    o) page_open; page_actions ;;
    
    j) page_sibling_get $((siblings_index + 1)) ;;
    k) page_sibling_get $((siblings_index - 1)) ;;

    [1-9]*) page_child_get $((action - 1)) ;;
    0) page_child_get $(( ${#children[@]} - 1 )) ;;
    a) vim "${children[@]}" ;;
    '#')
      read -p "enter number: " number
      page_child_get $((number - 1))
      ;;

    L) tools_log; page; ;;
    T) taxonomy; page; ;;
    G) tools_git; page ;;
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
