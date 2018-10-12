#!/bin/bash

# create a new repo on github
# replace new-project with new repo name


echo "Enter Github Project Name: "
read PROJECT
echo "Enter Site Title: "
read TITLE

clear
git clone https://github.com/i-am-phi/${PROJECT}.git
cd ${PROJECT}
git remote add upstream https://github.com/i-am-phi/photon.git
git fetch upstream
git pull upstream master
git add .
git commit -m "init commit - upstream master"
git push -u origin master

npm install

git checkout docs
git pull upstream docs
git add .
git commit -m "init commit - upstream docs"
git push -u origin docs

git checkout pub
git pull upstream pub
git add .
git commit -m "init commit - upstream pub"
git push -u origin pub

sed -i -e 's/1123/3333/g' data.yml


# change config file - gen site and deploy to github pages
atom .

hexo server -o
