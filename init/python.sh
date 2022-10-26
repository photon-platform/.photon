#!/usr/bin/env bash
# source ~/.photon/init/_utils.sh

title "Python"
if $PAUSE; then pause_enter; fi

SECTION_TIME="$(date -u +%s)"

# set up for getting latest version
sudo apt install software-properties-common -y
sudo add-apt-repository ppa:deadsnakes/ppa

sub python3.10
sudo apt install -y python3.10
python3 --version | tee -a $LOG

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

# sub "Qt5"
# echo
# sudo apt install -y qtbase5-dev qttools5-dev qttools5-dev-tools qtwebengine5-dev

# echo
# sub "python accessories"
# echo
# sudo apt install -y python3-dev python3-pip python3-lxml python3-six python3-css-parser python3-dulwich
# sudo apt install -y python3-tk python3-pyqt5 python3-pyqtwebengine python3-html5lib python3-regex python3-pillow python3-cssselect python3-chardet

# pip install -U pip

pip install -U sympy
pip install -U numpy
pip install -U matplotlib
# pip install -U scipy

pip install -U mplcursors
pip install -U mpl_interactions

pip install -U jupyterlab
pip install -U mpl_interactions[jupyter]
pip install -U ipywidgets
pip install -U ipympl

pip install -U ffmpeg-python

pip install -U py_midicsv
# pip install -U python-rtmidi
pip install -U mido

pip install -U pyjson5
pip install -U python-slugify

pip install -U build
pip install -U twine
pip install -U Sphinx
pip install -U graphviz
pip install -U pydot

# pip install -U ladybug-core
# pip install -U lbt-ladybug

pip install -U google-api-python-client

sub "python settings complete"
elapsed_time $SECTION_TIME | tee -a $LOG
