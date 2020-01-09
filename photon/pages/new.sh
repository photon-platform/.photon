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
  TEMPLATE=${templates[$(choice + 1 )]}

  # breakdown filepath
  filename=$(basename -- "$TEMPLATE")
  extension="${filename##*.}"
  name="${filename%.*}"
  clear
  ui_banner "photon ✴ NEW $name"

  yaml=$(cat $TEMPLATE)

  # set page title
  title=$(echo "$yaml" | yq r - title )
  read -p "   title: " -i "$title" title
  yaml=$(echo "$yaml" | yq w - title "$title")
  # echo "$yaml"

  # get page folder name from title
  FOLDER=$(echo "$title" | \
    tr "[:upper:]" "[:lower:]" | \
    tr "[:space:]" "-" | \
    sed -e 's/-$//g' | \
    sed -e 's/[,\/\?\.]//g')

  read -p "  FOLDER: " -i "$FOLDER" -e FOLDER

  # determine folder number
  # TODO get next folder number
  NUM="00"
  read -p "     NUM: " -i "$NUM" -e NUM
  if [ $NUM ]
  then
    FOLDER="${NUM}.${FOLDER}"
  fi

  subtitle=$(echo "$yaml" | yq r - subtitle )
  read -p "   subtitle: " -i "$subtitle" subtitle
  yaml=$(echo "$yaml" | yq w - subtitle "$subtitle")
  echo "$yaml"

  read -p " SUMMARY: " SUMMARY

  mkdir $FOLDER
  cd $FOLDER

  echo "---" > "$name.md"
  echo "$yaml" >> "$name.md"
  echo "---" >> "$name.md"
  echo -e "\n$SUMMARY\n" >> "$name.md"
  echo "===" >> "$name.md"

  # TODO change to yaml
  # sed -e "s/:TITLE:/$TITLE/g" \
    # -e "s/:SUBTITLE:/$SUBTITLE/g" \
    # -e "s/:SUMMARY:/$SUMMARY/g" \
    # ~/.photon/templates/$TEMPLATE.md > $TEMPLATE.md

  # case $name in
    # event)
      # subtitle=$(echo "$yaml" | yq r - data.event.startDate )
      # ;;
    # *)
      # subtitle=$(echo "$yaml" | yq r - subtitle )
      # ;;
  # esac

  # if [[ -n $subtitle ]]
  # then
    # # echo $subtitle
    # # printf "$fmt_subtitle" "$subtitle"
  # fi

  # summary=$(tail -n +2 $md | sed -n -e '/^---$/,/^===$/{ /^---$/d; /^===$/d; p; }' | sed 's/^/ /')
  # if [[ -n $summary ]]
  # then
    # echo "$summary" | fold -w $((width-1)) -s
  # fi
  # echo

  # vim $name.md
}

