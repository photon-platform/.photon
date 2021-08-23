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
    --delete \
    --backup-dir=/media/phi/Maxtor/_TRASH/
  rsync -aP /mnt/md0/Logs /media/phi/Maxtor/ \
    --exclude ".git" \
    --delete \
    --backup-dir=/media/phi/Maxtor/_TRASH/
  rsync -aP /mnt/md0/Media /media/phi/Maxtor/ \
    --exclude ".git" \
    --delete \
    --backup-dir=/media/phi/Maxtor/_TRASH/
  rsync -aP /mnt/md0/Music /media/phi/Maxtor/ \
    --exclude ".git" \
    --delete \
    --backup-dir=/media/phi/Maxtor/_TRASH/
  rsync -aP /mnt/md0/Sessions /media/phi/Maxtor/ \
    --exclude ".git" \
    --delete \
    --backup-dir=/media/phi/Maxtor/_TRASH/
  rsync -aP /mnt/md0/Installs /media/phi/Maxtor/ \
    --exclude ".git" \
    --delete \
    --backup-dir=/media/phi/Maxtor/_TRASH/
  rsync -aP /mnt/md0/_ARCHIVE /media/phi/Maxtor/ \
    --exclude ".git" \
    --delete \
    --backup-dir=/media/phi/Maxtor/_TRASH/
}
