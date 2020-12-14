#!/usr/bin/env bash

# sandbox a new site with grav
# copy additional files
# set up apache

function sites_new() {

  PROJECT=""
  TITLE=""

  clear
  ui_header "photon ✴ SITES new"

  sudo pwd

  githuborg_set

  # echo
  # read -p "specify PROJECT repo name: " PROJECT
  PROJECT="$(ask_value "specify PROJECT repo name")"

  repo_check
  
  # echo
  # read -p "specify site TITLE: " TITLE
  TITLE="$(ask_value "specify site TITLE")"

  if [ -n $PROJECT ]
  then

    START_TIME="$(date -u +%s)"

    CLONE=starter.photon-platform.net

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
    tools_git_submodules_update
    # git submodule foreach "pwd; \
      # git checkout master; \
      # git status -sb; \
      # echo"


    echo
    echo "✴ set config files"
    cd $SITESROOT/$PROJECT/user
    echo "✴ rename server config folder"
    mv starter.photon-platform.net $PROJECT


    # echo
    # echo "✴ set accounts"
    # cd $SITESROOT/$PROJECT/user
    # cp $SITESROOT/$CLONE/user/accounts/*.yaml accounts/

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

    cd $SITESROOT/$PROJECT
    bin/plugin login new-user \
      -u phi \
      -e phi@phiarchitect.com \
      -P b \
      -N "phi ARCHITECT" \
      -t "admin"
    echo
    echo "✴ init tntsearch"
    bin/plugin tntsearch index
    cd $SITESROOT/$PROJECT/user

    END_TIME="$(date -u +%s)"
    ELAPSED="$(($END_TIME-$START_TIME))"
    TIME=$(convertsecstomin $ELAPSED)
    
    h1 "clone to ${fgYellow}$PROJECT${txReset} is complete."
    h2 "✴ elapsed: ${txBold}$TIME${txReset} m:s"
    echo
    h2 "type ${fgYellow}site${txReset} to enter"

    # echo
    # echo "✴ push to GitHub"

    # read -p "push now? (Y|n): " PUSH
    # if [ $PUSH = 'Y' ]
    # then
      # git push -fu origin master
    # fi

  else
    echo "no project name"
  fi
}
