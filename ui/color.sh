#!/bin/bash

# source ~/.photon/color/palette.sh

tput sgr0; # reset colors
bold=$(tput bold);
reset=$(tput sgr0);

black=$(tput setaf 232);
blue=$(tput setaf 33);
cyan=$(tput setaf 37);
green=$(tput setaf 64);
orange=$(tput setaf 166);
purple=$(tput setaf 125);
red=$(tput setaf 124);
violet=$(tput setaf 61);
white=$(tput setaf 15);
yellow=$(tput setaf 136);


# background color using ANSI escape

export bgBlack=$(tput setab 0)
export bgBlackBlack=$(tput setab 232)
export bgRed=$(tput setab 1) 
export bgGreen=$(tput setab 2) 
export bgYellow=$(tput setab 3) # yellow
export bgBlue=$(tput setab 4) # blue
export bgPurple=$(tput setab 5) # magenta
export bgAqua=$(tput setab 6) # cyan
export bgWhite=$(tput setab 7) # white

# foreground color using ANSI escape

export fgBlack=$(tput setaf 0) # black
export fgBlackBlack=$(tput setaf 232) # black
export fgRed=$(tput setaf 1) # red
export fgGreen=$(tput setaf 2) # green
export fgYellow=$(tput setaf 3) # yellow
export fgBlue=$(tput setaf 4) # blue
export fgPurple=$(tput setaf 5) # magenta
export fgAqua=$(tput setaf 6) # cyan
export fgWhite=$(tput setaf 7) # white

# text editing options

export txBold=$(tput bold)   # bold
export txHalf=$(tput dim)    # half-bright
export txUnderline=$(tput smul)   # underline
export txEndUnder=$(tput rmul)   # exit underline
export txReverse=$(tput rev)    # reverse
export txStandout=$(tput smso)   # standout
export txEndStand=$(tput rmso)   # exit standout
export txReset=$(tput sgr0)   # reset attributes
