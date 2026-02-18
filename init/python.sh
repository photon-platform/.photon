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
# Install Python 3.13 via uv
uv python install 3.13

# Create a default virtual environment for global-ish packages
# This avoids messing with system python and avoids "externally managed environment" errors
if [ ! -d "$HOME/.venv" ]; then
    uv venv "$HOME/.venv" --python 3.13
fi
source "$HOME/.venv/bin/activate"

# Add activation to bashrc if not present
if ! grep -q "source \"\$HOME/.venv/bin/activate\"" "$HOME/.bashrc"; then
    echo 'source "$HOME/.venv/bin/activate"' >> "$HOME/.bashrc"
fi


title "Python (via uv)"
if $PAUSE; then pause_enter; fi

SECTION_TIME="$(date -u +%s)"

echo
sub "python accessories"
echo

# Upgrade pip in the venv just in case, though uv manages it
uv pip install --upgrade pip

# Libraries
uv pip install lxml six css-parser dulwich html5lib regex pillow cssselect chardet
# pycairo

uv pip install sympy
uv pip install numpy
uv pip install matplotlib
# uv pip install scipy

uv pip install mplcursors
uv pip install mpl_interactions

if $JUPITER; then
  uv pip install jupyterlab
  uv pip install mpl_interactions[jupyter]
  uv pip install ipywidgets
  uv pip install ipympl
fi

# Tools (better installed via uv tool, but can be in venv too)
# Using uv tool for CLI apps is cleaner
uv tool install textual 
uv tool install rich-cli
# rich is a library too
uv pip install rich

uv pip install ffmpeg-python
uv pip install python-dotenv
uv pip install py_midicsv
uv pip install mido
uv pip install pyjson5
uv pip install python-slugify
uv pip install gitpython

# Dev tools
uv tool install black
uv tool install build
uv tool install twine

if $SPHINX; then
  uv pip install Sphinx
  uv pip install graphviz
  uv pip install pydot
  uv pip install m2r
  uv pip install python-frontmatter
  uv pip install myst-parser
fi

uv pip install google-api-python-client
uv pip install google-auth-oauthlib
uv pip install openai
uv pip install tiktoken

# aider
uv tool install aider-chat

uv pip install google-genai

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

