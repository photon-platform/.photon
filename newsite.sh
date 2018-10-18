#!/bin/bash
source ~/.photon/.hosts
source ~/.photon/.sites

sudo pwd

clear


echo
echo "photon ✴ new site generator"
echo
echo "✴ enter Github Project Name: "
read PROJECT

START_TIME="$(date -u +%s)"

echo
echo "✴ cloning $PROJECT"
git clone git@github.com:i-am-phi/${PROJECT}.git
cd ${PROJECT}

echo
echo "✴ fetch upstream photon"
git remote add upstream git@github.com:photon-platform/photon.git
git fetch upstream

echo
echo "✴ pull upstream photon"
git pull upstream master

echo
echo "✴ update submodules"
git submodule update --init --recursive


echo
echo "✴ set permission for apache"
chmod -R 775 .
echo

echo
echo "✴ add - commit - push origin master"
git add .
git commit -m "init commit - upstream master"
git push -u origin master

echo
echo "✴ add - commit - push origin master"
git checkout -b develop

echo
echo "✴ setup up apache"
echo "✴ setup log dir ~/SITES/LOGS/${PROJECT}"
mkdir ~/SITES/LOGS/${PROJECT}

# TODO: make a proper template
echo
echo "✴ create apache site config file"
sudo sed -i -e "s/port/${PROJECT}/g" /etc/apache2/sites-available/port.conf > /etc/apache2/sites-available/${PROJECT}.conf

echo
echo "✴ enable site"
sudo a2ensite ${PROJECT}

echo
echo "✴ add host entry"
addhost ${PROJECT}

echo
echo "✴ apache restart"
sudo apache2ctl restart

END_TIME="$(date -u +%s)"
ELAPSED="$(($END_TIME-$START_TIME))"
echo
echo "✴ elapsed: $ELAPSED seconds"
