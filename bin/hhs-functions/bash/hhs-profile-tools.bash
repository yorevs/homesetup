#!/usr/bin/env bash
# shellcheck disable=SC1090

#  Script: hhs-profile-tools.bash
# Created: Oct 5, 2019
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: homesetup@gmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <https://opensource.org/licenses/MIT>
#
# Copyright (c) 2023, HomeSetup team

# !NOTICE: Do not change this file. To customize your functions edit the file ~/.functions

if [[ -d "${HOME}/.nvm" ]]; then
  # @function: Lazy load helper function to initialize NVM for the terminal.
  function __hhs_activate_nvm() {

    echo -en "Activating NVM app ...... "
    # NVM setup
    export NVM_DIR="${HOME}/.nvm"
    if [[ -s "$NVM_DIR/nvm.sh" ]]; then
      __hhs_source "$NVM_DIR/nvm.sh"
      export PATH="$PATH:$NVM_DIR"
      if [[ -s "$NVM_DIR/bash_completion" ]]; then
        ln -sf "$NVM_DIR/bash_completion" "${AUTO_CPL_D}/nvm-completion.bash"
      fi
      echo "${GREEN}[  OK  ]${NC}"
    else
      __hhs_errcho "[ FAIL ] => NVM is not installed !" && return 1
    fi

    return 0
  }
fi

if [[ -d "${HOME}/.rvm" ]]; then
  # @function: Lazy load helper function to initialize RVM for the terminal.
  function __hhs_activate_rvm() {

    echo -en "Activating RVM app ...... "
    # RVM setup
    [[ ! -d "${HOME}/.rvm" ]] || __hhs_errcho "[ FAIL ] => Can't find RVM_HOME => \"${HOME}/.rvm\" !" && return 1
    export RVM_DIR="${HOME}/.rvm"
    if [[ -s "$RVM_DIR/scripts/rvm" ]] && \source "$RVM_DIR/scripts/rvm"; then
      export PATH="$PATH:$RVM_DIR/bin"
      echo "${GREEN}[  OK  ]${NC}"
    else
      __hhs_errcho "[ FAIL ] => RVM is not installed !" && return 1
    fi

    return 0
  }
fi

if __hhs_has jenv; then

  # @function: Lazy load helper function to initialize Jenv for the terminal.
  function __hhs_activate_jenv() {

    echo -en "Activating JENV app ..... "
    # JENV setup
    if eval "$(jenv init -)" &>/dev/null; then
      echo "${GREEN}[  OK  ] ${NC}"
    else
      __hhs_errcho "[ FAIL ] => JENV could not be started !" && return 1
    fi

    return 0
  }
fi

if [[ -n "${HHS_HAS_DOCKER}" ]]; then

  # @function: Lazy load helper function to initialize Docker-Daemon for the terminal.
  function __hhs_activate_docker() {

    echo -en "Activating Docker app ... "
    DK_LOC='/Applications/Docker.app'
    # Docker daemon setup
    if open "${DK_LOC}" &>/dev/null; then
      echo "${GREEN}[  OK  ] ${NC}"
    else
      __hhs_errcho "[ FAIL ] => Docker.app was not found: ${DK_LOC} at !" && return 1
    fi

    return 0
  }
fi
