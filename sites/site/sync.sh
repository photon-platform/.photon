#!/usr/bin/env bash

convertsecstohours() {
 ((h=${1}/3600))
 ((m=(${1}%3600)/60))
 ((s=${1}%60))
 printf "%02d:%02d:%02d\n" $h $m $s
}

convertsecstomin() {
 ((m=${1}/60))
 ((s=${1}%60))
 printf "%02d:%02d\n" $m $s
}

function sync() {
  if [ $1 ]
  then
    case $1 in
      push)
        if [ $2 ]
        then
          case $2 in
            all)
              sync_push_all
              ;;
            user)
              sync_push_user
              ;;
            *)
              echo "Enter options: sync push all or sync push user"
              ls
              ;;
          esac
        else
          cd $PLUGINS_DIR
          git status -sb
        fi
        ;;
      pull)
        if [ $2 ]
        then
          case $2 in
            backup)
              sync_pull_backup
              ;;
            pages)
              sync_pull_pages
              ;;
            *)
              echo "Enter options: sync pull backup or sync pull pages"
              ls
              ;;
          esac
        else
          cd $PLUGINS_DIR
          git status -sb
        fi
        ;;
      *)
        echo "Enter options: sync push or sync pull"
        ls
        ;;
    esac
  else
    cd $PLUGINS_DIR
    git status -sb
  fi
}

function sync_push_all() {
  cd "$PROJECT_DIR/"
  bin/grav clear-cache

  SOURCE_DIR="$PROJECT_DIR/"
  DEST_DIR=illumiphi.com:${SERVER_DIR}/

  echo
  echo full sync to server
  echo "source: $SOURCE_DIR"
  echo "dest: $DEST_DIR"
  echo
  echo "login to continue - Ctrl-c to stop"
  echo

  START_TIME="$(date -u +%s)"
  # excludes are relative to source dir
  rsync \
    --archive \
    --update \
    --compress \
    --stats \
    --progress \
    --copy-links \
    --exclude "/cache/*" \
    --exclude "/backup/*" \
    --exclude "/images/*" \
    --exclude "/logs/*" \
    --exclude "/user/data/tntsearch/*" \
    --exclude "/user/.sass-cache/" \
    --exclude "/user/.git/" \
    --delete \
    $SOURCE_DIR \
    $DEST_DIR

  END_TIME="$(date -u +%s)"
  ELAPSED="$(($END_TIME-$START_TIME))"
  TIME=$(convertsecstomin $ELAPSED)
  echo
  echo "✴ elapsed: $TIME m:s"
}

function sync_push_user() {
  SOURCE_DIR="$PROJECT_DIR/user/"
  DEST_DIR=illumiphi.com:${SERVER_DIR}/user/

  echo
  echo user sync to server
  echo "source: $SOURCE_DIR"
  echo "dest: $DEST_DIR"
  echo
  echo "press enter to continue - Ctrl-c to stop"
  echo

  START_TIME="$(date -u +%s)"
  rsync \
    --archive \
    --update \
    --compress \
    --stats \
    --progress \
    --copy-links \
    --exclude "data/tntsearch/*" \
    --exclude ".git/" \
    --exclude ".sass-cache/" \
    --exclude "*.com/" \
    --exclude "*.net/" \
    --delete \
    $SOURCE_DIR \
    $DEST_DIR

  END_TIME="$(date -u +%s)"
  ELAPSED="$(($END_TIME-$START_TIME))"
  TIME=$(convertsecstomin $ELAPSED)
  echo
  echo "✴ elapsed: $TIME m:s"
}

function sync_pull_backup(){
  cd "$PROJECT_DIR/"
  bin/grav clear-cache

  SOURCE_DIR=illumiphi.com:${SERVER_DIR}/
  DEST_DIR="/home/phi/SITES/.backup/$PROJECT/"

  echo
  echo pull sync from server backup
  echo "source: $SOURCE_DIR"
  echo "dest: $DEST_DIR"
  echo
  echo "login to continue - Ctrl-c to stop"
  echo

  START_TIME="$(date -u +%s)"
  # excludes are relative to source dir
  rsync \
    --archive \
    --update \
    --compress \
    --stats \
    --progress \
    --delete \
    $SOURCE_DIR \
    $DEST_DIR

  END_TIME="$(date -u +%s)"
  ELAPSED="$(($END_TIME-$START_TIME))"
  TIME=$(convertsecstomin $ELAPSED)
  echo
  echo "✴ elapsed: $TIME m:s"
}

function sync_pull_pages(){
  cd "$PROJECT_DIR/"
  bin/grav clear-cache

  SOURCE_DIR=illumiphi.com:${SERVER_DIR}/user/pages/
  DEST_DIR="$PROJECT_DIR/user/pages/"

  echo
  echo pull sync from server backup
  echo "source: $SOURCE_DIR"
  echo "dest: $DEST_DIR"
  echo
  echo "login to continue - Ctrl-c to stop"
  echo

  START_TIME="$(date -u +%s)"
  # excludes are relative to source dir
  rsync \
    --archive \
    --update \
    --compress \
    --stats \
    --progress \
    --delete \
    $SOURCE_DIR \
    $DEST_DIR

  END_TIME="$(date -u +%s)"
  ELAPSED="$(($END_TIME-$START_TIME))"
  TIME=$(convertsecstomin $ELAPSED)
  echo
  echo "✴ elapsed: $TIME m:s"
}

# alias dry-sync="rsync -auzvhPL --stats --delete --dry-run user/ illumiphi.com:${SERVER_DIR}/user/"
#
# alias sync="rsync -auzvhPL \
#   --stats \
#   --delete \
#   --exclude $PROJECT_DIR/user/.git \
#   --exclude $PROJECT_DIR/user/data/tntsearch/* \
#   $PROJECT_DIR/user/ \
#   illumiphi.com:${SERVER_DIR}/user/"
#
# alias dry-full-sync="rsync -auzvhPL \
#   --stats \
#   --dry-run \
#   --exclude $PROJECT_DIR/backup/* \
#   --exclude $PROJECT_DIR/cache/* \
#   --exclude $PROJECT_DIR/images/* \
#   --exclude $PROJECT_DIR/logs/* \
#   --exclude $PROJECT_DIR/user/.git \
#   --exclude $PROJECT_DIR/user/data/tntsearch/* \
#   --delete \
#   $PROJECT_DIR \
#   illumiphi.com:${SERVER_DIR}/"
#
# alias full-sync="rsync -auzvhPL \
#   --stats \
#   --exclude $PROJECT_DIR/user/.git \
#   --exclude $PROJECT_DIR/backup/* \
#   --exclude $PROJECT_DIR/cache/* \
#   --exclude $PROJECT_DIR/images/* \
#   --exclude $PROJECT_DIR/logs/* \
#   --exclude $PROJECT_DIR/user/data/tntsearch/* \
#   --delete \
#   $PROJECT_DIR/ \
#   illumiphi.com:${SERVER_DIR}/"
