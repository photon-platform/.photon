#!/usr/bin/env bash
# source ~/.photon/init/_utils.sh
JUPITER=false
SPHINX=true

title "Python"
if $PAUSE; then pause_enter; fi

SECTION_TIME="$(date -u +%s)"

# set up for getting latest version
# TODO: this does not work in chromebook
# sudo apt install software-properties-common -y
# sudo add-apt-repository ppa:deadsnakes/ppa -y
# sudo apt-get update -y

# sub python3.10
# sudo apt install -y python3.10

sub python3-dev
sudo apt install -y python3-dev

sub python3-venv
sudo apt install -y python3-venv
python -m venv -h | tee -a $LOG

sub python3-gi-cairo
sudo apt install -y python3-gi-cairo


sub pip
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python3 get-pip.py
# sudo apt install -y python3-pip
pip --version | tee -a $LOG

sub python3-tk
sudo apt install -y python3-tk
pip install -U tk

echo
sub "python accessories"
echo
sudo apt install -y python3-lxml python3-six python3-css-parser python3-dulwich
sudo apt install -y python3-html5lib python3-regex python3-pillow python3-cssselect python3-chardet

pip install -U sympy
pip install -U numpy
pip install -U matplotlib
# pip install -U scipy

pip install -U mplcursors
pip install -U mpl_interactions

if $JUPITER; then
  pip install -U jupyterlab
  pip install -U mpl_interactions[jupyter]
  pip install -U ipywidgets
  pip install -U ipympl
fi

pip install -U textual rich rich-cli
pip install -U ffmpeg-python

pip install -U dotenv

pip install -U py_midicsv
# pip install -U python-rtmidi
pip install -U mido

pip install -U pyjson5
pip install -U python-slugify

pip install -U gitpython

pip install -U black
pip install -U build
pip install -U twine

if $SPHINX; then
  pip install -U Sphinx
  pip install -U graphviz
  pip install -U pydot
  pip install -U m2r
  pip install -U python-frontmatter
  pip install -U myst-parser
fi

# https://github.com/Tinche/aiofiles
pip install -U aiofiles


# pip install -U ladybug-core
# pip install -U lbt-ladybug

pip install -U google-api-python-client
pip install -U google-auth-oauthlib

pip install -U openai
pip install -U tiktoken
pip install -U langchain
pip install -U wikipedia

# add latex for math
sudo apt install -y texlive-base
# sudo apt install -y texlive-fonts-extra
sudo apt install -y texlive-latex-recommended
sudo apt install -y texlive-latex-extra
sudo apt install -y texlive-fonts-recommended
sudo apt install -y texlive-science
sudo apt install -y texlive-xetex
sudo apt install -y texlive-pictures
sudo apt install -y texlive-pstricks


sub "python settings complete"
elapsed_time $SECTION_TIME | tee -a $LOG

