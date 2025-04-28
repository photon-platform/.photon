#!/usr/bin/env bash

# Source other utility scripts
source ~/.photon/tools/git/actions.sh
source ~/.photon/tools/git/convert.sh
source ~/.photon/tools/git/submodules/_main.sh

# --- Basic Git Aliases ---
alias gss="git status -sb ."
alias ga="git add ."
alias gc="git commit"
# Removed: alias gac="git add .;git commit" - Replaced by function below
# Removed: alias gacp="git add .;git commit;git push" - Replaced by function below

alias g-df="git diff --cached --submodule"
alias g-df-s="git config --global diff.submodule log"

# --- Core Git Function ---
function tools_git() {
  clear -x
  ui_header "GIT $SEP $PWD"

  folder_siblings
  h2 "$(( siblings_index + 1 )) ${fgg08}of${txReset} $siblings_count"
  show_dir

  gss # Show git status short branch
  echo
  printf " ${fgYellow}tag:${txReset} %s\n" $( gtl ) # Show latest tag

  tools_git_actions # Display available actions (defined in actions.sh)

  tab_title "$PWD" # Set terminal tab title
}
alias G=tools_git # Alias G to the main git tool function

# --- Git Branch ---
function git_branch() {
  # Get the short symbolic ref (branch name).
  # If HEAD isn’t a symbolic ref, get the short SHA for the latest commit.
  # Otherwise, just give up.
  if [ $(git rev-parse --is-inside-work-tree &>/dev/null; echo "${?}") == '0' ]; then
    git symbolic-ref --quiet --short HEAD 2> /dev/null || \
      git rev-parse --short HEAD 2> /dev/null || \
      echo '(unknown)'
  fi
}

# --- Git Tagging Functions ---
function tools_git_tag_delete() {
  local tag_name=$1
  if [ -z "$tag_name" ]; then
    echo "Usage: gtd <tag_name>"
    return 1
  fi
  echo "Deleting local tag '$tag_name'..."
  git tag -d "$tag_name"
  echo "Deleting remote tag '$tag_name'..."
  git push origin --delete "$tag_name"
}
alias gtd=tools_git_tag_delete

function tools_git_tag_add() {
  local tag_name=$1
  if [ -z "$tag_name" ]; then
    echo "Usage: gta <tag_name> [-m 'message']"
    return 1
  fi
  # Pass all arguments to git tag (e.g., -a for annotated, -m for message)
  echo "Creating local tag '$tag_name'..."
  git tag "$@"
  if [ $? -eq 0 ]; then
    echo "Pushing tags to origin..."
    git push origin --tags
  else
    echo "Failed to create local tag."
  fi
}
alias gta=tools_git_tag_add

function tools_git_tag_latest() {
  # Get the latest tag based on version sorting
  git tag --sort=version:refname | tail -n 1
}
alias gtl=tools_git_tag_latest

# --- Git Navigation ---
function g-home() {
  # Find the root directory of the git repository
  git rev-parse --show-toplevel
}
alias g-root='cd "$(g-home)"' # Change directory to git root
alias @=g-root # Short alias for g-root

# --- Git Status Summary ---
function gsss() {
  # Show a compact summary of staged/unstaged file statuses
  if [ $(git rev-parse --is-inside-work-tree &>/dev/null; echo "${?}") == '0' ]; then
    # Get status, take first 3 chars of status code, remove branch line, sort unique, print on one line
    gss | awk '{ print substr($1, 1,3) }' | grep -v "##" | sort | uniq | tr "\n" " "
    echo # Add a newline at the end
  fi
}

# --- Large File Check Function ---
# Checks staged files against a maximum size limit.
function check_large_files() {
  # Define max size: 50 MiB (50 * 1024 * 1024 bytes)
  local max_size_bytes=$((50 * 1024 * 1024))
  # More readable max size for messages
  local max_size_mb="50MB"
  local large_files_found=0
  # Get list of *added* or *modified* files in the staging area (index)
  # We check both A (Added) and M (Modified) as modified files could grow large
  local staged_files
  staged_files=$(git diff --cached --name-only --diff-filter=AM)

  # If no files are staged, no need to check
  if [ -z "$staged_files" ]; then
    return 0 # Success (no large files)
  fi

  echo "Checking staged files for size > ${max_size_mb}..."

  # Process each file found
  # Using process substitution and read loop handles filenames with spaces/special chars
  while IFS= read -r file; do
    # Ensure the file actually exists in the working directory before checking size
    if [ -f "$file" ]; then
      # Get file size in bytes. stat is generally available on Linux/macOS.
      # Use -f "%z" for macOS compatibility, -c "%s" for Linux.
      local file_size
      if [[ "$(uname)" == "Darwin" ]]; then # macOS
          file_size=$(stat -f "%z" "$file")
      else # Linux
          file_size=$(stat -c "%s" "$file")
      fi

      # Check if file size exceeds the maximum allowed size
      if [ "$file_size" -gt "$max_size_bytes" ]; then
        # Print header only once
        if [ "$large_files_found" -eq 0 ]; then
          echo "Error: Found staged files larger than ${max_size_mb}:" >&2 # Print errors to stderr
        fi
        # Try to print human-readable size using numfmt if available, otherwise print bytes
        local human_size
        if command -v numfmt &> /dev/null; then
            human_size=$(numfmt --to=iec-i --suffix=B --format="%.2f" $file_size)
        else
            human_size="${file_size} bytes"
        fi
        echo "  - $file ($human_size)" >&2
        large_files_found=1
      fi
    else
      # This case might happen if a file was staged and then deleted from the working dir
      # We usually don't need to check the size of deleted files in this context.
      # echo "Warning: Staged file '$file' not found in working directory. Skipping size check." >&2
      : # Do nothing
    fi
  done <<< "$staged_files" # Feed the list of files into the loop

  # Check if any large files were detected
  if [ "$large_files_found" -ne 0 ]; then
    echo "Aborting commit due to large files." >&2
    return 1 # Indicate failure
  else
    # echo "No large files found." # Optional success message
    return 0 # Indicate success
  fi
}


# --- Combined Add and Commit Function (replaces gac alias) ---
function gac() {
  echo "Running: git add ."
  git add .
  # Check for large files *after* adding
  if check_large_files; then
    echo "Running: git commit $*"
    # Pass any arguments (like -m "message") to git commit
    git commit "$@"
    return $? # Return the exit status of git commit
  else
    return 1 # Return failure status because large files were found
  fi
}

# --- Combined Add, Commit, and Push Function (replaces gacp alias) ---
function gacp() {
  # Call the gac function, passing all arguments to it
  # This handles git add, the large file check, and git commit
  if gac "$@"; then
    # If gac succeeded (returned 0), then push
    echo "Running: git push"
    git push
    return $? # Return the exit status of git push
  else
    # If gac failed (returned non-zero, e.g., due to large files or commit failure)
    echo "Add, size check, or commit failed. Skipping push." >&2
    return 1 # Indicate overall failure
  fi
}


# --- Git Diff Configuration ---
# Use Git’s colored diff when available
hash git &>/dev/null;
if [ $? -eq 0 ]; then
  # Define a diff function that uses git's color diff even outside a repo
  function diff() {
    git diff --no-index --color-words "$@";
  }
fi;

# --- Git Submodule Aliases ---
alias g-surr="git submodule update --remote --rebase" # Update submodules, rebasing local changes
# alias g-surr-m="git submodule update --remote --merge" # Alternative: merge local changes
alias g-each="git submodule foreach 'git status -sb; echo'" # Run status in each submodule

# --- Git History Reset ---
# DANGEROUS: Function to reset history to a single initial commit
# https://stackoverflow.com/questions/9683279/make-the-current-commit-the-only-initial-commit-in-a-git-repository/13102849#13102849
function g-reset-history() {
  read -p "ARE YOU SURE you want to delete all history and force push? (yes/N): " confirm
  if [[ "$confirm" != "yes" ]]; then
      echo "Aborted."
      return 1
  fi
  echo "Resetting history..."
  git checkout --orphan newBranch
  git add -A  # Add all files and commit them
  git commit -m "Initial commit after history reset"
  git branch -D master  # Deletes the old master branch
  git branch -m master  # Rename the current branch to master
  echo "Force pushing to origin master..."
  git push -fu origin master  # Force push master branch to remote
  echo "Cleaning up old objects..."
  git gc --aggressive --prune=all     # remove the old files
  echo "History reset complete."
}

# --- Optional: Git Completion ---
# Enable tab completion for `g` alias if git completion is installed
# Check if _git function exists and completion file is present
# if type _git &> /dev/null && [ -f /usr/local/etc/bash_completion.d/git-completion.bash ]; then
#   complete -o default -o nospace -F _git g
# fi;

# --- Final Setup ---
# (Any other setup commands can go here)

# echo "Git helper script loaded." # Optional: Confirmation message

