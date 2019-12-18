#!/usr/bin/env bash
# shellcheck disable=SC1090

#  Script: hhs-dev-tools.bash
# Created: Oct 5, 2019
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <http://unlicense.org/>
# !NOTICE: Do not change this file. To customize your functions edit the file ~/.functions

# @function: TODO: Comment it
function activate-nvm() {

  echo -en "Activating NVM app .... "
  # NVM Setup
  export NVM_DIR="$HOME/.nvm"
  if [ -s "$NVM_DIR/nvm.sh" ]; then
    \. "$NVM_DIR/nvm.sh"
    export PATH="$PATH:$NVM_DIR"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
    export HHS_AUTO_COMPLETIONS="$HHS_AUTO_COMPLETIONS NVM"
    echo "${GREEN}[  OK  ]${NC}"
    return 0
  else
    echo -e "${RED}[ FAIL ] => NVM is not installed!${NC}"
    return 1
  fi
}

# @function: TODO: Comment it
function activate-rvm() {

  echo -en "Activating RVM app .... "
  # RVM Setup
  export RVM_DIR="$HOME/.rvm"
  if [ -s "$HOME/.rvm/scripts/rvm" ]; then
    \. "$HOME/.rvm/scripts/rvm"
    export PATH="$PATH:$RVM_DIR/bin"
    echo "${GREEN}[  OK  ]${NC}"
    return 0
  else
    echo -e "${RED}[ FAIL ] => RVM is not installed!${NC}"
    return 1
  fi
}

# @function: TODO: Comment it
function activate-jenv() {

  echo -en "Activating JENV app ... "
  # JENV Setup
  eval "$(jenv init -)" &>/dev/null \
    && echo "${GREEN}[  OK  ]${NC}" \
    || echo -e "${RED}[ FAIL ] => JENV is not installed!${NC}"
  return $?
}
