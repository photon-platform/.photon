#!/usr/bin/env bash


echo
h1 "calibre ebook"
echo
sudo -v && wget -nv -O- https://download.calibre-ebook.com/linux-installer.sh | sudo sh /dev/stdin

echo
h1 "vivliostyle cli"
echo "https://www.pagedjs.org/documentation/02-getting-started-with-paged-js/#command-line-version"
echo
npm i -g @vivliostyle/cli

echo
h1 "pagedjs"
echo "https://www.pagedjs.org/documentation/02-getting-started-with-paged-js/#command-line-version"
echo
npm i -g pagedjs-cli pagedjs

echo
h1 "weasyprint"
echo "https://weasyprint.org/start/"
echo
pip install weasyprint
