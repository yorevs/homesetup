#!/usr/bin/env bash
# shellcheck disable=2015,1090

#  Script: hhsrc.bash
# Purpose: This file is user specific file that gets loaded each time user creates a new
#          local session i.e. in simple words, opens a new terminal. All environment variables
#          created in this file would take effect every time a new local session is started.
# Created: Apr 29, 2020
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: homesetup@gmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <https://opensource.org/licenses/MIT>
#
# Copyright (c) 2023, HomeSetup team

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

# Do not change this formatting, it is required to proper reset IFS to it's defaults
# The Internal Field Separator (IFS). The default value is <space><tab><newline>
export IFS=$'\n'
export RESET_IFS=$'\n'

# Unset all aliases before setting them again.
unalias -a

# The following variables are not inside the bash_env because we need them in the early load process.
export HHS_MY_OS="${HHS_MY_OS:-$(uname -s)}"
export HHS_MY_SHELL="${SHELL//\/bin\//}"

# Detect if HomeSetup was installed using an installation prefix.
export HHS_PREFIX_FILE="${HOME}/.hhs-prefix"

if [[ -s "${HHS_PREFIX_FILE}" ]]; then
  prefix="$(grep . "${HHS_PREFIX_FILE}")"
  [[ -n "${prefix}" && -d "${prefix}" ]] && export HHS_PREFIX="${prefix}"
else
  export HHS_PREFIX=
fi

export HHS_HOME="${HHS_PREFIX:-${HOME}/HomeSetup}"
export HHS_DIR="${HOME}/.hhs"
export HHS_BACKUP_DIR="${HHS_BACKUP_DIR:-${HHS_DIR}/backup}"
export HHS_CACHE_DIR="${HHS_CACHE_DIR:-${HHS_DIR}/cache}"
export HHS_LOG_DIR="${HHS_LOG_DIR:-${HHS_DIR}/log}"
export HHS_LOG_FILE="${HHS_LOG_FILE:-${HHS_LOG_DIR}/hhsrc.log}"

# if the log directory is not found, we have to create it.
[[ -d "${HHS_LOG_DIR}" ]] || mkdir -p "${HHS_LOG_DIR}"

# if the cache directory is not found, we have to create it.
[[ -d "${HHS_CACHE_DIR}" ]] || mkdir -p "${HHS_CACHE_DIR}"

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
# Notice that the order here is important, do not reorder it.
CUSTOM_DOTFILES=(
   'env'
   'colors'
   'prompt'
   'aliases'
   'aliasdef'
   'functions'
)

# Source common functions for bootstrap
source "${HHS_HOME}/dotfiles/bash/bash_commons.bash"

# Re-create the HomeSetup log file
echo -e "HomeSetup load started: $(date)\n" > "${HHS_LOG_FILE}"

if ! [[ -s "${HOME}"/.inputrc ]]; then
  __hhs_log "WARN" "'.inputrc' file was copied because it was not found at: ${HOME}"
  \cp "${HHS_HOME}/dotfiles/inputrc" "${HOME}"/.inputrc
fi

if ! [[ -f "${HHS_DIR}"/.aliasdef ]]; then
  __hhs_log "WARN" "'.aliasdef' file was copied because it was not found at: ${HHS_DIR}"
  \cp "${HHS_HOME}/dotfiles/aliasdef" "${HHS_DIR}"/.aliasdef
fi

# Load all HomeSetup dotfiles.
for file in ${DOTFILES[*]}; do
  f_path="${HOME}/.${file}"
  if [[ -s "${f_path}" ]]; then
    __hhs_log "INFO" "Loading dotfile: ${f_path}"
    __hhs_source "${f_path}"
  else
    __hhs_log "WARN" "Skipped dotfile :: Not found -> ${f_path}"
  fi
done

# Load all Custom dotfiles.
for file in ${CUSTOM_DOTFILES[*]}; do
  f_path="${HHS_DIR}/.${file}"
  if [[ -s "${f_path}" ]]; then
    __hhs_log "INFO" "Loading custom dotfile: ${f_path}"
    __hhs_source "${f_path}"
  else
    __hhs_log "WARN" "Skipped custom dotfile :: Not found -> ${f_path}"
  fi
done

unset file f_path DOTFILES

# -----------------------------------------------------------------------------------
# Set default shell options

unset HHS_TERM_OPTS
case "${HHS_MY_SHELL}" in
  bash)
    # If set, bash matches patterns in a case-insensitive fashion when  performing  matching while
    # executing case or [[ conditional commands.
    shopt -u nocasematch || __hhs_log "WARN" "Unable to unset 'cdspell'"
    # If set, bash matches file names in a case-insensitive fashion when performing pathname expansion.
    shopt -u nocaseglob || __hhs_log "WARN" "Unable to unset 'nocaseglob'"
    # If set, minor errors in the spelling of a directory component in a cd command will be corrected.
    shopt -u cdspell || __hhs_log "WARN" "Unable to unset 'cdspell'"
    # If set, the extended pattern matching features described above under Pathname Expansion are enabled.
    shopt -s extglob && HHS_TERM_OPTS+='extglob ' || __hhs_log "WARN" "Unable to set 'extglob'"
    # Make bash check its window size after a process completes.
    shopt -s checkwinsize && HHS_TERM_OPTS+=' checkwinsize ' || __hhs_log "WARN" "Unable to set 'checkwinsize'"
    ;;
esac

export HHS_TERM_OPTS

# Input-rc Options:
# - completion-ignore-case: Turns off the case-sensitive completion
# - colored-stats: Displays possible completions using different colors to indicate their type
# - <shift>+<tab> Will cycle forward though complete options
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
  *)
    __hhs_log "WARN" "Can't set .inputrc for a unknown OS: ${HHS_MY_OS}"
    ;;
esac

# Add `$HHS_DIR/bin` to the system `$PATH`
__hhs_paths -q -a "${HHS_DIR}/bin"

# Add custom paths to the system `$PATH`
if [[ -f "${HHS_DIR}/.path" ]]; then
  NEW_PATHS="$(grep . "${HHS_DIR}/.path" | grep -v -e '^$')"
  NEW_PATHS=${NEW_PATHS//'\n'/':'/}
  PATH="${PATH}:${NEW_PATHS}"
fi

# Remove PATH duplicates.
PATH=$(awk -F: '{for (i=1;i<=NF;i++) { if ( !x[$i]++ ) printf("%s:",$i); }}' <<< "${PATH}")
export PATH

# Check for HomeSetup updates
if [[ ! -s "${HHS_DIR}/.last_update" || $(date "+%s%S") -ge $(grep . "${HHS_DIR}/.last_update") ]]; then
  __hhs_log "INFO" "Home setup is checking for updates ..."
  if __hhs_is_reachable 'github.com'; then
    hhs updater execute check
  else
    __hhs_log "WARN" "GitHub website is not reachable !"
  fi
fi

# Load system preferences
if [[ ${HHS_EXPORT_SETTINGS} -eq 1 ]]; then
  # Update the settings configuration
  echo "hhs.setman.database = ${HHS_SETMAN_DB_FILE}" > "${HHS_SETMAN_CONFIG_FILE}"
  tmp_file="$(mktemp)"
  if python3 -m setman source -n hhs -f "${tmp_file}" && source "${tmp_file}"; then
    __hhs_log "INFO" "System settings loaded !"
  else
    __hhs_log "ERROR" "Failed to load system settings !"
  fi
fi

echo -e "\nHomeSetup load finished: $(date)\n" >> "${HHS_LOG_FILE}"

# Print HomeSetup MOTD
echo ''
echo -e "${HHS_MOTD}${NC}"
echo ''
