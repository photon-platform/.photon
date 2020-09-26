D=$(date +"%Y%m%d-%T")

cd ~

mv .bashrc .bashrc.$D.bak
ln -sf ~/.photon/home/.bashrc

mv .bash_profile .bash_profile.$D.bak
ln -sf ~/.photon/home/.bash_profile

mv .vimrc .vimrc.$D.bak
ln -sf ~/.photon/.vimrc

mv .vim .vim.$D.bak
ln -sf ~/.photon/.vim

mv .config/ranger .config/ranger.$D.bak
ln -sf ~/.photon/config/ranger ~/.config/ranger
