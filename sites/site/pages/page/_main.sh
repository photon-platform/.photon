#!/usr/bin/env bash

source ~/.photon/sites/site/pages/page/actions.sh
source ~/.photon/sites/site/pages/page/siblings.sh
source ~/.photon/sites/site/pages/page/children.sh

function page() {

  ui_banner "$PROJECT * PAGE "

  d=$(pwd)
  h1 "$(prompt_git):${d}"
  echo

  mds=(*.md)
  md=${mds[0]}
  h2 $md

  if test -f $md;
  then

    page_siblings
    h2 "$((siblings_index + 1)) of $siblings_count"
    echo

    yaml="$(cat $md | sed -n -e '/^---$/,/^---$/{ /^---$/d; /^---$/d; p; }')"
    title=$( echo "$yaml" | sed -n -e 's/^title: \(.*\)/\1/p' )
    subtitle=$( echo "$yaml" | sed -n -e 's/^subtitle: \(.*\)/\1/p' )

    if [[ $PAGESYAML == true ]]
    then
      echo
      echo "$yaml"
      echo
    else
      h1 "$title"
      h2 "$subtitle"

      case $name in
        event)
          startDate=$( echo "$yaml" | sed -n -e 's/.*startDate: \(.*\)/\1/p' )
          h2 "$startDate"
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

    # h1 "$(yq_r "taxonomy.category")"
    echo

    page_children

    echo
    page_actions
  else
    h1 "page not found"
    echo
    la
  fi

}

