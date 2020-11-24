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

export fgg00=$(tput setaf 232) # black
export fgg01=$(tput setaf 233) # black
export fgg02=$(tput setaf 234) # black
export fgg03=$(tput setaf 235) # black
export fgg04=$(tput setaf 236) # black
export fgg05=$(tput setaf 237) # black
export fgg06=$(tput setaf 238) # black
export fgg07=$(tput setaf 239) # black
export fgg08=$(tput setaf 240) # black
export fgg09=$(tput setaf 241) # black
export fgg10=$(tput setaf 242) # black
export fgg11=$(tput setaf 243) # black
export fgg12=$(tput setaf 243) # black
export fgg13=$(tput setaf 244) # black
export fgg14=$(tput setaf 245) # black
export fgg15=$(tput setaf 246) # black
export fgg16=$(tput setaf 247) # black
export fgg17=$(tput setaf 248) # black
export fgg18=$(tput setaf 249) # black
export fgg19=$(tput setaf 250) # black
export fgg20=$(tput setaf 251) # black
export fgg21=$(tput setaf 252) # black
export fgg22=$(tput setaf 253) # black
export fgg23=$(tput setaf 254) # black
export fgg24=$(tput setaf 255) # black
