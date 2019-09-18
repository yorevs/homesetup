#!/usr/bin/env bash
# shellcheck disable=SC1117

#  Script: bash_colors.sh
# Purpose: This file is used to configure shell colors
# Created: Aug 26, 2008
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <http://unlicense.org/>
# !NOTICE: Do not change this file. To customize your colors edit the file ~/.colors

# inspiRED by: https://github.com/mathiasbynens/dotfiles
# improved with: https://misc.flogisoft.com/bash/tip_colors_and_formatting

# Detect which `ls` flavor is in use
# LS_Colors builder: https://geoff.greer.fm/lscolors/
# Items:
#   di: Directory      bd: Block special
#   ln: Link           cd: Char special
#   so: Socket         su: Exe setuid
#   pi: Pipe           sg: Exe setgid
#   ex: Executable     tw: Dir. write others(sticky)
#                      ow: Dir. write others(no-sticky)
#

if ls --color &> /dev/null; then # GNU `ls`
    export COLOR_FLAG="--color"
    export LS_COLORS='di=1;34:ln=1;36:so=35:pi=33:ex=1;32:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43'
else # macOS `ls`
    export COLOR_FLAG="-G"
    export CLICOLOR=1
    export LSCOLORS='ExGxfxdxCxegedabagacad'
fi

# Setting grep color: Default is RED
export GREP_COLOR=${GREP_COLOR:-'1;31'}
# Color used to highlight text: Default is BLUE
export HIGHLIGHT_COLOR=${HIGHLIGHT_COLOR:-$BLUE};

if tput setaf 1 &> /dev/null; then
    # Solarized colors, taken from http://git.io/solarized-colors.
    tput sgr0; # NC colors
    NC=$(tput sgr0);
    BOLD=$(tput bold);
    DIM=$(tput dim);
    BLACK=$(tput setaf 0);
    BLUE=$(tput setaf 33);
    CYAN=$(tput setaf 37);
    GREEN=$(tput setaf 64);
    ORANGE=$(tput setaf 166);
    PURPLE=$(tput setaf 125);
    RED=$(tput setaf 124);
    VIOLET=$(tput setaf 61);
    WHITE=$(tput setaf 15);
    YELLOW=$(tput setaf 136);
else
    export NC=${NC:-'\e[0m'};
    export BOLD=${BOLD:-'\e[1m'};
    export DIM=${BOLD:-'\e[4m'};
    export BLACK=${BLACK:-'\e[1;30m'};
    export BLUE=${BLUE:-'\e[1;34m'};
    export CYAN=${CYAN:-'\e[1;36m'};
    export GREEN=${GREEN:-'\e[1;32m'};
    export ORANGE=${ORANGE:-'\e[1;33m'};
    export PURPLE=${PURPLE:-'\e[1;35m'};
    export RED=${RED:-'\e[1;31m'};
    export VIOLET=${VIOLET:-'\e[1;35m'};
    export WHITE=${WHITE:-'\e[1;37m'};
    export YELLOW=${YELLOW:-'\e[1;33m'};
fi;