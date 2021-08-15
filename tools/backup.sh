#!/usr/bin/env bash

function backup() {
  rsync -aP $HOME/ /mnt/md0/_HOME/ \
    --exclude ".cache" \
    --delete \
    --backup-dir=/mnt/md0/_HOME_TRASH/
}

function backup2() {
  rsync -aP /mnt/md0/_HOME /media/phi/Hitachi/ \
    --exclude ".git"
    --delete 
}
