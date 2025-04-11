#!/usr/bin/env bash

source ~/.photon/ui/_main.sh
source ~/.photon/init/_utils.sh
source ~/.photon/.functions


LOG=~/init.$(timestamp).log
START_TIME="$(date -u +%s)"
PAUSE=true

cd ~/.photon

git clone git@github.com:phiarchitect/.private $HOME/.private

# source ~/.photon/init/vim.sh
# source ~/.photon/init/chrome.sh
# source ~/.photon/init/node.sh
source ~/.photon/init/graphics.sh
source ~/.photon/init/media.sh

