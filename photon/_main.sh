#!/usr/bin/env bash

source ~/.photon/photon/plugins/_main.sh
source ~/.photon/photon/pages/_main.sh

alias serve="php -S localhost:${PORT} system/router.php"
alias local="open ${LOCAL}"
alias admin="open ${LOCAL}/admin"
alias server="open ${SERVER}"
alias edit="atom ${PROJECT_DIR}/user"
alias archive="cp -r ${PROJECT_DIR} ~/SITES/.archive/$PROJECT.$(date +"%Y%m%d")"

alias pr="cd ${PROJECT_DIR}"
alias th="cd $THEMES_DIR/photon;gss"
alias ch="cd $THEMES_DIR/photon-child;gss"
# alias pg="cd ${PROJECT_DIR}/user/pages;gss"
alias us="cd ${PROJECT_DIR}/user;gss"

alias cc="cd ${PROJECT_DIR};bin/grav clear-cache"
