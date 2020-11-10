#!/usr/bin/env bash

source ~/.photon/ui/_main.sh

clear -x
ui_banner "Gogh - Terminal Themes"
# Gogh theme for Terminal - with Gruvbox

# https://github.com/Mayccoll/Gogh
sudo apt-get install dconf-cli uuid-runtime
bash -c  "$(wget -qO- https://git.io/vQgMr)"
