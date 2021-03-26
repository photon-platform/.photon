#!/usr/bin/env bash

function taxonomy_actions() {
  declare -A actions
  actions['?']="help"
  actions[q]="quit"
  actions[/]="search"

  actions[r]="ranger_dir"
  actions[t]="tre"
  actions[l]="ll"

  actions[g]="zd"
  actions[h]="move to parent folder"
  actions[j]="move to next sibling folder"
  actions[k]="move to prev sibling folder"
  actions['1-9']="select child by number"
  actions['0']="select last child"
  actions['#']="select child by number (multi-digit, type enter)"

  actions[a]="open all text files in vim"
  actions[f]="vf; # select files for vim"
  actions[v]="vr; # select most recent foles for vim"

  actions[F]="folder"
  actions[I]="images"
  actions[V]="videos"
  actions[A]="audios"
  actions[G]="git"

  echo
  hr
  P=" ${fgYellow}TAXONOMY${txReset}"
  read -s -n1 -p "$P > " action
  printf " $SEP ${actions[$action]}\n\n"
  case $action in
    \?)
      for key in "${!actions[@]}"; do
        key_item $key "${actions[$key]}"
      done
      taxonomy_actions
      ;;
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
    tax_value=(${tax_category[$tax_key]})
    tax_count=${#tax_value[@]}
    ui_list_item_number $(( i + 1 ))  "$tax_key ($tax_count)"
  done

  echo
  ui_banner "CATEGORY LIST actions: "

  read -s -n1  action
  case $action in

    '#')
      read -p "enter number: " number
      if [[ ${tax_keys[$((number - 1))]} ]]; then
        tax_key=${tax_keys[$((number - 1))]}
        vim -c "/$tax_key/" ${tax_category[$tax_key]}
      fi
      clear
      ;;
    [1-9]*)
      if [[ ${tax_keys[$((action - 1))]} ]]; then
        tax_key=${tax_keys[$((action - 1))]}
        vim -c "/$tax_key/" ${tax_category[$tax_key]}
      fi
      ;;
  esac
}

function taxonomy_list_tags() {
  clear
  ui_banner "TAG LIST: "
  
  mapfile -d '' tax_keys < <(printf '%s\0' "${!tax_tag[@]}" | sort -z )
  for (( i = 0; i < ${#tax_keys[@]}; i++ )); do
    tax_key="${tax_keys[i]}"
    tax_value=(${tax_tag[$tax_key]})
    tax_count=${#tax_value[@]}
    ui_list_item_number $(( i + 1 ))  "$tax_key ($tax_count)"
  done

  echo
  ui_banner "TAG LIST actions: "

  read -s -n1  action
  case $action in

    '#')
      read -p "enter number: " number
      if [[ ${tax_keys[$((number - 1))]} ]]; then
        tax_key=${tax_keys[$((number - 1))]}
        vim -c "/$tax_key/" ${tax_tag[$tax_key]}
      fi
      clear
      ;;
    [1-9]*)
      if [[ ${tax_keys[$((action - 1))]} ]]; then
        tax_key=${tax_keys[$((action - 1))]}
        vim -c "/$tax_key/" ${tax_tag[$tax_key]}
      fi
      ;;
  esac
}

function taxonomy_list_photon() {
  clear
  ui_banner "TAG LIST: "
  
  mapfile -d '' tax_keys < <(printf '%s\0' "${!tax_photon[@]}" | sort -z )
  for (( i = 0; i < ${#tax_keys[@]}; i++ )); do
    tax_key="${tax_keys[i]}"
    tax_value=(${tax_photon[$tax_key]})
    tax_count=${#tax_value[@]}
    ui_list_item_number $(( i + 1 ))  "$tax_key ($tax_count)"
  done

  echo
  ui_banner "TAG LIST actions: "

  read -s -n1  action
  case $action in

    '#')
      read -p "enter number: " number
      if [[ ${tax_keys[$((number - 1))]} ]]; then
        tax_key=${tax_keys[$((number - 1))]}
        vim -c "/$tax_key/" ${tax_photon[$tax_key]}
      fi
      clear
      ;;
    [1-9]*)
      if [[ ${tax_keys[$((action - 1))]} ]]; then
        tax_key=${tax_keys[$((action - 1))]}
        vim -c "/$tax_key/" ${tax_photon[$tax_key]}
      fi
      ;;
  esac
}
