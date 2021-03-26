<a href="https://photon-platform.net/">
    <img src="https://photon-platform.net/images/photon-logo-bg.png" alt="photon" title="photon" align="right" height="120" />
</a>

# .photon
## configurations for the PHOTON platform - running on Pop!_OS

Configuration files for the photon PLATFORM - bash scripts and dotfiles, atom editor configuration, file sync, git helpers

> The photon ✴ PLATFORM is an integrated system of open-source components and online services for the development, publishing and management of digital content.

for more about the **PHOTON platform**, visit https://photon-platform.net



## provisioning

A key aspect of the **photon PLATFORM** is to set up a fully functioning development environment with all the tools necessary to develop, publish and manage digital content - and do it quickly and as automatically as possible.

watch the video playlist on [YouTube](https://www.youtube.com/channel/UCYzRQS16EBmsbKuyKMFHSFQ):

[Provisioning the photon PLATFORM](https://www.youtube.com/watch?v=w554w_dDNdA&list=PLruFHGFsvC_xDBtZejbC4_DltTowQ24Wm)

after installing VirtualBox and downloading the OS, takes about an hour to install the OS and applications

### install VirtualBox

downloads and instructions can be found here:
https://www.virtualbox.org/

### download the operating system

**photon** is standardized on the Pop!_OS linux distribution by System76

https://system76.com/pop

click the download button to retrieve the latest iso file

step by step install instructions here:
https://pop.system76.com/docs/install-pop-os/

but overall the installation is very intuitive.

for reference later: custom keyboard shortcuts
https://pop.system76.com/docs/keyboard-shortcuts/

https://pop.system76.com/docs/

### create new virtual machine

Installing Pop!_OS into a virtual machine is covered in the [first provisioing video](https://www.youtube.com/watch?v=w554w_dDNdA)


###  run installation script
once you have successfully installed the environment and logged in with your user account you are ready to install the applications and other settings
this `.photon` project contains all the scripts necessary to download and install the packages required to make the system work.

clone this repository to the users home directory
```
cd ~
git clone "https://github.com/photon-platform/.photon"
```

This will create a new folder called `.photon`

change to this folder then run the `init.sh` script to install and configure all the components for the photon environment

```
cd ~/.photon
./init.sh
```

the script runs a number of subscripts for setup found in the init folder of this projects. The following scripts are run

- minor desktop settings
- apache web server
- php langauge and support services for apache
- setup a default Grav instance from zip file
- clone a local photon starter
- remove unneeded OS components
- VirtualBox tools
- Thunderbird
- Chrome
- graphics tools - Inkscape, Gimp, Darktable
- and Vim for vigor

and at the end, run update and upgrade

## bash config
much of this repo is about source files and scripts to facilitate common actions from the command line.

### home script
symlink the following to current user's home folder
- .bashrc
- .bash_profile

### bash_prompt

custom prompt config

shows user, machine, time, directory, and git branch & status (if available)



## site management scripts and functions



### `sites`
all sites are created in `~/SITES`

the `sites` command alone will cd to the folder and list the current sites



### `sites status`
navigate to the `~/SITES` folder

run git status on all the sites in the folder

TODO: create an option for checking submodules as well

### `sites <foldername>`
the user folder in each site created by photon contains a `.photon` source file with project specific environment variables and aliases to facilitate project management from the commandline.

typing `sites` followed by the site folder name, will `cd` to the `user` folder of the site and load its `.photon` source file.
it also prints the title of the site from the command line.

once you have this site context, you can use the following commands

- `th` - jump to photon theme submodule
- `ch` - jump to child theme folder
- `pg` - jump to `pages` folder
  - `pg new` - create new page from the current folder
- `pl` - jump to plugin folder
  - also has its one parameters for managing photon plugins
- `us` - return to user folder
- `local` - open local site in browser
- `admin` - open local admin page in browser
- `server` - open server page in browser.

and more...

## file sync routines

when in a site context at the commandline

- `sync push all` - rsync to server to synchronize all local project files, including grav, to the server
- `sync push user` - sync just the user folder

## git helpers

`gsub` - perform actions to manage submodules
