# convert folder to a submodule

cd "/home/phi/SITES/gerdemann/user/plugins/$1/"
pwd
git ls-remote -h git@github.com:photon-platform/grav-plugin-$1.git HEAD
echo Ctrl-C to quit - any key to continue?
read

git init
git add .
git commit -m "convert to submodule"
git remote add origin git@github.com:photon-platform/grav-plugin-$1.git
git push -f origin master

cd ..
git rm -rf $1
rm -rf $1

git submodule add --force git@github.com:photon-platform/grav-plugin-$1.git $1
git submodule update --init --recursive

cd /home/phi/SITES/gerdemann
git add .
git commit -m "add submodule plugin: $1"
git push origin master

git gc --aggressive --prune=all
