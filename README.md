## configurations for the PHOTON platform 

.. note::
   I make these scripts public as a reference. They may not work for you.  


### start

clone this repository and submodules to the user's home directory

```bash
cd ~
git clone --recurse-submodules git@github.com:photon-platform/.photon.git
```

### install-*.sh

these bash scripts will update, install and configure everything necessary for PHOTON on a new Pop!_OS (or Ubuntu) system.

### home.sh

symlinks config files to current user's home folder

- .bashrc
- .bash_profile

### bash_prompt

custom prompt config

shows user, machine, time, directory, and git branch & status (if available)




### `sites`
all sites are created in `~/SITES`

the `sites` command alone will cd to the folder and list the current sites


