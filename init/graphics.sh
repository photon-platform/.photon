#!/bin/sh


sudo apt install -y inkscape
sudo apt install -y darktable
sudo apt install -y gimp

# sudo apt install snapd
# sudo snap install gravit-designer

sudo apt -y install python3-pip python3-setuptools python3-wheel
wget -O ~/Downloads/rapid-photo-downloader.py https://launchpad.net/rapid/pyqt/0.9.14/+download/install.py
python3 ~/Downloads/rapid-photo-downloader.py
