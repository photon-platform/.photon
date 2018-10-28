#!/usr/bin/env bash

# sandbox a new site with grav
# copy additional files
# set up apache


PROJECT="$1"
TITLE="$2"

source ~/.photon/.hosts
source ~/.photon/.sites
source ~/.photon/.functions

echo
echo "✴ photon SITE Generator"
if [ -z $PROJECT ]
then
  echo
  read -p "specify PROJECT repo name: " PROJECT
fi

REPO="https://github.com/i-am-phi/$PROJECT.git"
echo
echo "✴ check remote repo"
echo $REPO
echo
git ls-remote $REPO
if [ $? -ne 0 ]
then
  echo ""
  echo "https://github.com/new"
  exit 1
fi

if [ -z "$TITLE" ]
then
  echo
  read -p "specify site TITLE: " TITLE
fi

if [ -n $PROJECT ]
then

  START_TIME="$(date -u +%s)"

  CLONE=starter

  sudo pwd

  echo
  echo "✴ cloning grav"
  cd ~/SITES/grav
  bin/grav sandbox -s ~/SITES/$PROJECT
  ln -sf ~/SITES/grav/.htaccess ~/SITES/$PROJECT/

  echo
  echo "✴ clone starter user"
  cd ~/SITES/$PROJECT
  rm -rf user
  git clone --recurse-submodules ~/SITES/$CLONE/user/.git ~/SITES/$PROJECT/user
  git submodule foreach "pwd; \
    git checkout master; \
    git status -sb; \
    echo"

  echo
  echo "✴ init tntsearch"
  bin/plugin tntsearch index

  echo
  echo "✴ set config files"
  cd ~/SITES/$PROJECT/user
  echo "✴ create server config folder"
  mv starter.photon-platform.net $PROJECT.illumiphi.com

  echo
  echo "✴ set config files"
  cd ~/SITES/$PROJECT/user

  # update theme
  sed -i "s/^\(\s*theme:\s*\).*/\1photon/" config/system.yaml
  ag --nonumbers "theme:" config/system.yaml

  # update site title
  sed -i "s/^\(\s*title:\s*\).*/\1$TITLE/" config/site.yaml
  ag --nonumbers "title:" config/site.yaml

  # update admin title
  sed -i "s/^\(\s*logo_text:\s*\).*/\1$TITLE/" config/plugins/admin.yaml
  ag --nonumbers "title:" config/plugins/admin.yaml

  # update project key
  sed -i -e "s/^\(\s*export PROJECT=\).*/\1$PROJECT/" \
         -e "s/ph.*net/illumiphi.com/g" \
         .photon
  ag --nonumbers "title:" .photon

  # echo "✴ add submodules"
  #
  # # photon theme
  # git submodule add https://github.com/photon-platform/grav-theme-photon.git themes/photon
  #
  # # plugins
  # for PLUGIN in {photon,photon-{breadcrumbs,creation,event,form,organization,person,portfolio,project,search,subscribe}}; do
  #   rm -rf plugins/$PLUGIN
  #   echo
  #   echo "✴ $PLUGIN"
  #   git submodule add https://github.com/photon-platform/grav-plugin-$PLUGIN.git plugins/$PLUGIN
  # done;

  mkdir ~/SITES/LOGS/$PROJECT
  ~/.photon/sites/new-apache.sh $PROJECT

  git remote set-url origin "$REPO"

  # git add .
  # git commit -m "init"
  # git push -fu origin master

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

else
  echo "no project name"
fi
