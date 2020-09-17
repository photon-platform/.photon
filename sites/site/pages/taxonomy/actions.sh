#!/usr/bin/env bash

function taxonomy_actions() {

  # TODO: show all menu options on '?'
  ui_banner "TAXONOMY actions: "

  read -s -n1  action
  case $action in
    q) clear; pages ;;
    c) taxonomy_list_categories; clear; taxonomy; ;;
    t) taxonomy_list_tags; clear; taxonomy; ;;
    p) taxonomy_list_photon; clear; taxonomy; ;;
  esac
}

function taxonomy_list_categories() {
  clear
  ui_banner "CATEGORY LIST: "
  
  mapfile -d '' tax_keys < <(printf '%s\0' "${!tax_category[@]}" | sort -z )
  for (( i = 0; i < ${#tax_keys[@]}; i++ )); do
    tax_key="${tax_keys[i]}"
    ui_list_item_number $(( i + 1 ))  "$tax_key (${#tax_category[$tax_key]})"
  done

  echo
  ui_banner "CATEGORY LIST actions: "

  read -s -n1  action
  case $action in

    [1-9]*)
      tax_key=${tax_keys[$((action - 1))]}
      vim -c "/$tax_key/" ${tax_category[$tax_key]}
      clear
      taxonomy
      ;;
  esac
}

function taxonomy_list_tags() {
  clear
  ui_banner "TAG LIST: "
  
  mapfile -d '' tax_keys < <(printf '%s\0' "${!tax_tag[@]}" | sort -z )
  for (( i = 0; i < ${#tax_keys[@]}; i++ )); do
    tax_key="${tax_keys[i]}"
    ui_list_item_number $(( i + 1 ))  "$tax_key (${#tax_tag[$tax_key]})"
  done

  echo
  ui_banner "TAG LIST actions: "

  read -s -n1  action
  case $action in

    [1-9]*)
      tax_key=${tax_keys[$((action - 1))]}
      vim -c "/$tax_key/" ${tax_tag[$tax_key]}
      clear
      taxonomy
      ;;
  esac
}

function taxonomy_list_photon() {
  clear
  ui_banner "TAG LIST: "
  
  mapfile -d '' tax_keys < <(printf '%s\0' "${!tax_photon[@]}" | sort -z )
  for (( i = 0; i < ${#tax_keys[@]}; i++ )); do
    tax_key="${tax_keys[i]}"
    ui_list_item_number $(( i + 1 ))  "$tax_key (${#tax_photon[$tax_key]})"
  done

  echo
  ui_banner "TAG LIST actions: "

  read -s -n1  action
  case $action in

    [1-9]*)
      tax_key=${tax_keys[$((action - 1))]}
      vim -c "/$tax_key/" ${tax_photon[$tax_key]}
      clear
      taxonomy
      ;;
  esac
}
