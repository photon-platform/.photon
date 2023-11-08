import subprocess
import sys
from pathlib import Path


def run_command(command):
    process = subprocess.Popen(
        command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=True
    )
    stdout, stderr = process.communicate()
    return stdout.decode().strip(), stderr.decode().strip()


def init_github_repo():
    # Get the parent folder name as repository name and GitHub username
    repo_path = Path.cwd()
    repo_name = repo_path.name
    github_user = repo_path.parent.name

    # Initialize local Git repository
    print("Initializing local Git repository...")
    run_command(f"git init")

    # Add and commit all files
    run_command(f"git add .")
    run_command(f"git commit -m 'Initial commit'")

    # Create remote GitHub repository using the GitHub CLI
    print("Creating remote GitHub repository...")
    stdout, stderr = run_command(f"gh repo create {github_user}/{repo_name} --public")
    if stderr:
        print("Error:")
        print(stderr)
        sys.exit(1)

    # Set the remote origin for the local Git repository and push
    print("Connecting local and remote repositories...")
    run_command(f"git remote add origin git@github.com:{github_user}/{repo_name}.git")
    run_command(f"git branch -M main")
    run_command(f"git push -u origin main")

    print(f"Repository setup complete: https://github.com/{github_user}/{repo_name}")


if __name__ == "__main__":
    init_github_repo()
