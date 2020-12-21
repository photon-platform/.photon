#!/usr/bin/env bash
# source ~/.photon/sites/site/pages/taxonomy/actions.sh

function images_taxonomy() {

  ui_header "IMAGES * TAXONOMY "
  tab_title "IMAGES * TAXONOMY "


  declare -A tax_category
  declare -A tax_tag
  declare -A tax_photon

  taxonomy_index
  clear
  ui_header "$PROJECT * TAXONOMY "
  show_dir
  echo

  fmt="  [%c] ${fgYellow}%3d${txReset} ${txBold}%s${txReset}\n"
  
  printf "$fmt" "c" ${#tax_category[@]} "categories"
  mapfile -d '' tax_keys < <(printf '%s\0' "${!tax_category[@]}" | sort -z )
  join_by , "${tax_keys[@]}" 
  echo
  
  printf "$fmt" "t" ${#tax_tag[@]} "tags"
  mapfile -d '' tax_keys < <(printf '%s\0' "${!tax_tag[@]}" | sort -z )
  join_by , "${tax_keys[@]}" 
  echo
  
  printf "$fmt" "p" ${#tax_photon[@]} "photon"
  mapfile -d '' tax_keys < <(printf '%s\0' "${!tax_photon[@]}" | sort -z )
  join_by , "${tax_keys[@]}" 
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
  for (( j = 0; j < ${#page_taxonomy_tag[@]}; j++ ))
  do
    tax_tag[${page_taxonomy_tag[j]}]+="$md "
  done
}

function index_page_photon() {
  for tax_key in  ${page_taxonomy_photon[@]}
  do
    tax_photon[$tax_key]+="$md "
  done
}
