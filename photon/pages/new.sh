#!/usr/bin/bash

function pg_new() {

  echo "Select templates: "
  echo

  i=1
  dirs=()

  templates=($(ls --color=never ~/.photon/templates/*.yaml | sort))
  for f in ${templates[@]}; do
    filename=$(basename -- "$f")
    extension="${filename##*.}"
    name="${filename%.*}"
    dir=$(dirname "$f")
    dirs+=( $dir )

    ui_list_item_number $i "$name"
    ((i++))
  done
  echo

  read -p "select template number: " -n1 choice

  # if no second paramter for template - default to article
  TEMPLATE=${templates[$((choice - 1))]}

  # breakdown filepath
  filename=$(basename -- "$TEMPLATE")
  extension="${filename##*.}"
  name="${filename%.*}"
  clear
  ui_banner "photon ✴ NEW $name"

  yaml="$(cat $TEMPLATE)"

  # set page title
  title=$(echo "$yaml" | yq r - title )
  read -p "   title: " -i "$title" title
  yaml="$(echo "$yaml" | yq w - title "$title")"
  # echo "$yaml"

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
      read -p "   subtitle: " -i "$subtitle" subtitle
      yaml=$(echo "$yaml" | yq w - subtitle "$subtitle")

      yaml="$(echo "$yaml" | yq w - data.organization.name  "$title")"

      telephone="$(ask_value "telephone: ")"
      yaml="$(echo "$yaml" | yq w - data.organization.telephone  "$telephone")"

      email="$(ask_value "email: ")"
      yaml="$(echo "$yaml" | yq w - data.organization.email  "$email")"

      url="$(ask_value "url: ")"
      yaml="$(echo "$yaml" | yq w - data.organization.url  "$url")"

      streetAddress="$(ask_value "streetAddress: ")"
      yaml="$(echo "$yaml" | yq w - data.organization.location.address.streetAddress  "$streetAddress")"

      ;;
    post)
      postDate=$(ask_date "post date: ")
      folder="$(date +%Y-%m-%d --date "$postDate")-$folder"
      yaml="$(echo "$yaml" | yq w - date "$postDate")"

      subtitle=$(echo "$yaml" | yq r - subtitle )
      read -p "   subtitle: " -i "$subtitle" subtitle
      yaml=$(echo "$yaml" | yq w - subtitle "$subtitle")
      ;;
    *)
      subtitle=$(echo "$yaml" | yq r - subtitle )
      read -p "   subtitle: " -i "$subtitle" subtitle
      yaml=$(echo "$yaml" | yq w - subtitle "$subtitle")
      ;;
  esac

  # echo "$yaml"

  read -p " SUMMARY: " SUMMARY

  read -p "  folder: " -i "$folder" -e folder

  # determine folder number
  # TODO get next folder number
  NUM="00"
  read -p "     NUM: " -i "$NUM" -e NUM
  if [ $NUM ]
  then
    folder="${NUM}.${folder}"
  fi

  mkdir $folder
  cd $folder

  echo "---" > "$name.md"
  echo "$yaml" >> "$name.md"
  echo "---" >> "$name.md"
  echo -e "\n$SUMMARY\n" >> "$name.md"
  echo "===" >> "$name.md"

  # vim $name.md
}

function ask_value() {
  read -p "$1" -e value
  echo "$value"
}

function ask_date() {
  read -p "$1" -i $(date +%m/%d/%Y) -e startDate
  echo "$startDate"
}

function ask_truefalse() {
  read -n1 -p "${1} [y/n]" -e tf
  case $tf in
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
