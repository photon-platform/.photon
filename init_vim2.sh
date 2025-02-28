#!/usr/bin/env bash

source ~/.photon/ui/_main.sh
source ~/.photon/init/_utils.sh
source ~/.photon/.functions


LOG=~/init.$(timestamp).log
START_TIME="$(date -u +%s)"
PAUSE=true

cd ~/.photon

clear -x
title "VIM init"

sudo pwd

source ~/.photon/init/vim.sh


echo
sub "INIT complete"
elapsed_time $START_TIME | tee -a $LOG

