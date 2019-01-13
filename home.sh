cd ~
mv .bashrc .bashrc.bak
ln -sf ~/.photon/home/.bashrc
mv .bash_profile .bash_profile.bak
ln -sf ~/.photon/home/.bash_profile

source ~/.photon/.bash_profile
