#!/usr/bin/env bash

source ~/.photon/tools/git/submodules/actions.sh
source ~/.photon/tools/git/submodules/add.sh
source ~/.photon/tools/git/submodules/remove.sh

function tools_git_submodules() {

  clear -x

  repo_home=$(g-home)

  ui_header "GIT $SEP SUBMODULES $SEP $repo_home"
  echo 

  gm="$repo_home/.gitmodules"
  if [[ -f $gm ]]
  then
    echo

    old_dir=$(pwd)
    mapfile -t subs < <( awk '/^\s*path/ {print $3}' "${gm}" | sort )
    for (( i = 0; i <  ${#subs[@]}; i++ )); do
      sub_path="${subs[$i]}"
      sub_dir="${repo_home}/${sub_path}"
      cd "${sub_dir}"
      ui_list_item_number $i "${sub_path} ${fgRed}$(git branch)${txReset}"
      git status -s
    done
    cd $old_dir

    tools_git_submodules_actions
  fi

  tab_title "$PWD"
}



# tools for git submodules
function tools_git_submodules_fetch() {
  old_dir=$(pwd)
  for (( i = 0; i <  ${#subs[@]}; i++ )); do
    sub_path="${subs[$i]}"
    sub_dir="${repo_home}/${sub_path}"
    cd "${sub_dir}"
    ui_list_item_number $i "${sub_path} ${fgRed}$(git branch)${txReset}"
    git fetch
    git status -s
  done
  cd $old_dir
}

function tools_git_submodules_master() {
  old_dir=$(pwd)
  for (( i = 0; i <  ${#subs[@]}; i++ )); do
    sub_path="${subs[$i]}"
    sub_dir="${repo_home}/${sub_path}"
    cd "${sub_dir}"
    ui_list_item_number $i "${sub_path} ${fgRed}$(git branch)${txReset}"
    git checkout master;
    git status -s
  done
  cd $old_dir
}

function tools_git_submodules_update() {
  old_dir=$(pwd)
  for (( i = 0; i <  ${#subs[@]}; i++ )); do
    sub_path="${subs[$i]}"
    sub_dir="${repo_home}/${sub_path}"
    cd "${sub_dir}"
    ui_list_item_number $i "${sub_path} ${fgRed}$(git branch)${txReset}"
    git pull;
    git checkout master;
    git status -s
  done
  cd $old_dir
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
