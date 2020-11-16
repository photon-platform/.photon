#!/usr/bin/env bash

source ~/.photon/tools/git/actions.sh
source ~/.photon/tools/git/submodules/_main.sh


alias gss="git status -sb ."
alias ga="git add ."
alias gc="git commit"
alias gac="git add .;git commit"
alias gacp="git add .;git commit;git push"

alias g-df="git diff --cached --submodule"
alias g-df-s="git config --global diff.submodule log"

function tools_git() {

  clear
  ui_header "tools * GIT"
  tab_title "tools * GIT"

  printf " %s\n" $( pwd )
  printf " tag: %s\n" $( gtl )
  echo
  gss
  echo

  tools_git_actions

  tab_title "$PWD"
}
alias G=tools_git

function tools_git_tag_delete() {
  git tag -d $1
  git push origin --delete $1
}
alias gtd=tools_git_tag_delete

function tools_git_tag_add() {
  git tag -a $1
  git push origin --tags
}
alias gta=tools_git_tag_add

function tools_git_tag_latest() {
  git tag | sort | tail -n 1
}
alias gtl=tools_git_tag_latest

function g-home() {
  git rev-parse --show-toplevel
}
alias g-root='cd "$(g-home)"'
alias @=g-root

# git summary summary
function gsss() {
  gss | awk '{ print substr($1, 1,3) }' | grep -v "##" | sort | uniq -c
}

# Enable tab completion for `g` by marking it as an alias for `git`
# if type _git &> /dev/null && [ -f /usr/local/etc/bash_completion.d/git-completion.bash ]; then
  # complete -o default -o nospace -F _git g
# fi;

# Use Git’s colored diff when available
hash git &>/dev/null;
if [ $? -eq 0 ]; then
  function diff() {
    git diff --no-index --color-words "$@";
  }
fi;

alias g-surr="git submodule update --remote --rebase" #or --merge
alias g-each="git submodule foreach 'git status -sb; echo'"

# https://stackoverflow.com/questions/9683279/make-the-current-commit-the-only-initial-commit-in-a-git-repository/13102849#13102849
function g-reset-history() {
  git checkout --orphan newBranch
  git add -A  # Add all files and commit them
  git commit
  git branch -D master  # Deletes the master branch
  git branch -m master  # Rename the current branch to master
  git push -fu origin master  # Force push master branch to github
  git gc --aggressive --prune=all     # remove the old files

}
