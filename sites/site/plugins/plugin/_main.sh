#!/usr/bin/env bash

function plugin() {
  head -n 2 blueprints.yaml
  echo
  git status -sb .

}
