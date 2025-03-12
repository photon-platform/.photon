#!/usr/bin/env bash
# source ~/.photon/init/_utils.sh
JUPITER=false
SPHINX=true
LATEX=false

title "Python"
if $PAUSE; then pause_enter; fi

SECTION_TIME="$(date -u +%s)"

echo
sub "python accessories"
echo
pip install -U pip
pip install -U lxml six css-parser dulwich html5lib regex pillow cssselect chardet 
# pycairo

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

pip install -U python-dotenv

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
# pip install -U aiofiles


# pip install -U ladybug-core
# pip install -U lbt-ladybug

pip install -U google-api-python-client
pip install -U google-auth-oauthlib

pip install -U openai
pip install -U tiktoken
# pip install -U langchain
# pip install -U wikipedia

python -m pip install aider-install
aider-install

pip install -q -U google-genai

if $LATEX; then
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
fi

#gi libraries
sudo apt-get install libcairo2-dev libgirepository1.0-dev
pip install PyGObject


sub "python settings complete"
elapsed_time $SECTION_TIME | tee -a $LOG

