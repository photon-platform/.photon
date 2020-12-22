#!/usr/bin/env bash

function list_working_files() {
  find . \
    -name ".git" -prune -o \
    -name "bundle" -prune -o \
    -name "vendor" -prune -o \
    -name "node_modules" -prune -o \
    -name "cache" -prune -o \
    -name ".cache" -prune -o \
    -name ".mozilla" -prune -o \
    -name ".thunderbird" -prune -o \
    -name ".local" -prune -o \
    -type f -name "tags" -prune -o \
    -type f -name "*.min.*" -prune -o \
    -type f -name "*.pack.*" -prune -o \
    -type f -name "*.map" -prune -o \
    -type f -name "*.index" -prune -o \
    -type f -name "*" \
    -print | sort | sed 's|\./||'
}

function list_text_files() {
  find . \
    -name ".git" -prune -o \
    -name "bundle" -prune -o \
    -name "vendor" -prune -o \
    -name "node_modules" -prune -o \
    -name "cache" -prune -o \
    -name ".cache" -prune -o \
    -name ".mozilla" -prune -o \
    -name ".thunderbird" -prune -o \
    -name ".local" -prune -o \
    -type f -name "tags" -prune -o \
    -type f -name "*.min.*" -prune -o \
    -type f -name "*.pack.*" -prune -o \
    -type f -name "*.map" -prune -o \
    -type f -name "*.index" -prune -o \
    -type f -name "*.jpg" -prune -o \
    -type f -name "*.png" -prune -o \
    -type f -name "*.gif" -prune -o \
    -type f -name "*" \
    -print | sort | sed 's|\./||'
}


function list_recent() {
  find . \
    -name ".git" -prune -o \
    -name "bundle" -prune -o \
    -name "vendor" -prune -o \
    -name "node_modules" -prune -o \
    -name "cache" -prune -o \
    -name ".cache" -prune -o \
    -name ".mozilla" -prune -o \
    -name ".thunderbird" -prune -o \
    -name ".local" -prune -o \
    -type f -name "tags" -prune -o \
    -type f -name "*.min.*" -prune -o \
    -type f -name "*.pack.*" -prune -o \
    -type f -name "*.map" -prune -o \
    -type f -name "*.index" -prune -o \
    -type f -name "*" \
    -printf "%A@ %p\n" | sort -nr | awk '{print $2}' | sed 's|\./||'
}

