# echo "";
# echo $USER on $HOSTNAME;
# # echo "";
# PS1="\n$(tput setaf 166)\t$(tput sgr0)"
# PS1+=" • "
# PS1+="$(tput setaf 2)\w$(tput sgr0)\n$ ";
# export PS1;
#
# alias dt="cd ~/Desktop"
for file in ~/.{bash_profile}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;

source ~/.bash_profile
source ~/.aliases




export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
