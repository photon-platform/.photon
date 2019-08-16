#!/bin/sh

curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
sudo apt-get install -y nodejs

sudo apt install -y npm

sudo apt install -y rename

sudo apt install -y nextcloud-client

sudo apt install -y sendmail-bin

sudo apt install -y ranger

sudo apt install -y nnn

sudo apt install -y ffmpeg

sudo apt -y install python3-pip python3-setuptools python3-wheel

wget -O ~/Downloads/rapid-photo-downloader.py https://launchpad.net/rapid/pyqt/0.9.14/+download/install.py

python3 ~/Downloads/rapid-photo-downloader.py

# sudo apt install -y ruby-sass
# sudo gem install sass-listen

# dat-sass has been added to the repo 1.22.9
