#!/usr/bin/env bash

# source ~/.photon/init/_utils.sh

title "node"
if $PAUSE; then pause_enter; fi

SECTION_TIME="$(date -u +%s)"

sub "nvm"
echo
# sudo apt install -y npm
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
source ~/.bashrc
nvm install --lts

sub "timecut & timesnap"
npm i -g timesnap timecut

sub "editly"
sudo apt install -y \
  build-essential \
  libcairo2-dev \
  libpango1.0-dev \
  libjpeg-dev \
  libgif-dev \
  librsvg2-dev
npm i -g canvas
npm i -g editly


sub "node complete"
elapsed_time $SECTION_TIME | tee -a $LOG
