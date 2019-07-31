#1 /usr/bin/env bash

function pl() {
  if [ $1 ]
  then
    case $1 in

      new)
        pr
        bin/plugin photon newplugin
        ;;
      sub)
        # initialize a submodule
        if [ $2 ]
        then
          echo ""
          pl $2
          pl_sub $2
        else
          echo "format: pl sub pluginname"
        fi
        ;;

      *)
        # jump to plugin
        cd "$PLUGINS_DIR/photon-$1"
        head -n 2 blueprints.yaml
        echo
        git status -sb .
        ;;


    esac
  else
    cd $PLUGINS_DIR
    git status -sb .
  fi
}

function pl_sub() {
  echo
  echo "*** checking github repo"
  git ls-remote -h https://github.com/photon-platform/grav-plugin-photon-$1.git HEAD
  echo Ctrl-C to quit - any key to continue?
  read

  echo
  echo "*** init and push"
  git init
  git add .
  git commit -m "convert to submodule"
  git remote add origin https://github.com/photon-platform/grav-plugin-photon-$1.git
  git push -fu origin master

  cd ..

  echo
  echo "*** remove from git"
  git rm -rf photon-$1

  echo
  echo "*** remove from files"
  rm -rf photon-$1

  echo
  echo "*** add repo as submodule"
  git submodule add --force https://github.com/photon-platform/grav-plugin-photon-$1.git photon-$1

  echo
  echo "*** update submodules within submodule"
  git submodule update --init --recursive

  echo
  echo "*** push to repo"


  git add .
  git commit -m "add submodule plugin: photon-$1"
  git push -fu origin master

  git gc --aggressive --prune=all
}
