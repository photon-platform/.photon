#!/usr/bin/env bash

SOURCES=()
SOURCES+=(.path)
SOURCES+=(.exports)
SOURCES+=(.aliases)
SOURCES+=(.functions)
SOURCES+=(tools/_main.sh)
SOURCES+=(ui/_main.sh)
SOURCES+=(shell/_main.sh)
SOURCES+=(hosts/_main.sh)
SOURCES+=(sites/_main.sh)
# prompt should be last
SOURCES+=(.prompt)

for file in  ${SOURCES[@]}
do
  file="$HOME/.photon/$file"
  # echo $file
  [ -r "$file" ] && [ -f "$file" ] && source "$file"
done

unset file

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

#determines search program for fzf
if type ag &> /dev/null; then
    export FZF_DEFAULT_COMMAND='ag -p ~/.gitignore -g ""'
fi

# Enable some Bash 4 features when possible:
# * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
# * Recursive globbing, e.g. `echo **/*.txt`
for option in autocd globstar; do
  shopt -s "$option" 2> /dev/null
done;

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
# [ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh

