#!/usr/bin/env bash

function markdown_yaml_get() {

  export yaml=$(cat $1 | sed -n '/---/,/---/p')

}
