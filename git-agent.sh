#!/usr/bin/env bash
if [ -z "$SSH_AUTH_SOCK" ]; then
   # eval "$(ssh-agent -s)"
   eval `ssh-agent`
   ssh-add ~/.ssh/id_ed25519
fi

