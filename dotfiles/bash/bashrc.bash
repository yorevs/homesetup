#!/usr/bin/env bash
# shellcheck disable=SC1090,SC1091

#  Script: bashrc.bash
# Purpose: This file is user specific file that gets loaded each time user creates a new
#          local session i.e. in simple words, opens a new terminal. All environment variables
#          created in this file would take effect every time a new local session is started.
# Created: Aug 26, 2018
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <https://opensource.org/licenses/MIT>
#
# !NOTICE: Do not change this file. To customize your shell create/change the following files:
#   ~/.colors     : To customize your colors
#   ~/.env        : To customize your environment variables
#   ~/.aliases    : To customize your aliases
#   ~/.aliasdef   : To customize your aliases definitions
#   ~/.prompt     : To customize your prompt
#   ~/.functions  : To customize your functions
#   ~/.profile    : To customize your profile
#   ~/.path       : To customize your paths

# If not running interactively, don't load anything.
[[ -z "$PS1" && -z "$PS2" ]] && return

# Re-reate the warnings file
:> "${HHS_WARNINGS_FILE}"

# The Internal Field Separator (IFS). The default value is <space><tab><newline>
export IFS=' 	
'
# Do not change this formatting, it is required to proper reset IFS to it's defaults

# Load the profile according to the SHELL defined
case "${SHELL##*\/}" in
  bash)
    # Source the main profile
    [[ -s /etc/bashrc ]] && source /etc/bashrc
    
    # Source the user profile
    [[ -s "${HOME}/.bash_profile" ]] && source "${HOME}/.bash_profile"
    ;;
  *)
    echo ''
    echo 'Sorry ! HomeSetup is only compatible with bash for now.'
    echo 'You can change your default shell by typing: '
    echo '#> sudo chsh -s /bin/bash'
    echo ''
    ;;
esac

# Erase what is before the MOTD message and print HHS MOTD
# echo -e "\033[1J\033[H${HHS_MOTD}${NC}"
echo -e "${HHS_MOTD}${NC}"

# Print any warning messages
if [[ "${HHS_SHOW_WARNINGS}" -eq 1 \
  && -f "${HHS_WARNINGS_FILE}" ]]; then
    echo ''
    echo -e "${ORANGE}HomeSetup loaded with the following warnings:${NC}"
    echo "${YELLOW}"
    head "${HHS_WARNINGS_FILE}"
    echo "${NC}"
fi
