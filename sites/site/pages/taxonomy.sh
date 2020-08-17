#!/usr/bin/env bash


function pages_taxonomy() {

  declare -A tax_categories

  mapfile -t pages_below < <(find . -type f -name "*.md" | sort)

  for (( i = 0; i < ${#pages_below[@]}; i++ ))
  do
    md=${pages_below[i]}
    markdown_yaml_get "$md"
    cat_length=$(echo "$yaml" | yq r - --length  taxonomy.category)

    if [ ! -z $cat_length ] && [ $cat_length -ne 0 ]
    then
      h1 "$md"
      for (( j = 0; j < $cat_length; j++ ))
      do
        category="$(echo "$yaml" | yq r - taxonomy.category[$j])"
        if [[ $category ]]
        then
          h2 "$category"
          tax_categories[$category]+="$md "
        fi
      done
    fi
  done


  mapfile -d '' sorted < <(printf '%s\0' "${!tax_categories[@]}" | sort -z )
  for (( i = 0; i < ${#sorted[@]}; i++ )); do
    category="${sorted[i]}"
    h1 "$category"
    # h2 "${tax_categories[$category]}"
    for md in  ${tax_categories[$category]}
    do
      h2 " - $md"
    done
  done

}
