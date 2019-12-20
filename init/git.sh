#!/bin/sh


# set account
git config --global user.name "i-am-phi"
git config --global user.email "illumiphi@gmail.com"


git config --global credential.helper cache
# Set git to use the credential memory cache
git config --global credential.helper 'cache --timeout=3600'
# Set the cache to timeout after 1 hour (setting is in seconds)

git config --list

