#!/usr/bin/env bash
# shellcheck disable=2015,1090,2155,2164

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
export OLDIFS="${IFS}"

# Unset all aliases before setting them again.
unalias -a

# The following variables are not inside the bash_env because we need them in the early load process.
export HHS_MY_OS="${HHS_MY_OS:-$(uname -s)}"
export HHS_MY_SHELL="${SHELL##*/}"

export INPUTRC="${INPUTRC:-${HOME}/.inputrc}"

# Detect if HomeSetup was installed using an installation prefix.
export HHS_PREFIX_FILE="${HOME}/.hhs-prefix"

if [[ -s "${HHS_PREFIX_FILE}" ]]; then
  prefix="$(grep -m 1 . "${HHS_PREFIX_FILE}")"
  [[ -n "${prefix}" && -d "${prefix}" ]] && export HHS_PREFIX="${prefix}"
else
  unset HHS_PREFIX
fi

# Defined by the installation.
export HHS_HOME="${HHS_PREFIX:-${HOME}/HomeSetup}"
export HHS_DIR="${HOME}/.config/hhs"
export HHS_VERSION="$(grep -m 1 . "${HHS_HOME}"/.VERSION)"
export HHS_SHOPTS_FILE="${HHS_DIR}/shell-opts.toml"
export HHS_BACKUP_DIR="${HHS_DIR}/backup"
export HHS_CACHE_DIR="${HHS_DIR}/cache"
export HHS_LOG_DIR="${HHS_DIR}/log"
export HHS_LOG_FILE="${HHS_LOG_DIR}/hhsrc.log"
export HHS_SETUP_FILE="${HHS_DIR}/.homesetup.toml"

# if the log directory is not found, we have to create it.
[[ -d "${HHS_LOG_DIR}" ]] || mkdir -p "${HHS_LOG_DIR}"

# if the cache directory is not found, we have to create it.
[[ -d "${HHS_CACHE_DIR}" ]] || mkdir -p "${HHS_CACHE_DIR}"

# Set path so it includes user's private bin if it exists.
[[ -d "${HOME}/bin" ]] && export PATH="${PATH}:${HOME}/bin"

# Set path so it includes user's private bin if it exists.
[[ -d "${HOME}/.local/bin" ]] && export PATH="${PATH}:${HOME}/.local/bin"

# Set path so it includes `$HHS_DIR/bin` if it exists.
[[ -d "${HHS_DIR}/bin" ]] && export PATH="${PATH}:${HHS_DIR}/bin"

# Set path so it includes `bats-core` if it exists.
[[ -d "${HHS_DIR}/bin" ]] && export PATH="${PATH}:${HHS_HOME}/tests/bats/bats-core/bin"

# Load all dotfiles following the order.
# Notice that the order here is important, do not reorder it.
DOTFILES=(
  'bash_env'
  'bash_colors'
  'bash_prompt'
  'bash_aliases'
  'bash_icons'
  'bash_functions'
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

# Add custom paths to the system `$PATH`.
if [[ -f "${HHS_DIR}/.path" ]]; then
  all="$(grep . "${HHS_DIR}/.path" | grep -v -e '^$')"
  for f_path in ${all}; do
    [[ -n "${f_path}" ]] && PATH="${f_path}:${PATH}"
  done
fi

# Re-create the HomeSetup log file.
started="$(python3 -c 'import time; print(int(time.time() * 1000))')"
echo -e "HomeSetup is starting: $(date)\n" >"${HHS_LOG_FILE}"

# Source the bash common functions.
source "${HHS_HOME}/dotfiles/bash/bash_commons.bash"

if ! [[ -s "${INPUTRC}" ]]; then
  __hhs_log "WARN" "'.inputrc' file was copied because it was not found at: ${HOME}"
  \cp "${HHS_HOME}/dotfiles/inputrc" "${INPUTRC}"
fi

if ! [[ -f "${HHS_DIR}"/.aliasdef ]]; then
  __hhs_log "WARN" "'.aliasdef' file was copied because it was not found at: ${HHS_DIR}"
  \cp "${HHS_HOME}/dotfiles/aliasdef" "${HHS_DIR}"/.aliasdef
fi

# Load initialization setup.
if [[ ! -s "${HHS_SETUP_FILE}" ]]; then
  __hhs_log "WARN" "HomeSetup initialization file not found. Using defaults."
  \cp "${HHS_HOME}/dotfiles/homesetup.toml" "${HHS_SETUP_FILE}"
fi
re='^([a-zA-Z0-9_.]+) *= *(.*)'
while read -r pref; do
  if [[ ${pref} =~ $re ]]; then
    pref="$(tr '[:lower:]' '[:upper:]' <<<"${BASH_REMATCH[1]}=${BASH_REMATCH[2]}")"
    pref="${pref//TRUE/1}" && pref="${pref//FALSE/}"
    export "${pref?}"
  fi
done <"${HHS_SETUP_FILE}"
__hhs_log "INFO" "Initialization settings loaded: ${HHS_SETUP_FILE}"

# -----------------------------------------------------------------------------------
# Load dotfiles

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

# Load all Custom dotfiles:
#   source -> ~/.hhs/.env can be used to extend/override .bash_env
#   source -> ~/.hhs/.colors can be used to extend/override .bash_colors
#   source -> ~/.hhs/.prompt can be used to extend/override .bash_prompt
#   source -> ~/.hhs/.aliases can be used to extend/override .bash_aliases
#   source -> ~/.hhs/.aliasdef can be used to customize your alias definitions
#   source -> ~/.hhs/.functions can be used to extend/override .bash_functions
for file in ${CUSTOM_DOTFILES[*]}; do
  f_path="${HHS_DIR}/.${file}"
  if [[ -s "${f_path}" ]]; then
    __hhs_log "INFO" "Loading custom dotfile: ${f_path}"
    __hhs_source "${f_path}"
  else
    __hhs_log "WARN" "Skipped custom dotfile :: Not found -> ${f_path}"
  fi
done

# Set/Unset the shell options
if [[ ${HHS_LOAD_SHELL_OPTIONS} -eq 1 ]]; then
  if [[ ! -s "${HHS_SHOPTS_FILE}" ]]; then
    \shopt | awk '{print $1" = "$2}' >"${HHS_SHOPTS_FILE}" ||
       quit 2 "Unable to create the Shell Options file !"
  fi
  re_key_pair="^([a-zA-Z0-9]*) *= *(.*)$"
  while read -r line; do
    if [[ ${line} =~ ${re_key_pair} ]]; then
      option="${BASH_REMATCH[1]}"
      state="${BASH_REMATCH[2]}"
      if [[ "${state}" == 'on' ]]; then
        \shopt -s "${option}" || __hhs_log "WARN" "Unable to SET shell option: ${option}"
      elif [[ "${state}" == 'off' ]]; then
        \shopt -u "${option}" || __hhs_log "WARN" "Unable to UNSET shell option: ${option}"
      fi
    fi
  done <"${HHS_SHOPTS_FILE}"
  __hhs_log "INFO" "Shell options activated !"
fi

# Load system settings.
if [[ ${HHS_EXPORT_SETTINGS} -eq 1 ]]; then
  # Update the settings configuration.
  echo "hhs.setman.database = ${HHS_SETMAN_DB_FILE}" >"${HHS_SETMAN_CONFIG_FILE}"
  tmp_file="$(mktemp)"
  if python3 -m setman source -n hhs -f "${tmp_file}" && source "${tmp_file}"; then
    __hhs_log "INFO" "System settings loaded !"
  else
    __hhs_log "ERROR" "Failed to load system settings !"
  fi
fi

# Load bash completions.
if [[ ${HHS_LOAD_COMPLETIONS} -eq 1 ]]; then
  __hhs_log "INFO" "Loading bash completions!"
  while read -r cpl; do
    app_name="$(basename "${cpl//-completion/}")"
    app_name="${app_name//\.${HHS_MY_SHELL}/}"
    if __hhs_has "${app_name}"; then
      __hhs_source "${cpl}"
      HHS_COMPLETIONS="${HHS_COMPLETIONS}${app_name} "
    else
      __hhs_log "WARN" "Skipping completion \"${app_name}\" because the application was not detected!"
    fi
  done < <(find "${HHS_HOME}/bin/completions" -type f -name "*-completion.${HHS_MY_SHELL}")
  export HHS_COMPLETIONS
fi

# Load bash key bindings.
if [[ ${HHS_LOAD_KEY_BINDINGS} -eq 1 ]]; then
  __hhs_log "INFO" "Loading bash key bindings!"
  while read -r bnd; do
    app_name="$(basename "${bnd//-key-bindings/}")"
    app_name="${app_name//\.${HHS_MY_SHELL}/}"
    if __hhs_has "${app_name}"; then
      __hhs_source "${bnd}"
      HHS_BINDINGS="${HHS_BINDINGS}${app_name} "
    else
      __hhs_log "WARN" "Skipping key binding \"${app_name}\" because the application was not detected!"
    fi
  done < <(find "${HHS_HOME}/bin/key-bindings" -type f -name '*-key-bindings.bash')
  export HHS_BINDINGS
fi

# Check for HomeSetup updates.
if [[ ${HHS_NO_AUTO_UPDATE} -ne 1 ]]; then
  if [[ ! -s "${HHS_DIR}/.last_update" || $(date "+%s%S") -ge $(grep . "${HHS_DIR}/.last_update") ]]; then
    echo
    __hhs_log "INFO" "Home setup is checking for updates ..."
    if __hhs_is_reachable 'github.com'; then
      __hhs updater execute check
    else
      __hhs_log "WARN" "GitHub website is not reachable !"
    fi
  fi
fi

finished="$(python3 -c 'import time; print(int(time.time() * 1000))')"
diff_time=$((finished - started))
diff_time_sec=$((diff_time/1000))
diff_time_ms=$((diff_time-(diff_time_sec*1000)))

echo -e "\nHomeSetup initialization complete in ${diff_time_sec}s ${diff_time_ms}ms\n" >>"${HHS_LOG_FILE}"

# shellcheck disable=2164
if [[ ${HHS_RESTORE_LAST_DIR} -eq 1 && -s "${HHS_DIR}/.last_dirs" ]]; then
  cd "$(grep -m 1 . "${HHS_DIR}/.last_dirs")"
fi

# Print HomeSetup MOTDs.
if [[ -d "${HHS_DIR}"/motd ]]; then
  all=$(find "${HHS_DIR}"/motd -type f | sort | uniq)

  for motd in ${all}; do
    echo -e "$(eval "echo -e \"$(<"${motd}")\"")"
  done
fi

# Remove PATH duplicates.
PATH=$(awk -F: '{for (i=1;i<=NF;i++) { if ( !x[$i]++ ) printf("%s:",$i); }}' <<<"${PATH}")
export PATH

unset -f started finished diff_time diff_time_sec diff_time_ms state option line file
unset -f f_path tmp_file re_key_pair prefs cpl bnd pref re motd all app_name
