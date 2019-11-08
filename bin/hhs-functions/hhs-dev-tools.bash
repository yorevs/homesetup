#!/usr/bin/env bash
# shellcheck disable=SC1090

#  Script: hhs-dev-tools.bash
# Created: Oct 5, 2019
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <http://unlicense.org/>
# !NOTICE: Do not change this file. To customize your functions edit the file ~/.functions

function activate-nvm() {
  echo -en "Activating NVM app ... "
  # NVM Setup
  export NVM_DIR="$HOME/.nvm"
  if [ -s "$NVM_DIR/nvm.sh" ]; then
    \. "$NVM_DIR/nvm.sh"
    export PATH="$PATH:$NVM_DIR"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
    echo '[ OK ]'
  else
    echo -e "NVM is not installed!"
  fi
}

function activate-rvm() {
  echo -en "Activating RVM app ... "
  # RVM Setup
  export RVM_DIR="$HOME/.rvm"
  if [ -s "$HOME/.rvm/scripts/rvm" ]; then
    \. "$HOME/.rvm/scripts/rvm"
    export PATH="$PATH:$RVM_DIR/bin"
    echo '[ OK ]'
  else
    echo -e "RVM is not installed!"
  fi
}
