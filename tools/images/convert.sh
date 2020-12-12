#!/usr/bin/env bash

function images_screen() {
  if [[ $1 ]]; then
    convert $1 -gravity Center -crop 1920x1080+0+0 +repage $1.screen.png
  else
    echo "Specify file to convert"
  fi
}
alias iscr=images_screen

function images_square() {
  if [[ $1 ]]; then
    convert $1 -gravity Center -crop 1000x1000+0+0 +repage $1.square.png
  else
    echo "Specify file to convert"
  fi
}
alias isqr=images_square

function images_ico() {
  if [[ $1 ]]; then
    convert $1 -define icon:auto-resize=64,48,32,16 favicon.ico
  else
    echo "Specify file to convert"
  fi
}
alias iico=images_ico

function images_base64(){
  # https://gist.github.com/puppybits/1565441/378180ab1d9b73a39099a24a2167318a426ee4bb
  if [[ $1 ]]; then
    # Remove escapes from the spaces
    FILE_PATH=$(echo $1 | tr -s " " "\\ ")

    filename=$(basename $FILE_PATH)
    ext=${filename##*.}
    if [ $ext == gif ]; then
      append="data:image/gif;base64,";
    elif [ $ext == jpeg ] || [ $ext == jpg ]; then
      append="data:image/jpeg;base64,";
    elif [ $ext == png ]; then
      append="data:image/png;base64,";
      echo "this worked {$FILE_PATH}"
    elif [ $ext == svg ]; then
      append="data:image/svg+xml;base64,";
    elif [ $ext == ico ]; then
      append="data:image/vnd.microsoft.icon;base64,";
    fi

    data=$( base64 < "$FILE_PATH" | tr -d '\n')

    if [ "$#" -eq 2 ] && [ $2 == -img ]; then
      data=\<img\ src\=\"$append$data\"\>
    else
      data=$append$data
    fi
    echo $data 
  else
    echo "Specify file to convert"
  fi
}
alias ib64=images_base64

