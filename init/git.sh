#!/bin/sh


# set account
git config --global user.name "phi-architect"
git config --global user.email "phi@phiarchitect.com"


git config --global credential.helper cache
# Set git to use the credential memory cache
git config --global credential.helper 'cache --timeout=10000000'
# Set the cache to timeout after 1 hour (setting is in seconds)

git config --list

