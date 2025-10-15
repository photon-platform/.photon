#!/usr/bin/env bash

SOURCES=()
SOURCES+=(.path)
SOURCES+=(.exports)
SOURCES+=(.aliases)
SOURCES+=(.functions)
SOURCES+=(tools/_main.sh)
SOURCES+=(ui/_main.sh)
SOURCES+=(sites/_main.sh)
SOURCES+=(aider/aider.sh)


for file in  ${SOURCES[@]}
do
  file="$HOME/.photon/$file"
  [ -r "$file" ] && [ -f "$file" ] && source "$file"
done
unset file

source $HOME/.private/google.env
source $HOME/.private/openai.env
source $HOME/.private/github.env
source $HOME/.private/codestral.env
source $HOME/.private/elevenlabs.env
source $HOME/.private/x.env
source $HOME/.private/anthropic.env
source $HOME/.private/google.env

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

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# Shell-GPT integration BASH v0.2
_sgpt_bash() {
if [[ -n "$READLINE_LINE" ]]; then
    READLINE_LINE=$(sgpt --shell <<< "$READLINE_LINE" --no-interaction)
    READLINE_POINT=${#READLINE_LINE}
fi
}
bind -x '"\C-l": _sgpt_bash'

# reset ssh
eval "$(ssh-agent -s)"
# ssh-add ~/.ssh/id_github
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

export PATH="$PATH:/opt/nvim-linux-x86_64/bin"

export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
