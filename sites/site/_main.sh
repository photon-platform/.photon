#!/usr/bin/bash

alias serve="php -S localhost:${PORT} system/router.php"
alias show="open ${LOCAL}"
alias admin="open ${LOCAL}/admin"
alias server="open ${SERVER}"
alias archive="cp -r ${PROJECT_DIR} ~/SITES/.archive/$PROJECT.$(date +"%Y%m%d")"

alias pjr="cd ${PROJECT_DIR}"
alias pjt="cd $THEMES_DIR/photon;gss"
alias pjc="cd $THEMES_DIR/photon-child;gss"
alias pju="cd ${PROJECT_DIR}/user;gss"

alias grav-cc="cd ${PROJECT_DIR};bin/grav clearcache"
alias grav-log="cd ${PROJECT_DIR};bin/grav logviewer"

source ~/.photon/sites/site/plugins/_main.sh
source ~/.photon/sites/site/pages/_main.sh
source ~/.photon/sites/site/sync.sh

