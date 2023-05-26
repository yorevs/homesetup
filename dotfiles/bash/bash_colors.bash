#!/usr/bin/env bash
# shellcheck disable=SC1117

#  Script: bash_colors.bash
# Purpose: This file is used to configure shell colors
# Created: Aug 26, 2018
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: homesetup@gmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <https://opensource.org/licenses/MIT>
# !NOTICE: Do not change this file. To customize your colors edit the file ~/.colors

# inspiRED by: https://github.com/mathiasbynens/dotfiles
# improved with: https://misc.flogisoft.com/bash/tip_colors_and_formatting

export HHS_ACTIVE_DOTFILES="${HHS_ACTIVE_DOTFILES} bash_colors"

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
export HHS_HIGHLIGHT_COLOR=${HHS_HIGHLIGHT_COLOR:-$BLUE}

if tput setaf 1 &> /dev/null; then
  # Solarized colors, taken from http://git.io/solarized-colors.
  NC=$(tput sgr0)
  BLACK=$(tput setaf 0)
  RED=$(tput setaf 124)
  GREEN=$(tput setaf 64)
  ORANGE=$(tput setaf 166)
  BLUE=$(tput setaf 33)
  PURPLE=$(tput setaf 61)
  CYAN=$(tput setaf 37)
  GRAY=$(tput setaf 235)
  WHITE=$(tput setaf 15)
  YELLOW=$(tput setaf 136)
  VIOLET=$(tput setaf 125)
else
  # VT100 ANSI colors, taken from https://misc.flogisoft.com/bash/tip_colors_and_formatting
  export NC='\033[0;0;0m'
  export BLACK='\033[0;30m'
  export RED='\033[0;31m'
  export GREEN='\033[0;32m'
  export ORANGE='\033[38;5;202m'
  export BLUE='\033[0;34m'
  export PURPLE='\033[0;35m'
  export CYAN='\033[0;36m'
  export GRAY='\033[38;5;8m'
  export WHITE='\033[0;97m'
  export YELLOW='\033[0;93m'
  export VIOLET='\033[0;95m'
fi
