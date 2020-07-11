#!/usr/bin/bash

function new_shell() {
  if [[ -n $1 ]]
  then
    echo "#!/usr/bin/bash" > $1.sh
    chmod +x $1.sh
    vim $1.sh
  else
    echo "provide basename for shell"
  fi
}

function new_readme() {
  clear

  # if no second paramter for template - default to readme
  TEMPLATE=${1-"readme"}
  ui_banner "photon ✴ NEW $TEMPLATE"

  # get details
  read -p "   TITLE: " TITLE
  read -p "SUBTITLE: " SUBTITLE
  read -p " SUMMARY: " SUMMARY

  sed -e "s/:TITLE:/$TITLE/g" \
      -e "s/:SUBTITLE:/$SUBTITLE/g" \
      -e "s/:SUMMARY:/$SUMMARY/g" \
      ~/.photon/templates/$TEMPLATE.md > $TEMPLATE.md

  vim $TEMPLATE.md
}

function todo() {
  grep TODO -rH \
    --include="*.sh" \
    --include="*.md" \
    --exclude-from=".gitignore"  \
    --exclude-dir=".atom" \
    --exclude-dir="node_modules" \
    .
  # grep TODO -rn --include="*.sh" --exclude-from=".gitignore"  ./init.sh

}

function askme() {
  read -p "what?" tmp
  echo $tmp
}
