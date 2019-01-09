#!/bin/sh

# set shares
# install guest additions
# restart

# For a Linux host, first install the DKMS (Dynamic Kernel Module Support) package on the guest machine (source):
# keeps time synced

sudo apt install dkms

# Then install Guest Additions into guest system:

sudo apt install virtualbox-guest-dkms
sudo apt install virtualbox-guest-dkms-hwe
# sudo apt install virtualbox-guest-x11
# sudo apt install virtualbox-guest-x11-hwe


# add phi account to vboxsf group for vbox shares
sudo usermod -a -G vboxsf phi
