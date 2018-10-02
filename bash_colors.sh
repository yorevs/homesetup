#!/usr/bin/env bash

#  Script: bash_colors.sh
# Purpose: Configure shell and command colors
# Created: Aug 26, 2008
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs/homesetup
#
# Original project: https://github.com/mathiasbynens/dotfiles

# Detect which `ls` flavor is in use
# LS_Colors builder: https://geoff.greer.fm/lscolors/
if ls --color > /dev/null 2>&1; then # GNU `ls`
    colorflag="--color"
    export LS_COLORS='no=00:fi=00:do=01;35:or=40;31;01:di=01;34:ln=36;40:so=35;40:pi=33;40:ex=01;32:bd=40;33;01:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43:'
else # macOS `ls`
    colorflag="-G"
    export CLICOLOR=1
    export LSCOLORS='ExgxfxdxCxegedabagacad'
fi

# TODO Add grep colors

if tput setaf 1 &> /dev/null; then
    tput sgr0; # NC colors
    BOLD=$(tput bold);
    NC=$(tput sgr0);
    # Solarized colors, taken from http://git.io/solarized-colors.
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
    BOLD='';
    NC="\e[0m";
    BLACK="\e[1;30m";
    BLUE="\e[1;34m";
    CYAN="\e[1;36m";
    GREEN="\e[1;32m";
    ORANGE="\e[1;33m";
    PURPLE="\e[1;35m";
    RED="\e[1;31m";
    VIOLET="\e[1;35m";
    WHITE="\e[1;37m";
    YELLOW="\e[1;33m";
fi;

