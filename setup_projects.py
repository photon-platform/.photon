import os
import subprocess

# Your personal GitHub account and organizations
accounts = [
    "phiarchitect",
    "geometor",
    "photon-platform",
    "harmonic-resonance",
]

# List of repositories you want to clone for each account
# Replace 'repo_name' with the actual repository names
repos = {
    "phiarchitect": [
        {"name": "phiarchitect", "installed": False},
        {"name": "phiarchitect.com", "installed": False},
        {"name": "ai", "installed": False},
        {"name": "notes", "installed": False},
    ],
    "geometor": [
        {"name": "repo_name1", "installed": False},
        {"name": "repo_name2", "installed": True},
    ],
    "photon-platform": [
        {"name": "repo_name1", "installed": False},
        {"name": "repo_name2", "installed": True},
    ],
    "harmonic-resonance": [
        {"name": "repo_name1", "installed": False},
        {"name": "repo_name2", "installed": True},
    ],
}

# Base directory where repositories will be cloned
base_dir = os.path.expanduser("~/PROJECTS")


# Function to clone and install repositories
def setup_repos(account, repo_list):
    account_dir = os.path.join(base_dir, account)
    os.makedirs(account_dir, exist_ok=True)

    for repo in repo_list:
        repo_name = repo["name"]
        repo_url = f"https://github.com/{account}/{repo_name}.git"
        repo_path = os.path.join(account_dir, repo_name)
        if not os.path.exists(repo_path):
            print(f"Cloning {repo_url}...")
            subprocess.run(["git", "clone", repo_url], cwd=account_dir, check=True)
        if repo["installed"]:
            print(f"Installing {repo_name}...")
            subprocess.run(["pip", "install", "-e", "."], cwd=repo_path, check=True)


# Clone and install repositories for each account
for account in accounts:
    setup_repos(account, repos[account])

print("Finished setting up repositories.")
