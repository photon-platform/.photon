#!/usr/bin/env bash

function markdown_yaml_get() {

  yaml=$(cat $md | sed -n '/---/,/---/p')

}
