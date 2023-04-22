if [ -z "$SSH_AUTH_SOCK" ]; then
   eval "$(ssh-agent -s)"
   ssh-add ~/.ssh/id_ed25519
fi

error: cannot format -: Cannot parse: 1:8: if [ -z "$SSH_AUTH_SOCK" ]; then
