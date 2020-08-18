#!/usr/bin/env bash

source ~/.photon/tools/yaml.sh
source ~/.photon/tools/markdown.sh
source ~/.photon/tools/palette.sh
source ~/.photon/tools/git/_main.sh

function show_dir() {

  d=$(pwd)
  d=${d##*/user/}
  pg="$(prompt_git "${violet}" "${red}")"
  h1 "${pg}${txReset}: ${d}"
  echo

}
