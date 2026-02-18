#!/usr/bin/env bash

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
