#!/usr/bin/env bash
# shellcheck disable=SC1090

#  Script: hhs-profile-tools.bash
# Created: Oct 5, 2019
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <http://unlicense.org/>
# !NOTICE: Do not change this file. To customize your functions edit the file ~/.functions

# @function: Lazy load healper function to initialize NVM for the terminal
function __hhs_activate_nvm() {

  echo -en "Activating NVM app ...... "
  # NVM setup
  [[ ! -d "$HOME/.nvm" ]] && __hhs_errcho "${FUNCNAME[0]}: [ FAIL ] => Can't find NVM_DIR => \"$HOME/.nvm\" !" && return 1
  export NVM_DIR="$HOME/.nvm"
  if [[ -s "$NVM_DIR/nvm.sh" ]]; then
    \. "$NVM_DIR/nvm.sh"
    export PATH="$PATH:$NVM_DIR"
    if [[ -s "$NVM_DIR/bash_completion" ]]; then
      \. "$NVM_DIR/bash_completion"
      export HHS_AUTO_COMPLETIONS="$HHS_AUTO_COMPLETIONS NVM"
    fi
    echo "${GREEN}[  OK  ]${NC}"
  else
    __hhs_errcho "${FUNCNAME[0]}: [ FAIL ] => NVM is not installed !" && return 1
  fi
  
  return 0
}

# @function: Lazy load healper function to initialize RVM for the terminal
function __hhs_activate_rvm() {

  echo -en "Activating RVM app ...... "
  # RVM setup
  [[ ! -d "$HOME/.rvm" ]] && __hhs_errcho "${FUNCNAME[0]}: [ FAIL ] => Can't find RVM_HOME => \"$HOME/.rvm\" !" && return 1
  export RVM_DIR="$HOME/.rvm"
  if [[ -s "$RVM_DIR/scripts/rvm" ]]; then
    \. "$RVM_DIR/scripts/rvm"
    export PATH="$PATH:$RVM_DIR/bin"
    echo "${GREEN}[  OK  ]${NC}"
  else
    __hhs_errcho "${FUNCNAME[0]}: [ FAIL ] => RVM is not installed !" && return 1
  fi
  
  return 0
}

# @function: Lazy load healper function to initialize Jenv for the terminal
function __hhs_activate_jenv() {

  echo -en "Activating JENV app ..... "
  # JENV setup
  if eval "$(jenv init -)" &>/dev/null; then
    echo "${GREEN}[  OK  ]${NC}"
  else
    __hhs_errcho "${FUNCNAME[0]}: [ FAIL ] => JENV is not installed!${NC}" && return 1
  fi
  
  return 0
}

# @function: Lazy load healper function to initialize Docker-Daemon for the terminal
function __hhs_activate_docker() {

  echo -en "Activating Docker app ... "
  DK_LOC='/Applications/Docker.app'
  # Docker daemon setup
  if open "${DK_LOC}" &>/dev/null; then
    echo "${GREEN}[  OK  ]${NC}"
  else 
    __hhs_errcho "${FUNCNAME[0]}: [ FAIL ] => Docker.app was not found: ${DK_LOC} at !${NC}" && return 1
  fi
  
  return 0
}
