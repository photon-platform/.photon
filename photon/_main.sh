#!/usr/bin/bash

alias serve="php -S localhost:${PORT} system/router.php"
alias op="open ${LOCAL}"
alias admin="open ${LOCAL}/admin"
alias server="open ${SERVER}"
alias archive="cp -r ${PROJECT_DIR} ~/SITES/.archive/$PROJECT.$(date +"%Y%m%d")"

alias pr="cd ${PROJECT_DIR}"
alias th="cd $THEMES_DIR/photon;gss"
alias ch="cd $THEMES_DIR/photon-child;gss"
alias us="cd ${PROJECT_DIR}/user;gss"

alias grav-cc="cd ${PROJECT_DIR};bin/grav clearcache"
alias grav-log="cd ${PROJECT_DIR};bin/grav logviewer"

source ~/.photon/photon/plugins/_main.sh
source ~/.photon/photon/pages/_main.sh

source ~/.photon/photon/shell/_main.sh
