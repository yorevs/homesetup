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
#   ~/.hhs/.colors     : To customize your colors
#   ~/.hhs/.env        : To customize your environment variables
#   ~/.hhs/.aliases    : To customize your aliases
#   ~/.hhs/.aliasdef   : To customize your aliases definitions
#   ~/.hhs/.prompt     : To customize your prompt
#   ~/.hhs/.functions  : To customize your functions
#   ~/.hhs/.profile    : To customize your profile
#   ~/.hhs/.path       : To customize your paths

export HHS_ACTIVE_DOTFILES="${HHS_ACTIVE_DOTFILES} hhsrc"

# Unset all aliases before setting them again.
unalias -a

# The following variables are not inside the bash_env because we need them in the early load process.
export HHS_HOME="${HOME}/HomeSetup"
export HHS_DIR="${HOME}/.hhs"
export HHS_LOGFILE="${HHS_DIR}/hhsrc.log"
export HOME=${HOME:-~/}
export USER=${USER:-$(whoami)}

# Do not change this formatting, it is required to proper reset IFS to it's defaults

# Load all dotfiles:
#   source -> ~/.hhs/.path can be used to extend `$PATH`
#   source -> ~/.hhs/.prompt can be used to extend/override .bash_prompt
#   source -> ~/.hhs/.aliases can be used to extend/override .bash_aliases
#   source -> ~/.hhs/.aliasdef can be used to customize your alias definitions
#   source -> ~/.hhs/.profile can be used to extend/override .bash_profile/.hhsrc
#   source -> ~/.hhs/.env can be used to extend/override .bash_env
#   source -> ~/.hhs/.colors can be used to extend/override .bash_colors
#   source -> ~/.hhs/.functions can be used to extend/override .bash_functions

# Load all dotfiles following the order.
# Notice that the order here is important, do not reorder it.
DOTFILES=(
  'bash_env'
  'bash_colors' 
  'bash_prompt'
  'bash_aliases'
  'bash_functions'
  'bash_completion'
  'profile'
)

# Custom dotfiles comes after the default one, so they can be overriden.
CUSTOM_DOTFILES=(
   'env'
   'colors'
   'prompt'
   'aliases'
   'aliasdef'
   'functions'
)


# Re-create the HomeSetup log file
echo -e "HomeSetup loaded at $(date)\n" > "${HHS_LOGFILE}"

# @function: Log a message to the HomeSetup log file.
# @param $1 [Req] : The log level.
# @param $* [Req] : The log message.
function __hhs_log() {
  local level="${1}" message="${2}"
  if [[ $# -eq 0 || '-h' == "$1" ]]; then
    echo "Usage: ${FUNCNAME[0]} <log_level> <log_message>"
    return 1
  fi
  case "${level}" in
    'DEBUG' | 'INFO' | 'WARN' | 'ERROR' | 'ALL')
      printf "%s %5.5s  %s\n" "$(date +'%m-%d-%y %H:%M-%S ')" "${level}" "${message}" >> "${HHS_LOGFILE}"
      ;;
    *)
      echo "${FUNCNAME[0]}: invalid log level \"${level}\" !" 2>&1
      ;;
  esac
}

# @function: Replacement for the source bash command
# @param $1 [Req] : Path to the file to be source'd
function __hhs_source() {

  local filepath="$1"
  
  if [[ $# -eq 0 || '-h' == "$1" ]]; then
    echo "Usage: ${FUNCNAME[0]} <filepath>"
    return 1
  fi
  if [[ ! -f "${filepath}" ]]; then
    __hhs_log "ERROR" "${FUNCNAME[0]}: File \"${filepath}\" not found !"
  else
    if ! grep "File \"${filepath}\" was sourced !" "${HHS_LOGFILE}"; then
      if source "${filepath}" 2>> "${HHS_LOGFILE}"; then
        __hhs_log "INFO" "File \"${filepath}\" was sourced !"
      else
        __hhs_log "ERROR" "File \"${filepath}\" was not sourced !"
      fi
    else
      __hhs_log "WARN" "File \"${filepath}\" was already sourced !"
    fi
  fi
}

# @function: Whether an URL is reachable
# @param $1 [Req] : The URL to test reachability
function __hhs_is_reachable() {
  curl --output /dev/null --silent --connect-timeout 1 --max-time 2 --head --fail "${1}"
  return $?
}

# Load all HomeSetup dotfiles.
# shellcheck disable=SC2048
for file in ${DOTFILES[*]}; do
  f_path="${HOME}/.${file}"
  if [[ -f "${f_path}" ]]; then
    __hhs_log "INFO" "Loading dotfile: ${f_path}"
    __hhs_source "${f_path}"
  else
    __hhs_log "WARN" "Skipped dotfile :: Not found -> ${f_path}"
  fi
done

# Load all Custom dotfiles.
# shellcheck disable=SC2048
for file in ${CUSTOM_DOTFILES[*]}; do
  f_path="${HHS_DIR}/.${file}"
  if [[ -f "${f_path}" ]]; then
    __hhs_log "INFO" "Loading custom dotfile: ${f_path}"
    __hhs_source "${f_path}"
  else
    __hhs_log "WARN" "Skipped custom dotfile :: Not found -> ${f_path}"
  fi
done

unset file f_path DOTFILES

# -----------------------------------------------------------------------------------
# Set default shell options

HHS_TERM_OPTS=''
case "${HHS_MY_SHELL}" in
  bash)
    # If set, bash matches file names in a case-insensitive fashion when performing pathname expansion.
    shopt -u nocaseglob && HHS_TERM_OPTS+=''
    # If set, the extended pattern matching features described above under Pathname Expansion are enabled.
    shopt -s extglob && HHS_TERM_OPTS+='extglob '
    # If set, minor errors in the spelling of a directory component in a cd command will be corrected.
    shopt -u cdspell && HHS_TERM_OPTS+=''
    # Make bash check its window size after a process completes
    shopt -s checkwinsize && HHS_TERM_OPTS+='checkwinsize '
    # If set, bash matches patterns in a case-insensitive fashion when  performing  matching while
    # executing case or [[ conditional commands.
    shopt -u nocasematch && HHS_TERM_OPTS+=''
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
if [[ -f "${HHS_DIR}/.path" ]]; then
  NEW_PATHS="$(grep . "${HHS_DIR}/.path" | grep -v -e '^$')"
  NEW_PATHS=${NEW_PATHS//'\n'/':'/}
  PATH="${PATH}:${NEW_PATHS}"
fi

PATH=$(awk -F: '{for (i=1;i<=NF;i++) { if ( !x[$i]++ ) printf("%s:",$i); }}' <<< "${PATH}")
export PATH

# Check for updates
if __hhs_is_reachable 'github.com'; then
  if [[ ! -f "${HHS_DIR}/.last_update" || $(date "+%s%S") -ge $(grep . "${HHS_DIR}/.last_update") ]]; then
    echo -e "${GREEN}Home setup is checking for updates ...${NC}"
    hhs updater execute --check
  fi
else
  __hhs_log "WARN" "Github website is not reachable !"
fi

# The Internal Field Separator (IFS). The default value is <space><tab><newline>
export IFS="${RESET_IFS}"

# Print HomeSetup MOTD
echo ''
echo -e "${HHS_MOTD}${NC}"
echo ''
