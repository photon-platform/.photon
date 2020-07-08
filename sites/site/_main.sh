#!/usr/bin/bash

alias serve="php -S localhost:${PORT} system/router.php"
alias archive="cp -r ${PROJECT_DIR} ~/SITES/.archive/$PROJECT.$(date +"%Y%m%d")"

alias grav-cc="cd ${PROJECT_DIR};bin/grav clearcache"
alias grav-log="cd ${PROJECT_DIR};bin/grav logviewer"

source ~/.photon/sites/site/actions.sh
source ~/.photon/sites/site/pages/_main.sh
source ~/.photon/sites/site/plugins/_main.sh
source ~/.photon/sites/site/siblings.sh
source ~/.photon/sites/site/sync.sh

function site() {
  @
  source .photon
  # clear
  ui_banner "$PROJECT * SITE "

  d=$(pwd)
  pg="$(prompt_git "${violet}" "${red}")"
  h1 "${pg}${txReset}:${d}"
  echo

  h2 "$(sed -n "s/^\(\s*title:\s*\)\(.*\)/\2/p" config/site.yaml)"
  h2 "$(pwd)"
  site_siblings
  h2 "$((siblings_index + 1)) of $siblings_count"
  echo
  fmt="  [%c] ${fgYellow}%3d${txReset} ${txBold}%s${txReset}\n"
  printf "$fmt" "p" $(find ./pages -name "*.md" | wc -l ) "pages"
  printf "$fmt" "u" $(find ./plugins -name "blueprints.yaml" | wc -l ) "plugins"
  printf "$fmt" "t" $(find ./themes -name "blueprints.yaml" | wc -l ) "themes"
  printf "$fmt" "c" $(find ./config -name "*.md" | wc -l ) "config"
  # echo "[p] pages   $(find ./pages -name "*.md" | wc -l )"
  # echo "[u] plugins $(find ./plugins -name "blueprints.yaml" | wc -l )"
  # echo "[t] themes $(find ./themes -name "blueprints.yaml" | wc -l )"
  # echo "[c] config $(find ./config -name "*.yaml" | wc -l )"
  echo
  gsss
  echo
  site_actions
}
