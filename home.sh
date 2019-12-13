D=$(date +"%Y%m%d-%T")

cd ~

mv .bashrc .bashrc.$D.bak
ln -sf ~/.photon/home/.bashrc

mv .bash_profile .bash_profile.$D.bak
ln -sf ~/.photon/home/.bash_profile

mv .vimrc .vimrc.$D.bak
ln -sf ~/.photon/home/.vimrc
