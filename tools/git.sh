#!/usr/bin/env bash

alias g-root='cd $(git rev-parse --show-toplevel)'
alias @=g-root

alias gss="git status -sb ."
alias ga="git add ."
alias gc="git commit"
alias gac="git add .;git commit"
alias gacp="git add .;git commit;git push"

alias g-df="git diff --cached --submodule"
alias g-df-s="git config --global diff.submodule log"

function g-home() {
  echo $(git rev-parse --show-toplevel)
}

# git summary summary
function gsss() {
  gss | awk '{ print substr($1, 1,3) }' | grep -v "##" | sort | uniq -c
}

# Enable tab completion for `g` by marking it as an alias for `git`
if type _git &> /dev/null && [ -f /usr/local/etc/bash_completion.d/git-completion.bash ]; then
  complete -o default -o nospace -F _git g
fi;

# Use Git’s colored diff when available
hash git &>/dev/null;
if [ $? -eq 0 ]; then
  function diff() {
    git diff --no-index --color-words "$@";
  }
fi;

alias g-surr="git submodule update --remote --rebase" #or --merge
alias g-each="git submodule foreach 'git status -sb; echo'"

# create submodule from existing folder
alias sub_plug="~/.photon/sh/sub_plug.sh"
alias sub_theme="~/.photon/sh/sub_theme.sh"


# tools for git submodules
gsub() {

  if [ $1 ]
  then
    case $1 in

      fetch)
        git submodule foreach " \
          git fetch; \
          git status -sb; \
          echo"
        ;;

      master)
        git submodule foreach " \
          git checkout master; \
          git status -sb; \
          echo"
        ;;

      update)
        # check for outstanding changes before update
        # git submodule update --remote
        git submodule foreach " \
          git pull; \
          git checkout master; \
          git status -sb; \
          echo"
        ;;

      *)
        echo "Enter options: gsub [acmp|fetch|update]"
        ls
        ;;
    esac
  else
    # default status each
    git submodule foreach 'git status -sb; echo'
  fi

}

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