#!/usr/bin/env bash

source ~/.photon/sites/site/pages/list.sh
source ~/.photon/sites/site/pages/new.sh
source ~/.photon/sites/site/pages/actions.sh
source ~/.photon/sites/site/pages/sort.sh
source ~/.photon/sites/site/pages/page/_main.sh

function pages() {

  @
  source .photon
  cd pages

  ui_banner "$PROJECT * PAGES"
  d=$(pwd)
  h1 "$(prompt_git):${d}"
  echo

  gsss
  echo

  page_children

  pages_actions

}
