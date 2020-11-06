#!/usr/bin/env bash

source ~/.photon/tools/images.sh
source ~/.photon/tools/yaml.sh
source ~/.photon/tools/markdown.sh
source ~/.photon/tools/palette.sh
source ~/.photon/tools/speak.sh
source ~/.photon/tools/list.sh
source ~/.photon/tools/git/_main.sh
source ~/.photon/tools/grav/_main.sh
source ~/.photon/tools/ffmpeg/_main.sh

function show_dir() {

  d=$(pwd)
  d=${d##*/user/}
  pg="$(prompt_git "${violet}" "${red}")"
  h1 "${pg}${txReset}: ${d}"
  echo

}
