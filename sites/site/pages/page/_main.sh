#!/usr/bin/env bash

source ~/.photon/sites/site/pages/page/actions.sh
source ~/.photon/sites/site/pages/page/siblings.sh
source ~/.photon/sites/site/pages/page/children.sh

function join_by { local IFS="$1"; shift; echo "$*"; }

function page() {

  ui_banner "$PROJECT * PAGE "

  show_dir

  mds=(*.md)
  md=${mds[0]}

  if test -f $md;
  then

    md_type=${md%.*}

    h2 $md
    h2 "$( date -Is -r ${md} )"

    page_siblings
    h2 "$((siblings_index + 1)) of $siblings_count"
    echo

    markdown_yaml_get
    eval "$(yaml_parse page)"

    if [[ $PAGESYAML == true ]]
    then
      echo "$yaml"
    else
      h1 "$page_title"
      h2 "$page_subtitle"

      case $md_type in
        event)
          # startDate=$( echo "$yaml" | sed -n -e 's/.*startDate: \(.*\)/\1/p' )
          h2 "$page_data_event_startDate"
          ;;
        *)
          # h2 "$(yq_r "subtitle")"
          ;;
      esac
    fi

    summary=$(tail -n +2 $md | sed -n -e '/^---$/,/^===$/{ /^---$/d; /^===$/d; p; }' | sed 's/^/ /')
    if [[ -n $summary ]]
    then
      echo "$summary" | fold -w $((width-1)) -s
    fi

    # show headings from document indented
    grep -e "^#\{1,6\}" "$md"| sed -e "s/#/  /g"

    echo

    page_cats="$(join_by , "${page_taxonomy_category[@]}" )"
    h2 "cat: ${page_cats}"

    page_tags="$(join_by , "${page_taxonomy_tags[@]}" )"
    h2 "tag: ${page_tags}"
    echo

    unset -v  $( ( set -o posix ; set ) | grep page_ | sed -n 's/\(.*\)\=(.*/\1/p' )

    page_children

    echo
    page_actions
  else
    h1 "page not found"
    echo
    la
  fi

}

