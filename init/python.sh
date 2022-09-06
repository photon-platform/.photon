#!/usr/bin/env bash
# source ~/.photon/init/_utils.sh

title "Python"

h1 python3
sudo apt install -y python3
python3 --version | tee -a $JLOG

h1 python3-dev
sudo apt install -y python3-dev

h1 python3-venv
sudo apt install -y python3-venv
virtualenv --version | tee -a $LOG

h1 python3-gi-cairo
sudo apt install -y python3-gi-cairo

h1 pip
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python3 get-pip.py
# sudo apt install -y python3-pip
pip --version | tee -a $JLOG

# h1 "Qt5"
# echo
# sudo apt install -y qtbase5-dev qttools5-dev qttools5-dev-tools qtwebengine5-dev

# echo
# h1 "python accessories"
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
