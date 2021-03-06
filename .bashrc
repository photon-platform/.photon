#!/usr/bin/env bash

SOURCES=()
SOURCES+=(.path)
SOURCES+=(.exports)
SOURCES+=(.aliases)
SOURCES+=(.functions)
SOURCES+=(tools/_main.sh)
SOURCES+=(ui/_main.sh)
SOURCES+=(sites/_main.sh)

for file in  ${SOURCES[@]}
do
  file="$HOME/.photon/$file"
  [ -r "$file" ] && [ -f "$file" ] && source "$file"
done
unset file

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# enable vi mode for command line
set -o vi

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob
# extended pattern matching
# https://www.gnu.org/software/bash/manual/html_node/Pattern-Matching.html#Pattern-Matching
shopt -s extglob
# Append to the Bash history file, rather than overwriting it
shopt -s histappend
# Autocorrect typos in path names when using `cd`
shopt -s cdspell

# Enable some Bash 4 features when possible:
# * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
# * Recursive globbing, e.g. `echo **/*.txt`
for option in autocd globstar; do
  shopt -s "$option" 2> /dev/null
done;

# prompt should be last
[ -f ~/.photon/.prompt ] && source ~/.photon/.prompt 
