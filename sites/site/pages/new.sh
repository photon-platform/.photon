#!/usr/bin/bash

TEMPLATE_DIR=~/.photon/templates/

function pages_new() {

  clear
  ui_banner "photon ✴ PAGE new"
  h1 "Select a template: "

  scaffold=$( scaffolds_select )

  # clear
  # ui_banner "photon ✴ PAGE new"
  scaffold_name=`sed -n -e 's/% name: \(.*\)/\1/p' $scaffold`
  h1 "$scaffold_name"
  h2 "$scaffold"
  echo

  scaffold_folder=`sed -n -e 's/% folder: \(.*\)/\1/p' $scaffold`
  
  scaffold_vars=( $( scaffold_vars $scaffold ) )

  for v in ${scaffold_vars[@]}
  do
    eval "unset $v"
  done

  # defs=( `sed -n -e 's/% def: \(.*\)/"\1"/p' $scaffold` )
  mapfile -t defs < <(sed -n -e 's/% def: \(.*\)/\1/p' $scaffold)
  # sed -n -e 's/% def: \(.*\)/"\1"/p' $scaffold | mapfile defs 
  # for def in ${defs[@]}
  for (( i = 0; i < ${#defs[@]}; i++))
  do
    # echo ${defs[i]}
    eval export "${defs[i]}"
  done

  for v in ${scaffold_vars[@]}
  do
    value="$(ask_value "$v" "${!v}" )"
    eval "export $v='$value'"
  done

  # envsubst < $scaffold
  cat $scaffold | sed  -e '/^[%]/d' | envsubst 

  # get page folder name from title
  folder=$(slugify "$title")
  if [[ $scaffold_folder=="date" ]]
  then
    folder="$(date +%Y-%m-%d --date "$post_date")-$folder"
  fi

  mkdir "$folder"

  envsubst < $scaffold > $folder/test.md

  for v in ${scaffold_vars[@]}
  do
      eval "unset $v"
  done

  return



  case $name in
    event)
      allDay=$(ask_truefalse "All Day Event?")
      startDate=$(ask_date "Start Date: ")
      startTime=""
      if [[ $allDay != "true" ]]; then
        read -p "Start Time: " -i "14:00" -e startTime
        startDate+=" $startTime"
      fi
      yaml="$(echo "$yaml" | yq w - date  "$startDate")"
      yaml="$(echo "$yaml" | yq w - data.event.startDate  "$startDate")"
      yaml="$(echo "$yaml" | yq w - data.event.allDay  "$allDay")"
      folder="$(date +%Y-%m-%d --date "$startDate")-$folder"
      ;;
    organization)
      subtitle=$(echo "$yaml" | yq r - subtitle )
      subtitle="$(ask_value "subtitle" "$subtitle" )"
      yaml=$(echo "$yaml" | yq w - subtitle "$subtitle")

      yaml="$(echo "$yaml" | yq w - data.organization.name  "$title")"

      telephone="$(ask_value "telephone")"
      yaml="$(echo "$yaml" | yq w - data.organization.telephone  "$telephone")"

      email="$(ask_value "email")"
      yaml="$(echo "$yaml" | yq w - data.organization.email  "$email")"

      url="$(ask_value "url")"
      yaml="$(echo "$yaml" | yq w - data.organization.url  "$url")"

      streetAddress="$(ask_value "streetAddress")"
      yaml="$(echo "$yaml" | yq w - data.organization.location.address.streetAddress  "$streetAddress")"

      ;;
    post)
      postDate=$(ask_date "post date")
      yaml="$(echo "$yaml" | yq w - date "$postDate")"

      subtitle=$(echo "$yaml" | yq r - subtitle )
      subtitle="$(ask_value "subtitle" "$subtitle" )"
      # read -p "   subtitle: " -i "$subtitle" subtitle
      yaml=$(echo "$yaml" | yq w - subtitle "$subtitle")
      ;;
    *)
      subtitle=$(echo "$yaml" | yq r - subtitle )
      subtitle="$(ask_value "subtitle" "$subtitle" )"
      # read -p "   subtitle: " -i "$subtitle" subtitle
      yaml=$(echo "$yaml" | yq w - subtitle "$subtitle")
      ;;
  esac

  # echo "$yaml"

  summary="$(ask_value "summary" )"
  # read -p " SUMMARY: " SUMMARY

  folder="$(ask_value "folder" "$folder" )"
  # read -p "  folder: " -i "$folder" -e folder

  # determine folder number
  # TODO get next folder number
  folder_num="00"
  folder_num="$(ask_value "folder_num" "$folder_num" )"
  # read -p "     folder_num: " -i "$folder_num" -e folder_num
  if [ $folder_num ]
  then
    folder="${folder_num}.${folder}"
      fi

      mkdir $folder
      cd $folder

      echo "---" > "$name.md"
      echo "$yaml" >> "$name.md"
      echo "---" >> "$name.md"
      echo -e "\n$summary\n" >> "$name.md"
      echo "===" >> "$name.md"

  # vim $name.md
}
