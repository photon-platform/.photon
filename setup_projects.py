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
