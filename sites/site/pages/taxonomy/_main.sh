#!/usr/bin/env bash
source ~/.photon/sites/site/pages/taxonomy/actions.sh

function taxonomy() {

  ui_banner "$PROJECT * TAXONOMY "
  tab_title "$PROJECT * TAXONOMY "

  show_dir

  declare -A tax_category
  declare -A tax_tag
  declare -A tax_photon

  taxonomy_index

  fmt="  [%c] ${fgYellow}%3d${txReset} ${txBold}%s${txReset}\n"
  printf "$fmt" "c" ${#tax_category[@]} "categories"
  printf "$fmt" "t" ${#tax_tag[@]} "tags"
  printf "$fmt" "p" ${#tax_photon[@]} "photon"
  echo
  h1 Categories

  mapfile -d '' tax_keys < <(printf '%s\0' "${!tax_category[@]}" | sort -z )
  for (( i = 0; i < ${#tax_keys[@]}; i++ )); do
    tax_key="${tax_keys[i]}"
    h2 "$tax_key"
    # for md in  ${tax_category[$tax_key]}
    # do
      # h2 " - $md"
    # done
  done

  echo
  h1 Tags

  mapfile -d '' tax_keys < <(printf '%s\0' "${!tax_tag[@]}" | sort -z )
  for (( i = 0; i < ${#tax_keys[@]}; i++ )); do
    tax_key="${tax_keys[i]}"
    h2 "$tax_key"
    # for md in  ${tax_tag[$tax_key]}
    # do
      # h2 " - $md"
    # done
  done

  echo
  h1 Photon

  mapfile -d '' tax_keys < <(printf '%s\0' "${!tax_photon[@]}" | sort -z )
  for (( i = 0; i < ${#tax_keys[@]}; i++ )); do
    tax_key="${tax_keys[i]}"
    h2 "$tax_key"
    # for md in  ${tax_photon[$tax_key]}
    # do
      # h2 " - $md"
    # done
  done

  echo
  taxonomy_actions
}

function taxonomy_index() {
  

  mapfile -t pages_below < <(find . -type f -name "*.md" | sort)

  h1 "indexing pages..."

  for (( i = 0; i < ${#pages_below[@]}; i++ ))
  do
    md=${pages_below[i]}
    h1 "$md"

    markdown_yaml_get "$md"
    eval "$(yaml_parse page)"

    index_page_categories 
    index_page_tags
    index_page_photon

    unset -v  $( ( set -o posix ; set ) | grep page_ | sed -n 's/\(.*\)\=(.*/\1/p' )
  done
  
}

function index_page_categories() {
  for tax_key in  ${page_taxonomy_category[@]}
  do
    tax_category[$tax_key]+="$md "
  done
}

function index_page_tags() {
  for tax_key in  ${page_taxonomy_tag[@]}
  do
    tax_tag[$tax_key]+="$md "
  done
}

function index_page_photon() {
  for tax_key in  ${page_taxonomy_photon[@]}
  do
    tax_photon[$tax_key]+="$md "
  done
}
