"""
Setup GitHub Repositories

This script clones and installs a set of GitHub repositories for specified
GitHub accounts into a local directory. The repository information is loaded
from a separate YAML file called 'project_info.yaml'.

The script creates a folder for each account under the '~/PROJECTS' directory,
and clones each repository into its respective account folder. If a repository
is marked as 'installed' in the 'project_info.yaml' file, the script will
install it using `pip install -e .`.

Usage:
    python setup_github_repos.py

Requirements:
    - PyYAML

The 'project_info.yaml' file should have the following format:

```yaml
account_name:
  - name: repository_name
    installed: true/false
  - name: another_repository_name
    installed: true/false
```

Example 'project_info.yaml' content:

```yaml
phiarchitect:
  - name: phiarchitect
    installed: false
  - name: phiarchitect.com
    installed: false
```
"""
import os
import subprocess
import yaml

# Load project information from the YAML file
with open("setup_projects.yaml", "r") as f:
    repos = yaml.safe_load(f)

# Base directory where repositories will be cloned
base_dir = os.path.expanduser("~/PROJECTS")


# Function to clone and install repositories
def setup_repos(account, repo_list):
    account_dir = os.path.join(base_dir, account)
    os.makedirs(account_dir, exist_ok=True)

    for repo in repo_list:
        repo_name = repo["name"]
        print(f"\n\n{account} - {repo_name}\n\n")
        repo_url = f"git@github.com:{account}/{repo_name}"
        repo_path = os.path.join(account_dir, repo_name)
        if not os.path.exists(repo_path):
            print(f"Cloning {repo_url}...")
            subprocess.run(["git", "clone", repo_url], cwd=account_dir, check=True)
            if repo["installed"]:
                print(f"Installing {repo_name}...")
                subprocess.run(["pip", "install", "-e", "."], cwd=repo_path, check=True)


# Clone and install repositories for each account
for account, repo_list in repos.items():
    setup_repos(account, repo_list)

print("Finished setting up repositories.")
