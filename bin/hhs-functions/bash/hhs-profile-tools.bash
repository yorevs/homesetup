#!/usr/bin/env bash
# shellcheck disable=SC1090

#  Script: hhs-profile-tools.bash
# Created: Oct 5, 2019
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <http://unlicense.org/>
# !NOTICE: Do not change this file. To customize your functions edit the file ~/.functions

# @function: TODO: Comment it
function __hhs_activate-nvm() {

  echo -en "Activating NVM app ...... "
  # NVM setup
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
function __hhs_activate-rvm() {

  echo -en "Activating RVM app ...... "
  # RVM setup
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
function __hhs_activate-jenv() {

  echo -en "Activating JENV app ..... "
  # JENV setup
  eval "$(jenv init -)" &>/dev/null \
    && echo "${GREEN}[  OK  ]${NC}" \
    || echo -e "${RED}[ FAIL ] => JENV is not installed!${NC}"
  return $?
}

# @function: TODO: Comment it
function __hhs_activate-docker() {

  echo -en "Activating Docker app ... "
  DK_LOC='/Applications/Docker.app'
  # Docker daemon setup
  open "${DK_LOC}" &>/dev/null \
    && echo "${GREEN}[  OK  ]${NC}" \
    || echo -e "${RED}[ FAIL ] => Docker.app wa not found: ${DK_LOC} at !${NC}"
  return $?
}
