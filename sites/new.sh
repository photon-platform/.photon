#!/usr/bin/env bash

# sandbox a new site with grav
# copy additional files
# set up apache

CLONE=starter.photon-platform.net

function sites_new() {
  clear -x
  ui_header "SITES $SEP NEW $SEP $PWD"

  ORGNAME="$1"
  if [[ -z $ORGNAME ]]; then
    echo
    read -p "specify ORGNAME: " ORGNAME
  fi

  PROJECT="$2"
  if [[ -z $PROJECT ]]; then
    echo
    read -p "specify PROJECT in $ORGNAME: " PROJECT
  fi

  repo_check "$ORGNAME" "$PROJECT"
  REPO="git@github.com:$ORGNAME/$PROJECT.git"

  # test for repo check error
  if [[ $? = 0 ]]
  then
    sudo pwd
    TITLE="$(ask_value "specify site TITLE")"

    START_TIME="$(date -u +%s)"

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

    echo
    h1 "✴ set config files"
    cd $SITESROOT/$PROJECT/user
    echo "✴ rename server config folder"
    mv starter.photon-platform.net $PROJECT

    echo
    echo "✴ set config files"
    grep "theme:" config/system.yaml

    echo
    echo update site title
    sed -i "s/^\(\s*title:\s*\).*/\1$TITLE/" config/site.yaml
    grep "title:" config/site.yaml

    echo
    echo update admin title
    sed -i "s/^\(\s*logo_text:\s*\).*/\1$TITLE/" config/plugins/admin.yaml
    grep "title:" config/plugins/admin.yaml

    echo
    echo update .photon title
    sed -i -e "s/^\(\s*export PROJECT=\).*/\1$PROJECT/" \
           -e "s/ph.*net/$PROJECT/g" \
           .photon
    grep "title:" .photon

    apache_new $PROJECT
    
    git remote set-url origin "$REPO"

    git add .
    git commit -m "init"

    echo
    h1 "create admin account"
    cd $SITESROOT/$PROJECT
    bin/plugin login new-user \
      -u phi \
      -e phi@phiarchitect.com \
      -P b \
      -N "phi ARCHITECT" \
      -t "admin"

    echo
    h1 "✴ init tntsearch"
    bin/plugin tntsearch index
    cd $SITESROOT/$PROJECT/user

    END_TIME="$(date -u +%s)"
    ELAPSED="$(($END_TIME-$START_TIME))"
    TIME=$(convertsecstomin $ELAPSED)
    
    echo
    h1 "clone to ${fgYellow}$PROJECT${txReset} is complete."
    h2 "elapsed: ${txBold}$TIME${txReset} m:s"

  else
    echo ${fgRed}ERROR!!${txReset}
    echo "$REPO" not found
  fi
}
