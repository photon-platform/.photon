The **.photon**  project is the set of configurations and utilities for the PHOTON_ platform. 


clone this repository to the users home directory

.. code:: bash

   cd ~
   git clone --recurse-submodules git@github.com:photon-platform/.photon.git

home script
~~~~~~~~~~~

symlink the following to current user’s home folder

-  .bashrc
-  .bash_profile

bash_prompt
~~~~~~~~~~~

custom prompt config

shows user, machine, time, directory, and git branch & status (if
available)

site management scripts and functions
-------------------------------------

``sites``
~~~~~~~~~

all sites are created in ``~/SITES``

the ``sites`` command alone will cd to the folder and list the current
sites

.. _PHOTON: https://photon-platform.github.io
