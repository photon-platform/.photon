#!/usr/bin/env bash

source ~/.photon/tools/yaml.sh
source ~/.photon/tools/markdown.sh

function show_dir() {

  d=$(pwd)
  pg="$(prompt_git "${violet}" "${red}")"
  h1 "${pg}${txReset}:${d}"
  echo

}
