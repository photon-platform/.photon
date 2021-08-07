#!/usr/bin/env bash

# initialize the starter site

PROJECT="starter.photon-platform.net"

source ~/.photon/.functions
source ~/.photon/tools/hosts/_main.sh
source ~/.photon/ui/_main.sh
source ~/.photon/sites/_main.sh

sites_restore $PROJECT

firefox "http://$PROJECT.local" &
