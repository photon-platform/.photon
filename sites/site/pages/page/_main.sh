#!/usr/bin/env bash

source ~/.photon/sites/site/pages/page/actions.sh
source ~/.photon/sites/site/pages/page/siblings.sh
source ~/.photon/sites/site/pages/page/children.sh

function page() {
  d=$(pwd)
  ui_banner "$PROJECT * PAGES ${d#*/pages}"

  mds=(*.md)
  md=${mds[0]}
  if test -f $md;
  then

    page_siblings
    echo "" $((siblings_index + 1)) of $siblings_count
    
    yaml="$(cat $md | sed -n -e '/^---$/,/^---$/{ /^---$/d; /^---$/d; p; }')"

    if [[ $PAGESYAML == true ]]
    then
      echo
      echo "$yaml"
      echo
    else
      h1 "$(yq_r "title")"

      case $name in
        event)
          h2 "$(yq_r "data.event.startDate")"
          ;;
        *)
          h2 "$(yq_r "subtitle")"
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

    h1 "$(yq_r "taxonomy.category")"
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

# TODO check $yaml should be established before  calling
function yq_r() {
  key="$1"
  echo "$yaml" | yq r - "$key"
}
