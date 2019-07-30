#!/usr/bin/env bash

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
