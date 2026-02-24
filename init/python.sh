#!/usr/bin/env bash
# source ~/.photon/init/_utils.sh

title "uv (python manager)"
if $PAUSE; then pause_enter; fi

SECTION_TIME="$(date -u +%s)"

sub "install uv"
curl -LsSf https://astral.sh/uv/install.sh | sh

# Ensure uv is in path for the current session if not already
if ! command -v uv &> /dev/null; then
    source $HOME/.cargo/env
fi

sub "uv settings complete"
elapsed_time $SECTION_TIME | tee -a $LOG

JUPITER=false
SPHINX=true
LATEX=false

title "Python"
if $PAUSE; then pause_enter; fi

SECTION_TIME="$(date -u +%s)"

echo
sub "python 3.13"
echo
# Install Python 3.13 via uv
uv python install 3.13

title "Python Tools (via uv)"
if $PAUSE; then pause_enter; fi

SECTION_TIME="$(date -u +%s)"

echo
sub "python tools"
echo

if $JUPITER; then
  uv tool install jupyterlab --with ipywidgets --with ipympl --with matplotlib
fi

# Tools
# uv tool install textual --with textual-dev
# uv tool install rich-cli

# Dev tools
uv tool install black
uv tool install build
uv tool install twine

if $SPHINX; then
  uv tool install sphinx --with myst-parser --with sphinx-autobuild
fi

# aider
uv tool install aider-chat

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

#gi libraries (system dev packages)
sudo apt-get install -y libcairo2-dev libgirepository1.0-dev
# PyGObject is a library, usually needed for building python apps that use GTK.
# We skip installing the python binding globally.

sub "python tools complete"
elapsed_time $SECTION_TIME | tee -a $LOG

