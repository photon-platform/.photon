#!/usr/bin/env bash

source ~/.photon/ui/_main.sh

clear -x
ui_banner "gnome settings"

sudo hostnamectl set-hostname 'photon'

bg="file:///home/${USERNAME}/.photon/graphics/photon-wallpaper.png"

gsettings set org.gnome.desktop.session idle-delay 0

gsettings set org.gnome.desktop.background primary-color '#222222'
gsettings set org.gnome.desktop.background secondary-color '#222222'
gsettings set org.gnome.desktop.background color-shading-type 'solid'
gsettings set org.gnome.desktop.background picture-uri $bg 
gsettings set org.gnome.desktop.screensaver picture-uri $bg

gsettings set org.gnome.desktop.input-sources xkb-options "['caps:escape']"

gsettings set org.gnome.desktop.input-sources xkb-options "['compose:ralt']"

# https://askubuntu.com/questions/34214/how-do-i-disable-overlay-scrollbars

gsettings set org.gnome.Terminal.Legacy.Settings headerbar false
gsettings set org.gnome.Terminal.Legacy.Settings headerbar "@mb false"
gsettings set org.gnome.Terminal.Legacy.Settings default-show-menubar false

gsettings set org.gnome.desktop.interface overlay-scrolling false

h1 gnome-tweak-tool
sudo apt install -y gnome-tweak-tool

