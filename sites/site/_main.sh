#!/usr/bin/bash

source ~/.photon/sites/site/actions.sh
source ~/.photon/sites/site/pages/_main.sh
source ~/.photon/sites/site/plugins/_main.sh
source ~/.photon/sites/site/themes/_main.sh
source ~/.photon/sites/site/siblings.sh
source ~/.photon/sites/site/sync.sh
source ~/.photon/sites/site/swatch.sh

function site() {
  @
  source .photon
  # clear
  ui_header "$PROJECT * SITE "
  tab_title "$PROJECT * SITE "

  show_dir

  h1 "$(sed -n "s/^\(\s*title:\s*\)\(.*\)/\2/p" config/site.yaml)"
  site_siblings
  h2 "$((siblings_index + 1)) of $siblings_count"
  echo
  fmt="  ${fgYellow}%c${txReset} • ${txBold}%s${txReset} • %d\n"
  printf "$fmt" "p" "pages" $(find ./pages -name "*.md" | wc -l ) 
  printf "$fmt" "u" "plugins" $(find ./plugins -name "blueprints.yaml" | wc -l ) 
  printf "$fmt" "m" "themes" $(find ./themes -name "blueprints.yaml" | wc -l )
  printf "$fmt" "c" "config" $(find ./config -name "*.yaml" | wc -l )

  echo
  site_actions

  tab_title
}
