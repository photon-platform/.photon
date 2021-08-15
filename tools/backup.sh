#!/usr/bin/env bash

function backup() {
  rsync -aP $HOME/ /mnt/md0/_HOME/ \
    --exclude ".cache" \
    --delete \
    --backup-dir=/mnt/md0/_HOME_TRASH/
}

function backup2() {
  rsync -aP /mnt/md0/_HOME /media/phi/Maxtor/ \
    --exclude ".git" \
    --delete 
  rsync -aP /mnt/md0/_ARCHIVE /media/phi/Maxtor/ \
    --exclude ".git" \
    --delete 
  rsync -aP /mnt/md0/_GRAPHICS /media/phi/Maxtor/ \
    --exclude ".git" \
    --delete 
}
