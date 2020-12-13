#!/usr/bin/env bash

source ~/.photon/sites/site/pages/page/actions.sh
source ~/.photon/sites/site/pages/page/siblings.sh
source ~/.photon/sites/site/pages/page/children.sh

function join_by { local IFS="$1"; shift; echo "$*"; }
function remove_quotes() {
  temp="${1%\'}"
  temp="${temp#\'}"
  echo "$temp"
}

function page() {

  clear -x

  ui_header "PAGE $SEP $PROJECT"

  show_dir

  mds=(*.md)
  md=${mds[0]}

  if test -f $md;
  then

    md_type=${md%.*}

    h2 "$md - $( date '+%F %H:%M'  -r ${md} )"

    page_siblings
    h2 "$((siblings_index + 1)) of $siblings_count"
    echo

    markdown_yaml_get $md
    eval "$(yaml_parse page)"

    if [[ $PAGESYAML == true ]]
    then
      echo "$yaml"
    else
      h1 "$( remove_quotes "$page_title" )"
      h2 "$page_subtitle"

      if [[ $page_data_event_startDate ]]
      then
        dt="$( remove_quotes "$page_data_event_startDate" )"
        h2 "$(date '+%A, %B %d, %Y, %I:%M %p'   -d "$dt")"
      fi

      echo
      page_cats="$(join_by , "${page_taxonomy_category[@]}" )"
      h2 "cat: ${page_cats}"

      page_tags="$(join_by , "${page_taxonomy_tag[@]}" )"
      h2 "tag: ${page_tags}"
      
      page_pho="$(join_by , "${page_taxonomy_photon[@]}" )"
      h2 "pho: ${page_pho}"
      echo

    fi

    summary=$(tail -n +2 $md | sed -n -e '/^---$/,/^===$/{ /^---$/d; /^===$/d; p; }' | sed 's/^/ /')
    if [[ -n $summary ]]
    then
      width=$(tput cols)
      echo "$summary" | fold -w $((width-4)) -s
    fi

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

