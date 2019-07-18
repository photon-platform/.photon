#!/usr/bin/env bash

function pg_list() {

  find . -maxdepth 1 -mindepth 1 \
    ! -name "skip" \
    -type d \
    -exec sh -c '(echo {} && \
      cd {} && \
      sed -n "s/^\(title:\s*\)\(.*\)/\2/p" *.md && \
      echo)' \;
}
