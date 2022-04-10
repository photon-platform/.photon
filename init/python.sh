#!/usr/bin/env bash
source ~/.photon/ui/_main.sh

clear -x
ui_banner "Python"
echo
# h1 "Anaconda Prerequisites"
# echo
# sudo apt install libgl1-mesa-glx libegl1-mesa libxrandr2 libxss1 libxcursor1 libxcomposite1 libasound2 libxi6 libxtst6

sudo apt install -y python3-pip
sudo apt install -y python3-venv
sudo apt install -y python3-gi-cairo
# h1 "Qt5"
# echo
# sudo apt install -y qtbase5-dev qttools5-dev qttools5-dev-tools qtwebengine5-dev

# echo
# h1 "python accessories"
# echo
# sudo apt install -y python3-dev python3-pip python3-lxml python3-six python3-css-parser python3-dulwich
# sudo apt install -y python3-tk python3-pyqt5 python3-pyqtwebengine python3-html5lib python3-regex python3-pillow python3-cssselect python3-chardet

pip install -U pip

pip install -U jupyterlab
pip install -U sympy
pip install -U numpy
pip install -U matplotlib
pip install -U scipy

pip install -U mplcursors
pip install -U mpl_interactions
pip install -U mpl_interactions[jupyter]

pip install -U ipywidgets
pip install -U ipympl

# pip install -U ffmpeg-python

pip install -U py_midicsv
# pip install -U python-rtmidi
pip install -U mido

# pip install -U pygame

pip install -U build
pip install -U twine
pip install -U Sphinx
pip install -U graphviz
pip install -U pydot

# pip install -U ladybug-core
# pip install -U lbt-ladybug
