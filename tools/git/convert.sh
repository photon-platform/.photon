#!/usr/bin/env bash

function tools_git_convert_to_ssh() {
  @
  sed -i -e 's,http[s]*://github.com/,git@github.com:,' .git/config
  cat .git/config

  if [[ -f .gitmodules ]]; then
    sed -i -e 's,http[s]*://github.com/,git@github.com:,' .gitmodules
    cat .gitmodules
    git submodule sync --recursive
  fi
}
