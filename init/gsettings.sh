#!/usr/bin/env bash

# source ~/.photon/init/_utils.sh

# clear -x
title "gnome settings"
if $PAUSE; then pause_enter; fi

SECTION_TIME="$(date -u +%s)"


bg="file:///home/${USERNAME}/.photon/graphics/photon-wallpaper.png"

gsettings set org.gnome.desktop.session idle-delay 0

gsettings set org.gnome.desktop.background primary-color '#222222'
gsettings set org.gnome.desktop.background secondary-color '#222222'
gsettings set org.gnome.desktop.background color-shading-type 'solid'
gsettings set org.gnome.desktop.background picture-uri $bg 
gsettings set org.gnome.desktop.background picture-uri-dark $bg 
gsettings set org.gnome.desktop.screensaver picture-uri $bg
gsettings set org.gnome.desktop.screensaver picture-uri-dark $bg

gsettings set org.gnome.desktop.input-sources xkb-options "['caps:escape']"

gsettings set org.gnome.desktop.input-sources xkb-options "['compose:ralt']"

# https://askubuntu.com/questions/34214/how-do-i-disable-overlay-scrollbars

gsettings set org.gnome.Terminal.Legacy.Settings headerbar false
gsettings set org.gnome.Terminal.Legacy.Settings headerbar "@mb false"
gsettings set org.gnome.Terminal.Legacy.Settings default-show-menubar false

gsettings set org.gnome.desktop.interface overlay-scrolling false

# sub gnome-tweak-tool
# sudo apt install -y gnome-tweak-tool
sub "gnome settings complete"
elapsed_time $SECTION_TIME | tee -a $LOG
