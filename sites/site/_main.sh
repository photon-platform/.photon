#!/usr/bin/bash

source ~/.photon/sites/site/actions.sh
source ~/.photon/sites/site/pages/_main.sh
source ~/.photon/sites/site/plugins/_main.sh
source ~/.photon/sites/site/themes/_main.sh
source ~/.photon/sites/site/siblings.sh
source ~/.photon/sites/site/sync.sh

function site() {
  @
  source .photon
  # clear
  ui_banner "$PROJECT * SITE "

  show_dir

  h2 "$(sed -n "s/^\(\s*title:\s*\)\(.*\)/\2/p" config/site.yaml)"
  site_siblings
  h2 "$((siblings_index + 1)) of $siblings_count"
  echo
  fmt="  [%c] ${fgYellow}%3d${txReset} ${txBold}%s${txReset}\n"
  printf "$fmt" "p" $(find ./pages -name "*.md" | wc -l ) "pages"
  printf "$fmt" "u" $(find ./plugins -name "blueprints.yaml" | wc -l ) "plugins"
  printf "$fmt" "t" $(find ./themes -name "blueprints.yaml" | wc -l ) "themes"
  printf "$fmt" "c" $(find ./config -name "*.yaml" | wc -l ) "config"

  echo
  gsss
  echo
  site_actions
}
