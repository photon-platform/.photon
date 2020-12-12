#!/usr/bin/env bash



function page_actions() {

  # TODO: show all menu options on '?'
  ui_footer "PAGE actions: "

  read -s -n1 -p " > "  action
  case $action in
    q) clear; ;;
    e) vim *.md; clear; page; ;;
    v) sxiv *.jpg; clear; page; ;;
    @) clear; site ;;
    /) search; clear; page; ;;

    r) ranger; clear; page; ;;
    t) tre; clear; page; ;;
    d) ll; echo; page_actions; ;;
    I) images; ;;

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
    
    j) page_sibling_get $((siblings_index + 1)) ;;
    k) page_sibling_get $((siblings_index - 1)) ;;

    [1-9]*) page_child_get $((action - 1)) ;;
    0) page_child_get $(( ${#children[@]} - 1 )) ;;
    a) vim "${children[@]}" ;;
    '#')
      read -p "enter number: " number
      page_child_get $((number - 1))
      ;;

    L) tools_log; clear; page; ;;
    T) taxonomy; clear; page; ;;
    G) tools_git; clear; page ;;
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
