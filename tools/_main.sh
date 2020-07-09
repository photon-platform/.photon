#!/usr/bin/env bash

function show_dir() {
  
  d=$(pwd)
  pg="$(prompt_git "${violet}" "${red}")"
  h1 "${pg}${txReset}:${d}"
  echo

}
