#!/usr/bin/env bash

# create a submodule from an existing folder
function tools_git_submodules_create() {
  folder="$(basename $PWD)"
  github="https://github.com/photon-platform/grav-plugin-${folder}.git"

  ui_banner "Convert '${folder}' to submodule"
  
  h1 "*** checking github repo"
  github="$(ask_value "confirm github" "${github}")"
  git ls-remote -h "${github}" HEAD
  echo Ctrl-C to quit - any key to continue?
  read

  echo
  echo "*** init and push"
  git init
  git add .
  git commit -m "convert to submodule"
  git remote add origin "${github}" 
  git push -fu origin master

  cd ..

  echo
  echo "*** remove from git"
  git rm -rf "${folder}"

  echo
  echo "*** remove from files"
  rm -rf "${folder}"

  echo
  echo "*** add repo as submodule"
  git submodule add --force "${github}" "${folder}"

  echo
  echo "*** update submodules within submodule"
  git submodule update --init --recursive

  echo
  echo "*** push to repo"


  git add .
  git commit -m "add submodule plugin: ${folder}"
  git push -fu origin master

  git gc --aggressive --prune=all
}
