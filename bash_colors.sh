#!/usr/bin/env bash
# shellcheck disable=SC1117

#  Script: bash_colors.sh
# Purpose: This file is used to configure shell colors
# Created: Aug 26, 2008
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs/homesetup
# !NOTICE: Do not change this file. To customize your aliases edit the file ~/.colors

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

# Setting grep color as RED
export GREP_COLOR='1;31'

if tput setaf 1 &> /dev/null; then
    # Solarized colors, taken from http://git.io/solarized-colors.
    tput sgr0; # NC colors
    NC=$(tput sgr0);
    BOLD=$(tput bold);
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
    # Highlight will affect all HomeSetup functions
    HIGHLIGHT_COLOR=$(tput setaf 33); # Highlight as BLUE
else
    export NC="\e[0m";
    export BOLD='';
    export BLACK="\e[1;30m";
    export BLUE="\e[1;34m";
    export CYAN="\e[1;36m";
    export GREEN="\e[1;32m";
    export ORANGE="\e[1;33m";
    export PURPLE="\e[1;35m";
    export RED="\e[1;31m";
    export VIOLET="\e[1;35m";
    export WHITE="\e[1;37m";
    export YELLOW="\e[1;33m";
    export HIGHLIGHT_COLOR="${BLUE}";
fi;