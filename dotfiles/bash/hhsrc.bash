#!/usr/bin/env bash
# shellcheck disable=SC1090,SC1091

#  Script: hhsrc.bash
# Purpose: This file is user specific file that gets loaded each time user creates a new
#          local session i.e. in simple words, opens a new terminal. All environment variables
#          created in this file would take effect every time a new local session is started.
# Created: Apr 29, 2020
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

export HHS_ACTIVE_DOTFILES="${HHS_ACTIVE_DOTFILES} .hhsrc"

# The following variables are not inside the bash_env because we need them in the early load process.
export HHS_HOME="${HOME}/HomeSetup"
export HHS_DIR="${HOME}/.hhs"
export HHS_LOGFILE="${HHS_DIR}/.warnings.log"
export HOME=${HOME:-~/}
export USER=${USER:-$(whoami)}

# The Internal Field Separator (IFS). The default value is <space><tab><newline>
export IFS='
'

# Do not change this formatting, it is required to proper reset IFS to it's defaults

# Load all dotfiles:
#   source -> ~/.path can be used to extend `$PATH`
#   source -> ~/.prompt can be used to extend/override .bash_prompt
#   source -> ~/.aliases can be used to extend/override .bash_aliases
#   source -> ~/.aliasesdef can be used to customize your alias definitions
#   source -> ~/.profile can be used to extend/override .bash_profile/.hhsrc
#   source -> ~/.env can be used to extend/override .bash_env
#   source -> ~/.colors can be used to extend/override .bash_colors
#   source -> ~/.functions can be used to extend/override .bash_functions

# Load all dotfiles following the order. Custom dotfiles comes after the default one, so they can be overriden.
# Notice that the order here is important, do not reorder it.
DOTFILES=(
  'profile' \
  'bash_env' 'env' \
  'bash_colors' 'colors' \
  'bash_prompt' 'prompt' \
  'bash_aliases' 'aliases' 'aliasdef' \
  'bash_functions' 'functions' \
  'bash_completion'
)

# Re-create the HomeSetup log file
echo -e "HomeSetup loaded at $(date)" > "${HHS_LOGFILE}"

# Load all HomeSetup dotfiles
for file in ${DOTFILES[*]}; do
  if [[ -s "${HOME}/.${file}" ]]; then
    echo -e "Loading dotfile: ${HOME}/.${file}" >> "${HHS_LOGFILE}"
    \. "${HOME}/.${file}"
  fi
done

unset file DOTFILES

# -----------------------------------------------------------------------------------
# Set default shell options

HHS_TERM_OPTS=''
case "${HHS_MY_SHELL}" in

  bash)
    # If set, bash matches file names in a case-insensitive fashion when performing pathname expansion.
    shopt -u nocaseglob && HHS_TERM_OPTS+='nocaseglob '
    # If set, the extended pattern matching features described above under Pathname Expansion are enabled.
    shopt -s extglob && HHS_TERM_OPTS+='extglob '
    # If set, minor errors in the spelling of a directory component in a cd command will be corrected.
    shopt -u cdspell && HHS_TERM_OPTS+='cdspell '
    # Make bash check its window size after a process completes
    shopt -s checkwinsize && HHS_TERM_OPTS+='checkwinsize '
    # If set, bash matches patterns in a case-insensitive fashion when  performing  matching while
    # executing case or [[ conditional commands.
    shopt -u nocasematch && HHS_TERM_OPTS+='nocasematch '
    ;;
esac

export HHS_TERM_OPTS

# Input-rc Options:
# - completion-ignore-case: Turns off the case-sensitive completion
# - colored-stats: Displays possible completions using different colors to indicate their type
# - <shift>+<tab> Will cycle forward though complete options

if ! [[ -f ~/.inputrc ]]; then
  {
    echo "set completion-ignore-case on"
    echo "set colored-stats on"
    echo "TAB: complete"
    echo "\"\e[Z\": menu-complete"
  } > ~/.inputrc
else
  case "${HHS_MY_OS}" in
    Darwin)
      sed -i '' -E \
        -e 's/(^set colored-stats) .*/\1 on/g' \
        -e 's/(^set completion-ignore-case) .*/\1 on/g' \
        -e 's/(^TAB:) .*/\1 complete/g' \
        -e 's/(^\"\e\[Z\":) .*/\1 menu-complete/g' \
        ~/.inputrc
      ;;
    Linux)
      sed -i'' -r \
        -e 's/(^set colored-stats) .*/\1 on/g' \
        -e 's/(^set completion-ignore-case) .*/\1 on/g' \
        -e 's/(^TAB:) .*/\1 complete/g' \
        -e 's/(^\"\e\[Z\":) .*/\1 menu-complete/g' \
        ~/.inputrc
      ;;
  esac
fi

# Add `$HHS_DIR/bin` to the system `$PATH`
__hhs_paths -q -a "${HHS_DIR}/bin"

# Add custom paths to the system `$PATH`
if [[ -f "${HOME}/.path" ]]; then
  PATH="$(grep . "${HOME}/.path" | tr '\n' ':'):$PATH"
  export PATH
fi

# Check for updates
if [[ ! -f "${HHS_DIR}/.last_update" || $(date "+%s%S") -ge $(grep . "${HHS_DIR}/.last_update") ]]; then
  echo -e "${GREEN}Home setup is checking for updates ..."
  hhs updater execute --check
fi

# Print HomeSetup MOTD
echo ''
echo -e "${HHS_MOTD}${NC}"
echo ''
