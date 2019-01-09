#!/bin/sh

gsettings set org.gnome.desktop.session idle-delay 0

gsettings set org.gnome.desktop.background primary-color '#222222'
gsettings set org.gnome.desktop.background secondary-color '#222222'
gsettings set org.gnome.desktop.background color-shading-type 'solid'
gsettings set org.gnome.desktop.background picture-uri 'file:///home/phi/.photon/graphics/photon-wallpaper.png'

gsettings set org.gnome.desktop.screensaver picture-uri ''
