#!/usr/bin/env bash

# from: https://gist.github.com/pix0r/6083058
function crawl_sitemap() {

  SITEMAP=$1

  if [ "$SITEMAP" = "" ]; then
    echo "Usage: $0 http://domain.com/sitemap"
  else
    XML=`wget -O - --quiet $SITEMAP`
    mapfile -t URLS < <(echo $XML | \
      grep -o "<loc>[^<>]*</loc>" | \
      sed -e 's:</*loc>::g' | \
      tr ' ' '\n' )
    for url in ${URLS[@]}
    do
      echo url: $url
      page=`wget -O - --quiet --random-wait -nv $url`
      wgetreturn=$?
      if [[ $wgetreturn -ne 0 ]]; then
        echo ERROR: $wgetreturn
        # wget error codes
        # https://www.gnu.org/software/wget/manual/html_node/Exit-Status.html
        case $wgetreturn in
          8 )
            echo "     Server issued an error response"
            # inspect $page for error codes
            ;;
        esac
      fi
    done
  fi

}
