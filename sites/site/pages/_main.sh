#!/usr/bin/env bash

source ~/.photon/sites/site/pages/new.sh
source ~/.photon/sites/site/pages/actions.sh
source ~/.photon/sites/site/pages/sort.sh
source ~/.photon/sites/site/pages/scaffolds.sh
source ~/.photon/sites/site/pages/taxonomy/_main.sh
source ~/.photon/sites/site/pages/page/_main.sh

function pages() {

  @
  source .photon
  cd pages

  clear -x

  ui_header "ARTICLES $SEP $PROJECT"

  show_dir


  page_children

  pages_actions

  tab_title
}
