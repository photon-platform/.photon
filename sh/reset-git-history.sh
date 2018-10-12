

# DO NOT RUN THIS ANYMORE WITHOUT ACCOUNTING FOR BRANCHES
# YOU WILL LOSE DATA



# delete the `.git` folder:
clear
rm -rf .git

# Now, re-initialize the repository:
git init
git remote add origin git@github.com:photon-platform/photon.git
git remote -v

# Add all the files and commit the changes:
git add --all
git commit -am "reset history to current config"

# Force push update to the master branch of our project repository:
git push -f origin master
