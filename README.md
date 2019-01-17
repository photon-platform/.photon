<a href="https://photon-platform.net/">
    <img src="https://photon-platform.net/images/photon-logo-bg.png" alt="photon" title="photon" align="right" height="120" />
</a>

# photon ✴ CONFIG

Configuration files for the photon PLATFORM - bash scripts and dotfiles, atom editor configuration, file sync, git helpers

You can view a demo of the starter site at https://starter.photon-platform.net


> The photon ✴ PLATFORM is an integrated suite of open source software and cloud-based systems for the development, publishing and management of content.

for more about the **photon ✴ PLATFORM**, visit us at https://photon-platform.net

**TOC**
<!-- @import "[TOC]" {cmd="toc" depthFrom=2 depthTo=6 orderedList=false} -->
<!-- code_chunk_output -->

* [setting up the **photon PLATFORM** in a virtual machine](#setting-up-the-photon-platform-in-a-virtual-machine)
	* [install virtual box](#install-virtual-box)
	* [download the operating system](#download-the-operating-system)
* [run installation script](#run-installation-script)
* [provisioning](#provisioning)
* [bash config](#bash-config)
	* [home script](#home-script)
	* [bash_prompt](#bash_prompt)
* [atom config](#atom-config)
* [file sync routines](#file-sync-routines)
* [git helpers](#git-helpers)

<!-- /code_chunk_output -->

## setting up the **photon PLATFORM** in a virtual machine

A key aspect of **photon** is to set up a fully functioning development environment with all the tools necessary to develop, publish and manage digital content - and do it quickly and as automatically as poosible.

watch the video playlist on youtube to

### install virtual box

https://www.virtualbox.org/

### download the operating system

**photon** is standardized on the Pop!_OS linux distribution by System76

https://system76.com/pop

click the download button to retrieve the latest iso file


step by step install instructions here:
https://pop.system76.com/docs/install-pop-os/

but overall the installation is very intuitive.

custom keyboard shortcuts
https://pop.system76.com/docs/keyboard-shortcuts/

https://pop.system76.com/docs/


##  run installation script
this .photon project contains all the

clone this repository to the users home directory
```
cd ~
git clone "https://github.com/photon-platform/.photon"
```
this will create a new folder called `.photon`

## provisioning

run the `init.sh` script to install and configure all the components for the photon environment

```
cd ~/.photon
./init.sh
```

the script runs a number of subscripts for setup




## bash config
much of this repo about source files and scripts to facilitate common actions from the command line.

### home script
symlink the following to current user's home folder
- .bashrc
- .bash_profile
-

### bash_prompt

- .bash_prompt

<pre><font color="#D75F00"><b>phi</b></font><font color="#EEEEEC"><b> ✴ </b></font><font color="#AF8700"><b>pop-os </b></font><font color="#00AFAF"><b>11:44:44</b></font>
<font color="#5F8700"><b>~/.atom</b></font><font color="#EEEEEC"><b> on </b></font><font color="#5F5FAF"><b>master</b></font><font color="#0087FF"><b> [!?]</b></font>
<font color="#EEEEEC"><b>$ </b></font>
</pre>

## atom config

package sync



## file sync routines

## git helpers
