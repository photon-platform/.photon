#!/usr/bin/env bash

source ~/.photon/tools/yaml.sh
source ~/.photon/tools/markdown.sh
source ~/.photon/tools/git.sh
source ~/.photon/tools/palette.sh

function show_dir() {

  d=$(pwd)
  d=${d##*/user/}
  pg="$(prompt_git "${violet}" "${red}")"
  h1 "${pg}${txReset}: ${d}"
  echo

}
