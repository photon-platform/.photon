#!/usr/bin/bash
source ~/.photon/.functions


imgexportdir="${PROJECT_DIR}/user/images/exports"

cd $imgexportdir

for img in *.jpg
do
  img_slug=$(slugify "$img")
  img_meta=${img_slug}.meta.yaml

  echo $img
  echo $img_slug
  echo $img_meta
  cp "$img" "../$img_slug"

  echo title: $(getExif Title) > ../$img_meta
  echo description: $(getExif Description) >> ../$img_meta
  echo subject: [$(getExif Subject)] >> ../$img_meta
  echo hierarchicalSubject: [$(getExif HierarchicalSubject)] >> ../$img_meta
  echo creator: $(getExif Creator) >> ../$img_meta
  echo publisher: $(getExif Publisher) >> ../$img_meta

  echo
done

echo "import complete"
read -p "Remove staged exports: [y|n]" ask
if [[ $ask == "y" ]]
then
  rm *.jpg
fi
