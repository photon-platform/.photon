#!/usr/bin/env bash

source ~/.photon/sites/site/pages/page/actions.sh
source ~/.photon/sites/site/pages/page/siblings.sh
source ~/.photon/sites/site/pages/page/children.sh

function join_by { local IFS="$1"; shift; echo "$*"; }
function remove_quotes() {
  temp="${1%\'}"
  temp="${temp%\"}"
  temp="${temp#\'}"
  temp="${temp#\"}"
  echo "$temp"
}

function page() {

  clear

  ui_header "ARTICLE $SEP $PROJECT"

  show_dir

  mds=(*.md)
  md=${mds[0]}

  if test -f $md;
  then

    md_type=${md%.*}

    h2 "$fgg12$md - $( date '+%F %H:%M'  -r ${md} )"

    page_siblings
    h2 "$fgg12$((siblings_index + 1)) of $siblings_count"
    echo

    markdown_yaml_get $md
    eval "$(yaml_parse page)"

    if [[ $PAGESYAML == true ]]
    then
      echo "$yaml"
    else
      h1 "$( remove_quotes "$page_title" )"
      h2 "$( remove_quotes "$page_subtitle" )"

      if [[ $page_data_event_startDate ]]
      then
        dt="$( remove_quotes "$page_data_event_startDate" )"
        h2 "$(date '+%A, %B %d, %Y, %I:%M %p'   -d "$dt")"
      fi

      page_cats="$(join_by , "${page_taxonomy_category[@]}" )"

      page_tags="$(join_by , "${page_taxonomy_tag[@]}" )"
      
      page_pho="$(join_by , "${page_taxonomy_photon[@]}" )"

    fi

    summary=$(tail -n +2 $md | sed -n -e '/^---$/,/^===$/{ /^---$/d; /^===$/d; p; }' | sed 's/^/ /')
    if [[ -n $summary ]]
    then
      width=$(tput cols)
      echo "$summary" | fold -w $((width-4)) -s
      echo
    fi

    if [[ $page_cats ]]; then
      h2 "  ${fgGreen}c:${txReset} ${page_cats}"
    fi
    if [[ $page_tags ]]; then
      h2 "  ${fgGreen}t:${txReset} ${page_tags}"
    fi
    if [[ $page_pho ]]; then
      h2 "  ${fgGreen}p:${txReset} ${page_pho}"
    fi
    echo

    # show headings from document indented
    grep -e "^#\{1,6\}" "$md"| sed -e "s/#/  /g"
    echo

    unset -v  $( ( set -o posix ; set ) | grep page_ | sed -n 's/\(.*\)\=(.*/\1/p' )

    page_children

    page_actions
  else
    h1 "page not found"
    echo
    la
  fi
  tab_title

}

