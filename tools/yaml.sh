#!/usr/bin/env bash
#
# Based on https://gist.github.com/pkuczynski/8665367
# https://gist.github.com/briantjacobs/7753bf850ca5e39be409

yaml_parse() {

  local s='[[:space:]]*'
  local w='[a-zA-Z0-9_]*'
  local fs="$(echo @|tr @ '\034')"
  
  local prefix="${1:-yaml}_"
  
  # sed -ne "s|^\($s\)\($w\)$s:$s\"\(.*\)\"$s\$|\1$fs\2$fs\3|p" \
      # -e "s|^\($s\)\($w\)$s[:-]$s\(.*\)$s\$|\1$fs\2$fs\3|p" "$1" |
  echo "$yaml" |
  sed -ne "s|^\($s\)\($w\)$s:$s\"\(.*\)\"$s\$|\1$fs\2$fs\3|p" \
      -e "s|^\($s\)\($w\)$s[:-]$s\(.*\)$s\$|\1$fs\2$fs\3|p" |
  awk -F"$fs" '{
    indent_width = 4;
    indent = length($1)/indent_width;
    vname[indent] = $2;
    for (i in vname) {if (i > indent) {delete vname[i]}}
        if (length($3) > 0) {
            vn=""; for (i=0; i<indent; i++) {vn=(vn)(vname[i])("_")}
            printf("%s%s%s=(\"%s\")\n", "'"$prefix"'",vn, $2, $3);
        }
    }' | 
  sed 's/_=/+=/g'

}
