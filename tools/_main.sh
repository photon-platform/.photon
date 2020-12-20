#!/usr/bin/env bash

source ~/.photon/tools/yaml.sh
source ~/.photon/tools/markdown.sh
source ~/.photon/tools/palette.sh
source ~/.photon/tools/speak.sh
source ~/.photon/tools/list.sh
source ~/.photon/tools/search.sh
source ~/.photon/tools/server.sh
source ~/.photon/tools/compkeys.sh

source ~/.photon/tools/folder/_main.sh
source ~/.photon/tools/git/_main.sh
source ~/.photon/tools/grav/_main.sh
source ~/.photon/tools/ffmpeg/_main.sh
source ~/.photon/tools/log/_main.sh
source ~/.photon/tools/shell/_main.sh
source ~/.photon/tools/hosts/_main.sh
source ~/.photon/tools/images/_main.sh
source ~/.photon/tools/capture/_main.sh

function show_dir() {

  d=$(pwd)
  d=${d##*/user/}
  h1 "${fgPurple}$(git_branch) $SEP ${fgRed}$(gsss)${txReset} $SEP ${d}"
  echo

}
