## configurations for the PHOTON platform 

> I make these scripts public as a reference. They may not work for you.  


### start

clone this repository and submodules to the user's home directory

```bash
cd ~
git clone --recurse-submodules git@github.com:photon-platform/.photon.git
```

### install-*.sh

these bash scripts will update, install and configure everything necessary for PHOTON on a new Pop!_OS (or Ubuntu) system.

### home.sh

*called by installs*

symlinks config files to current user's home folder

- .bashrc
- .bash_profile

### bash_prompt

custom prompt config

shows user, machine, time, directory, and git branch & status (if available)


### `legacy shell scripts`

prior to committing myself to Python, I spent a ridiculous amount of time creating shell scripts for managing context from the prompt.

you can find them in the **tools** and **sites** folder
