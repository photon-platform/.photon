#!/usr/bin/env bash

title "Python"
if $PAUSE; then pause_enter; fi

SECTION_TIME="$(date -u +%s)"

echo
sub "build requirements"
echo
sudo apt install -y make build-essential libssl-dev zlib1g-dev \
libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev \
libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev 

curl https://pyenv.run | bash



sub "python settings complete"
elapsed_time $SECTION_TIME | tee -a $LOG

