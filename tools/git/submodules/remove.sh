#!/usr/bin/env bash

#  based on https://gist.github.com/myusuf3/7f645819ded92bda6677
function tools_git_submodules_remove() {

  orig_dir="$(pwd)"
  g-root

  ui_header "REMOVE submodule"

  if [[ $1 ]]; then
    submodule_path=$1
  else
    read -p "enter submodule_path from git root : " submodule_path
  fi

  if [ -d "${submodule_path}" ]
  then

    D=$(date +"%Y%m%d-%T")

    echo
    echo "*** Delete ${submodule_path} from the .gitmodules file"
    cp .gitmodules .gitmodules.$D.bak
    # escape forward slash
    str=$(printf '%s\n' "$submodule_path" | sed -e 's/[\/&]/\\&/g')
    v -c "/${str}/" .gitmodules

    echo
    echo "*** Stage the .gitmodules changes"
    git add .gitmodules

    echo
    echo "*** Delete ${submodule_path} from .git/config"
    cp .git/config .git/config.$D.bak
    v -c "/${str}/" .git/config

    echo
    echo "*** git rm --cached ${submodule_path}"
    git rm --cached "${submodule_path}"

    echo
    echo "*** rm -rf .git/modules/${submodule_path}"
    rm -rf ".git/modules/${submodule_path}"

    echo
    echo "*** commit"
    git commit -m "Removed submodule ${submodule_path}"

    echo
    echo "*** rm -rf ${submodule_path}"
    rm -rf "${submodule_path}"

    echo
    echo "*** git gc --aggressive --prune=all"
    git gc --aggressive --prune=all

  else
    echo ${submodule_path} is not a directory
  fi
  cd $orig_dir
}
