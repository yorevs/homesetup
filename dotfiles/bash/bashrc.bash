#!/usr/bin/env bash

#  Script: bashrc.bash
# Purpose: This is user specific file that gets loaded each time user creates a new non-login
#          shell. It simply loads the required HomeSetup dotfiles and set some required paths.
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

unset "${!HHS_@}"

export HHS_ACTIVE_DOTFILES='bashrc'

# Load the profile according to the user's SHELL.
case "${SHELL##*\/}" in
  'bash')
    # Source the user profile
    # shellcheck disable=1090
    [[ -s "${HOME}/.hhsrc" ]] && \. "${HOME}/.hhsrc"
    ;;
  *)
    echo ''
    echo 'Sorry ! HomeSetup is only compatible with bash for now.'
    echo 'You can change your default shell by typing: '
    echo "#> sudo chsh -s $(command -v bash)"
    echo ''
    ;;
esac

# Set path so it includes user's private bin if it exists
if [[ -d "${HOME}/bin" ]]; then
  PATH="${PATH}:${HOME}/bin"
fi

# Set path so it includes user's private bin if it exists
if [[ -d "${HOME}/.local/bin" ]]; then
  PATH="${PATH}:${HOME}/.local/bin"
fi
