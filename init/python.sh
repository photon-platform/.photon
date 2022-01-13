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

# h1 "Qt5"
# echo
# sudo apt install -y qtbase5-dev qttools5-dev qttools5-dev-tools qtwebengine5-dev

# echo
# h1 "python accessories"
# echo
# sudo apt install -y python3-dev python3-pip python3-lxml python3-six python3-css-parser python3-dulwich
# sudo apt install -y python3-tk python3-pyqt5 python3-pyqtwebengine python3-html5lib python3-regex python3-pillow python3-cssselect python3-chardet

pip install jupyterlab
pip install sympy
pip install numpy
pip install matplotlib

pip install mplcursors

pip install ipywidgets
pip install ipympl

# pip install ffmpeg-python

pip install py_midicsv
# pip install python-rtmidi
pip install mido

# pip install pygame


