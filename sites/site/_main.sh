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
  
  clear -x

  ui_header "SITE $SEP $PROJECT"

  show_dir

  h1 "$(sed -n "s/^\(\s*title:\s*\)\(.*\)/\2/p" config/site.yaml)"
  site_siblings
  h2 "$((siblings_index + 1)) ${fgg08}of${txReset} $siblings_count"
  echo
  fmt="  ${fgYellow}%c${txReset} $SEP ${txBold}%s${txReset} $SEP %d $SEP ${fgRed}%s${txReset}\n"
  
  tmp=$PWD
  
  cd $tmp/pages
  printf "$fmt" "p" "pages" $(find . -name "*.md" | wc -l ) "$(gsss)"
  cd $tmp/plugins
  printf "$fmt" "u" "plugins" $(find . -name "blueprints.yaml" | wc -l ) "$(gsss)"
  cd $tmp/themes
  printf "$fmt" "m" "themes" $(find . -name "blueprints.yaml" | wc -l ) "$(gsss)"
  cd $tmp/config
  printf "$fmt" "c" "config" $(find . -name "*.yaml" | wc -l ) "$(gsss)"

  cd $tmp

  echo
  site_actions

  tab_title
}
