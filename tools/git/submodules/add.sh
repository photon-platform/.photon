#!/usr/bin/env bash

function tools_git_submodules_add() {

  ui_header "add submodule from repo"

  show_dir
  
  h1 "*** check github repo"
  github="$(ask_value "specify github url" "")"
  git ls-remote -h "${github}" HEAD
  if [[ $? -eq 0  ]]; then
    folder="${github%.git}"
    folder="${folder##*/}"
    folder="${folder#grav-plugin-}"
    folder="${folder#grav-theme-}"
    folder="$(ask_value "confirm folder" "${folder}")"

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

    # git gc --aggressive --prune=all
  else
    read -p "enter to return" 
  fi
}
