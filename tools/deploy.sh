# sync everything excluding things in .gitignore
# delete anything on target not in source
# include dotfiles and symlinks, also use compression
# rsync -azP --delete --filter=":- .gitignore" . illumiphi.com:/test-dir
rsync -azP --delete --exclude-from=deploy.exclude ~/webs/port/. illumi48@illumiphi.com:~/test-dir
