#!/bin/sh

# set shares
# install guest additions
# restart

# For a Linux host, first install the DKMS (Dynamic Kernel Module Support) package on the guest machine (source):
# keeps time synced

# sudo apt install -y dkms
sudo apt-get install -y dkms build-essential linux-headers-generic linux-headers-$(uname -r)

# Then install Guest Additions into guest system:

# sudo apt install -y virtualbox-guest-dkms
# sudo apt install -y virtualbox-guest-dkms-hwe
# sudo apt install virtualbox-guest-x11
# sudo apt install virtualbox-guest-x11-hwe

# sudo apt-get install -y virtualbox-guest-dkms virtualbox-guest-utils virtualbox-guest-x11

# sudo apt-get install virtualbox-guest-additions-iso

# add phi account to vboxsf group for vbox shares
sudo usermod -a -G vboxsf ${USERNAME}
