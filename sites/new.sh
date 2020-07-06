#!/usr/bin/env bash

# sandbox a new site with grav
# copy additional files
# set up apache

function sites_new() {

  PROJECT=""
  TITLE=""

  clear
  ui_banner "photon ✴ SITES new"

  githuborg_set

  echo
  read -p "specify PROJECT repo name: " PROJECT

  repo_check
  
  echo
  read -p "specify site TITLE: " TITLE

  if [ -n $PROJECT ]
  then

    START_TIME="$(date -u +%s)"

    CLONE=starter

    sudo pwd

    echo
    echo "✴ cloning grav"
    cd $SITESROOT/grav
    bin/grav sandbox -s $SITESROOT/$PROJECT
    ln -sf $SITESROOT/grav/.htaccess $SITESROOT/$PROJECT/

    echo
    echo "✴ clone starter user"
    cd $SITESROOT/$PROJECT
    rm -rf user
    git clone --recurse-submodules $SITESROOT/$CLONE/user/.git $SITESROOT/$PROJECT/user
    git submodule foreach "pwd; \
      git checkout master; \
      git status -sb; \
      echo"

    echo
    echo "✴ init tntsearch"
    bin/plugin tntsearch index

    echo
    echo "✴ set config files"
    cd $SITESROOT/$PROJECT/user
    echo "✴ rename server config folder"
    mv starter.photon-platform.net $PROJECT


    echo
    echo "✴ set accounts"
    cd $SITESROOT/$PROJECT/user
    cp $SITESROOT/$CLONE/user/accounts/*.yaml accounts/

    echo
    echo "✴ set config files"
    # update theme
    # sed -i "s/^\(\s*theme:\s*\).*/\1photon/" config/system.yaml
    ag --nonumbers "theme:" config/system.yaml

    # update site title
    sed -i "s/^\(\s*title:\s*\).*/\1$TITLE/" config/site.yaml
    ag --nonumbers "title:" config/site.yaml

    # update admin title
    sed -i "s/^\(\s*logo_text:\s*\).*/\1$TITLE/" config/plugins/admin.yaml
    ag --nonumbers "title:" config/plugins/admin.yaml

    # update project key
    sed -i -e "s/^\(\s*export PROJECT=\).*/\1$PROJECT/" \
           -e "s/ph.*net/$PROJECT/g" \
           .photon
    ag --nonumbers "title:" .photon


    apache_new $PROJECT

    git remote set-url origin "$REPO"

    git add .
    git commit -m "init"

    END_TIME="$(date -u +%s)"
    ELAPSED="$(($END_TIME-$START_TIME))"
    TIME=$(convertsecstomin $ELAPSED)
    echo
    echo "✴ elapsed: $TIME m:s"


    echo
    echo "Photon Project Commands"
    echo
    echo serve="php -S localhost:${PORT} system/router.php"
    echo local="open ${LOCAL}"
    echo admin="open ${LOCAL}/admin"
    echo server="open ${SERVER}"
    echo edit="atom ${PROJECT_DIR}/user"
    echo
    echo pr="cd ${PROJECT_DIR}"
    echo th="cd $THEMES_DIR/photon;gss"
    echo ch="cd $THEMES_DIR/photon-child;gss"
    echo pg="cd ${PROJECT_DIR}/user/pages;gss"
    echo us="cd ${PROJECT_DIR}/user;gss"

    echo
    echo "✴ push to GitHub"

    read -p "push now? (Y|n): " PUSH
    if [ $PUSH = 'Y' ]
    then
      git push -fu origin master
    fi

  else
    echo "no project name"
  fi
}
