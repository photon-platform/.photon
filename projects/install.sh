#!/usr/bin/env bash

mkdir -p ~/Projects/GEOMETOR
cd ~/Projects/GEOMETOR

git clone git@github.com:geometor/geometor-explorer
pip install -e geometor-explorer

git clone git@github.com:geometor/explorer-constructions
git clone git@github.com:geometor/geometor.com
git clone git@github.com:geometor/geometor.github.io
git clone git@github.com:geometor/phyllotaxis
git clone git@github.com:geometor/polynumbers
git clone git@github.com:geometor/relop

mkdir -p ~/Projects/PHOTON
cd ~/Projects/PHOTON

git clone git@github.com:photon-platform/photon-sphinx-theme




