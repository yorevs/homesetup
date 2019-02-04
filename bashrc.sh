#!/usr/bin/env bash
# shellcheck disable=SC1090,SC1091

#  Script: bashrc.sh
# Purpose: This file is user specific file that gets loaded each time user creates a new 
#          local session i.e. in simple words, opens a new terminal. All environment variables 
#          created in this file would take effect every time a new local session is started.
# Created: Aug 26, 2008
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs/homesetup
#
# !NOTICE: Do not change this file. To customize your shell create/change the following files: 
#   .aliases    : To customize your aliases
#   .colors     : To customize your colors
#   .env        : To customize your environment variables
#   .functions  : To customize your functions
#   .profile    : To customize your profile
#   .prompt     : To customize your prompt
#   .path       : To customize your paths

# If not running interactively, don't do anything.
[ -z "$PS1" ] && return

# Source global definitions
if [ -s /etc/bashrc ]; then
    \. /etc/bashrc
fi

# Source the main profile
if [ -s "$HOME/.bash_profile" ]; then
    \. "$HOME/.bash_profile"
fi

# Make bash check its window size after a process completes
shopt -s checkwinsize