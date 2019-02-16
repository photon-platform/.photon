# convert folder to a submodule
PLUGIN="photon-$1"

cd "$PLUGINS_DIR/$PLUGIN/"
pwd
git ls-remote -h https://github.com/photon-platform/grav-plugin-$PLUGIN.git HEAD
echo Ctrl-C to quit - any key to continue?
read

git init
git add .
git commit -m "convert to submodule"
git remote add origin https://github.com/photon-platform/grav-plugin-$PLUGIN.git
git push -f origin master

cd ..
git rm -rf $PLUGIN
rm -rf $PLUGIN

git submodule add --force https://github.com/photon-platform/grav-plugin-$PLUGIN.git $PLUGIN
git submodule update --init --recursive

# cd /home/phi/SITES/gerdemann
git add .
git commit -m "add submodule plugin: $PLUGIN"
git push origin master

git gc --aggressive --prune=all
