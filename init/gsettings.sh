#!/bin/sh

gsettings set org.gnome.desktop.session idle-delay 0

gsettings set org.gnome.desktop.background primary-color '#222222'
gsettings set org.gnome.desktop.background secondary-color '#222222'
gsettings set org.gnome.desktop.background color-shading-type 'solid'
gsettings set org.gnome.desktop.background picture-uri "file:///home/${USERNAME}/.photon/graphics/photon-wallpaper.png"

gsettings set org.gnome.desktop.screensaver picture-uri ''

# https://askubuntu.com/questions/34214/how-do-i-disable-overlay-scrollbars

sudo apt install -y gnome-tweak-tool

