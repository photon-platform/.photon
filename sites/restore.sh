#!/usr/bin/env bash

# sandbox a new site with grav
# copy additional files

function sites_restore() {

  clear
  ui_banner "photon ✴ SITES restore"

  githuborg_set

  echo
  read -p "specify PROJECT repo name to restore: " PROJECT

  repo_check

  if [ -n $PROJECT ]
  then

    START_TIME="$(date -u +%s)"

    # CLONE=starter

    sudo pwd

    echo
    echo "✴ cloning grav"
    cd $SITESROOT/grav
    bin/grav sandbox -s $SITESROOT/$PROJECT
    ln -sf $SITESROOT/grav/.htaccess $SITESROOT/$PROJECT/

    echo
    echo "✴ clone github repo for site"
    cd $SITESROOT/$PROJECT
    rm -rf user
    git clone --recurse-submodules $REPO $SITESROOT/$PROJECT/user

    cd $SITESROOT/$PROJECT/user
    git submodule foreach "pwd; \
      git checkout master; \
      git status -sb; \
      echo"

    # echo
    # echo "✴ set accounts"
    # cp $SITESROOT/$CLONE/user/accounts/*.yaml accounts/

    if [[ $ISLOCAL = true ]]
    then
      apache_new $PROJECT
    fi
      
    gsub update

    END_TIME="$(date -u +%s)"
    ELAPSED="$((END_TIME-START_TIME))"
    TIME=$(convertsecstomin $ELAPSED)
    echo
    echo "✴ elapsed: $TIME m:s"


    
  else
    echo "no project name"
  fi
}
