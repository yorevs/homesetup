#!/usr/bin/env bash

#  Script: bashrc.sh
# Purpose: Shell configuration main entry point file
# Created: Aug 26, 2008
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs/homesetup

# If not running interactively, don't do anything.
[ -z "$PS1" ] && return

# Source global definitions
if [ -f /etc/bashrc ]
then
    # shellcheck disable=SC1091
    source /etc/bashrc
fi

# Source the main profile
if [ -n "$PS1" ] && [ -f ~/.bash_profile ]
then
    # shellcheck disable=SC1090
    source ~/.bash_profile
fi
