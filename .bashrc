
for file in ~/.{bash_profile}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;

source ~/.bash_profile
source ~/.aliases




export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
