#!/usr/bin/env bash

function page_yaml() {

  yaml=$(cat $md | sed -n '/---/,/---/p')

}


