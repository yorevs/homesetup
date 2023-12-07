#!/usr/bin/env bash

#  Script: bash_profile.bash
# Purpose: This is user specific file that gets loaded each time user creates a new non-login
#          shell. It simply loads the required HomeSetup dotfiles and set some required paths.
# Created: Aug 26, 2018
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: homesetup@gmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <https://opensource.org/licenses/MIT>
#
# Copyright (c) 2023, HomeSetup team

# !NOTICE: Do not change this file. To customize your shell create/change the following files:
#   ~/.colors     : To customize your colors
#   ~/.env        : To customize your environment variables
#   ~/.aliases    : To customize your aliases
#   ~/.aliasdef   : To customize your aliases definitions
#   ~/.prompt     : To customize your prompt
#   ~/.functions  : To customize your functions
#   ~/.profile    : To customize your profile
#   ~/.path       : To customize your paths

# Unset all HHS_ variables
unset "${!HHS_@}"

# If not running interactively and if it is not a Jenkins build, skip it.
[[ -z "${JOB_NAME}" && -z "${PS1}" && -z "${PS2}" ]] && return

export HHS_ACTIVE_DOTFILES='bashrc'

# Load the profile according to the user's SHELL.
case "${SHELL##*\/}" in
  'bash')
    [[ -s "${HOME}/.hhsrc" ]] && source "${HOME}/.hhsrc"
    ;;
  *)
    echo ''
    echo "Sorry ! HomeSetup is not compatible with ${SHELL##*\/} for now."
    echo 'You can change your default shell by typing: '
    echo "$ sudo chsh -s $(command -v bash)"
    echo ''
    ;;
esac
