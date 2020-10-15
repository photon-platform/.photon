#!/usr/bin/bash
source ~/.photon/.functions

function getExif() {
  type="$1"
  cmd="exiftool -$type '$img'"
  result=$(eval $cmd)
  IFS=':'
  read -ra arr <<< "$result"
  IFS=' '
  echo "${arr[1]# }"
}

imgexportdir="${PROJECT_DIR}/user/images/exports"

cd $imgexportdir

for img in *.jpg
do
  img_slug=$(slugify "${img%.jpg}")
  img_meta=${img_slug}.jpg.meta.yaml

  echo $img
  echo $img_slug
  echo $img_meta
  cp "$img" "../${img_slug}.jpg"

  echo title: $(getExif Title) > ../$img_meta
  echo description: $(getExif Description) >> ../$img_meta
  echo subject: [$(getExif Subject)] >> ../$img_meta
  echo hierarchicalSubject: [$(getExif HierarchicalSubject)] >> ../$img_meta
  echo creator: $(getExif Creator) >> ../$img_meta
  echo publisher: $(getExif Publisher) >> ../$img_meta

  echo
done

echo "import complete"
read -p "Remove staged exports: [y|n}" ask
if [[ $ask == "y" ]]
then
  rm *.jpg
fi
