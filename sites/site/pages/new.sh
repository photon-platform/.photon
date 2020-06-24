#!/usr/bin/bash

TEMPLATE_DIR=~/.photon/templates/

function pg_new() {

  echo "Select a template: "
  echo

  template=$(fd -t f ".yaml$" $TEMPLATE_DIR | fzf)

  # breakdown filepath
  filename=$(basename -- "$template")
  extension="${filename##*.}"
  name="${filename%.*}"
  clear
  ui_banner "photon ✴ NEW $name"

  yaml="$(cat $template)"

  # set page title
  title=$(echo "$yaml" | yq r - title )
  title="$(ask_value "title" "$title" )"
  # read -p "   title: " -i "$title" title
  yaml="$(echo "$yaml" | yq w - title "$title")"

  # get page folder name from title
  folder=$(slugify "$title")

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
      folder="$(date +%Y-%m-%d --date "$postDate")-$folder"
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

LABEL_WIDTH=15
function get_label() {
  printf "${fgYellow}%*s: ${txReset}" $LABEL_WIDTH "$1"
}

function ask_value() {
  label=$(get_label "$1")
  default="${2#null}"
  read -p "$label" -e -i "$default"
  echo "$REPLY"
}

function ask_date() {
  label=$(get_label "$1")
  read -p "$label" -i $(date +%m/%d/%Y) -e startDate
  echo "$startDate"
}

function ask_truefalse() {
  label=$(get_label "$1 [y/n]")
  read -n1 -p "${label}"
  case $REPLY in
    y)
      echo "true"
      ;;
    *)
      echo "false"
      ;;
  esac
}

function update_markdown_yaml() {
  clear
  # cat event.md | sed "/---/,/---/c ---\n$yaml\n---\n"

}
