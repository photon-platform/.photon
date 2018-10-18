#!/usr/bin/env bash

# sandbox a new site with grav
# copy additional files
# set up apache


PROJECT="$1"
TITLE="$2"

source ~/.photon/.hosts
source ~/.photon/.sites

echo
echo "✴ photon SITE Generator"
if [ -z $PROJECT ]
then
  echo
  echo "specify PROJECT repo name: "
  read PROJECT
fi

REPO="git@github.com:i-am-phi/$PROJECT.git"
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
  echo "specify site TITLE: "
  read TITLE
fi

if [ -n $PROJECT ]
then

  START_TIME="$(date -u +%s)"

  cd ~/SITES/starter
  sudo pwd

  echo "✴ cloning starter"
  bin/grav sandbox -s ../$PROJECT

  echo "✴ symlink plugins"
  ln -sf ~/SITES/starter/user/plugins/* ~/SITES/$PROJECT/user/plugins/
  cp -r ~/SITES/starter/user/{accounts,blueprints,config} ~/SITES/$PROJECT/user/
  cp -r ~/SITES/starter/user/themes/photon-child ~/SITES/$PROJECT/user/themes/
  cp -r ~/SITES/starter/user/{.photon,README.md,.gitignore} ~/SITES/$PROJECT/user/

  echo
  echo "✴ set config files"
  cd ../$PROJECT/user

  # update theme
  sed -i.bak "s/^\(\s*theme:\s*\).*/\1photon/" config/system.yaml
  ag --nonumbers "theme:" config/system.yaml

  # update site title
  sed -i.bak "s/^\(\s*title:\s*\).*/\1$TITLE/" config/site.yaml
  ag --nonumbers "title:" config/site.yaml

  # update admin title
  sed -i.bak "s/^\(\s*logo_text:\s*\).*/\1$TITLE/" config/plugins/admin.yaml
  ag --nonumbers "title:" config/plugins/admin.yaml

  # update project key
  sed -i.bak "s/^\(\s*export PROJECT=\).*/\1$PROJECT/" .photon
  ag --nonumbers "title:" .photon

  echo
  echo "✴ git"
  git init
  echo
  echo "✴ add submodules"

  # photon theme
  git submodule add git@github.com:photon-platform/grav-theme-photon.git themes/photon

  # plugins
  for PLUGIN in {photon,photon-{breadcrumbs,creation,event,form,organization,person,portfolio,project,search,subscribe}}; do
    rm -rf plugins/$PLUGIN
    echo
    echo "✴ $PLUGIN"
    git submodule add git@github.com:photon-platform/grav-plugin-$PLUGIN.git plugins/$PLUGIN
  done;

  git add .
  git commit -m "init"
  git remote add origin git@github.com:i-am-phi/$PROJECT.git
  git push -fu origin master

  mkdir ~/SITES/LOGS/$PROJECT
  ~/.photon/sites/new-apache.sh $PROJECT

  END_TIME="$(date -u +%s)"
  ELAPSED="$(($END_TIME-$START_TIME))"
  echo
  echo "✴ elapsed: $ELAPSED seconds"

  sites $PROJECT

  echo
  echo "✴ opening: http://$PROJECT.local"
  open "http://$PROJECT.local"

  echo
  echo "✴ opening: atom"
  atom .

else
  echo "no project name"
fi
