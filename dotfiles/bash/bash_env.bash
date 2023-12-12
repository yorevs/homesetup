#!/usr/bin/env bash
# shellcheck disable=SC2155

#  Script: bash_env.bash
# Purpose: This file is used to configure shell environment variables
# Created: Aug 26, 2018
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: homesetup@gmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <https://opensource.org/licenses/MIT>
#
# Copyright (c) 2023, HomeSetup team

# !NOTICE: Do not change this file. To customize your environment variables edit the file ~/.env

# Do not source this file multiple times
if list_contains "${HHS_ACTIVE_DOTFILES}" "bash_env"; then
  __hhs_log "WARN" "bash_env was already loaded!"
fi

export HHS_ACTIVE_DOTFILES="${HHS_ACTIVE_DOTFILES} bash_env"

# Set system locale (defaults)
if [[ ${HHS_SET_LOCALES} -eq 1 ]]; then
  export LANGUAGE=${LANGUAGE:-en_US:en}
  export LANG=${LANG:-en_US.UTF-8}
  export LC_ALL=${LANG}
fi

# ----------------------------------------------------------------------------
# Starship variables
export STARSHIP_CONFIG="${STARSHIP_CONFIG=${HHS_DIR}/.starship.toml}"
export STARSHIP_CACHE="${STARSHIP_CACHE=${HHS_CACHE_DIR}}"
export HHS_STARSHIP_PRESETS_DIR="${HHS_HOME}/bin/apps/bash/hhs-app/plugins/starship/hhs-presets"

# ----------------------------------------------------------------------------
# System folders
export TEMP="${TEMP:-${TMPDIR:-$(dirname "$(mktemp)")}}"
export TRASH="${TRASH:-${HOME}/.Trash}"
export EDITOR="${EDITOR:-vi}"

# ----------------------------------------------------------------------------
# Home Sweet Home

# Java
if __hhs_has java; then
  export JAVA_HOME=${JAVA_HOME:-"/Library/Java/JavaVirtualMachines/Current/Contents/Home"}
  export JDK_HOME="${JDK_HOME:-$JAVA_HOME}"
fi

# Python
if __hhs_has python3; then
  export PYTHON_HOME=${PYTHON_HOME:-"/Library/Python/Current"}
fi

# ----------------------------------------------------------------------------
# OS Release

# Darwin
if [[ "Darwin" == "$(uname -s)" ]]; then
  # Hide the annoying warning about zsh
  export BASH_SILENCE_DEPRECATION_WARNING=1
  # OS Release - Darwin
  export HHS_MY_OS_RELEASE="$(sw_vers -productName)"
  export HHS_MY_OS_PACKMAN='brew'
  if command -v xcode-select &>/dev/null; then
    export XCODE_HOME=$(xcode-select -p)
    if [[ -d "${XCODE_HOME}/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk" ]]; then
      export MACOS_SDK="${XCODE_HOME}/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk"
    elif [[ -d "${XCODE_HOME}/SDKs/MacOSX" ]]; then
      export MACOS_SDK="${XCODE_HOME}/SDKs/MacOSX"
    fi
  fi
# Linux
else
  HHS_MY_OS_RELEASE="$(grep '^ID=' '/etc/os-release' 2>/dev/null)"
  HHS_MY_OS_RELEASE="${HHS_MY_OS_RELEASE#*=}"
  export HHS_MY_OS_RELEASE="${HHS_MY_OS_RELEASE//\"/}"
  if command -v 'apt-get' &>/dev/null; then
    export HHS_MY_OS_PACKMAN='apt-get'
  elif command -v 'dnf' &>/dev/null; then
    export HHS_MY_OS_PACKMAN='dnf'
  elif command -v 'yum' &>/dev/null; then
    export HHS_MY_OS_PACKMAN='yum'
  elif command -v 'apt' &>/dev/null; then
    export HHS_MY_OS_PACKMAN='apt'
  elif command -v 'apk' &>/dev/null; then
    export HHS_MY_OS_PACKMAN='apk'
  else
    export HHS_MY_OS_PACKMAN=''
    __hhs_log "WARN" "Unable to find a proper package manager"
  fi
fi

# ----------------------------------------------------------------------------
# Bash History

# History control ( ignore duplicates and spaces )
export HISTCONTROL=${HISTCONTROL:-"ignoreboth:erasedups"}
# Ignored history commands
export HISTIGNORE="?:??:exit:pwd:clear"
# Max. history size
export HISTSIZE=2000
# Max. history file size
export HISTFILESIZE=2000
# Setting history format: Index [<User>, <Date> <Time>] command
export HISTTIMEFORMAT="[${USER}, %F %T]  "
# Bash history file.
export HISTFILE="${HOME}/.bash_history"
# Do not share history between concurrent Bash sessions
unset PROMPT_COMMAND

# ----------------------------------------------------------------------------
# HomeSetup variables

export HHS_GITHUB_URL='https://github.com/yorevs/homesetup'
export HHS_HAS_DOCKER=$(__hhs_has docker && docker info &>/dev/null && echo '1')

# ----------------------------------------------------------------------------
# Module configs

export HHS_ALIASES_FILE="${HHS_DIR}/.aliases"
export HHS_CMD_FILE="${HHS_DIR}/.cmd_file"
export HHS_ENV_FILE="${HHS_DIR}/.env"
export HHS_FIREBASE_CONFIG_FILE="${HHS_DIR}/firebase.properties"
export HHS_FIREBASE_CREDS_FILE="${HHS_DIR}/{project_id}-firebase-credentials.json"
export HHS_PATHS_FILE="${HHS_DIR}/.path"
export HHS_PUNCH_FILE="${HHS_DIR}/.punches"
export HHS_SAVED_DIRS_FILE="${HHS_DIR}/.saved_dirs"
export HHS_SETMAN_CONFIG_FILE="${HHS_DIR}/setman.properties"
export HHS_SETMAN_DB_FILE="${HHS_DIR}/setman.db"
export HHS_VAULT_FILE="${HHS_DIR}/.vault"
export HHS_VAULT_USER="${USER}"

# ----------------------------------------------------------------------------
# Directories

[[ -d "${HOME}"/GIT-Repository ]] && __hhs_has git && export GIT_REPOS="${HOME}"/GIT-Repository
[[ -d "${HOME}"/SVN-Repository ]] && __hhs_has svn && export SVN_REPOS="${HOME}"/SVN-Repository
[[ -d "${HOME}"/Desktop ]] && export DESKTOP="${HOME}/Desktop"
[[ -d "${HOME}"/Documents ]] && export DOCUMENTS="${HOME}/Documents"
[[ -d "${HOME}"/Downloads ]] && export DOWNLOADS="${HOME}/Downloads"
[[ -d "${HOME}"/Dropbox ]] && export DROPBOX="${HOME}/Dropbox"
[[ -d "${HOME}"/Workspace ]] && export WORKSPACE="${HOME}/Workspace"

# Development tools. To override it please export HHS_DEV_TOOLS variable at ${HHS_ENV_FILE}
DEVELOPER_TOOLS=(
  'git' 'hexdump' 'vim' 'tree' 'pcregrep' 'jq' 'gpg' 'shasum' 'base64'
  'perl' 'groovy' 'java' 'ruby' 'python' 'python3' 'go'
  'gcc' 'make'  'mvn' 'gradle' 'pip3' 'rvm'
  'shfmt' 'shellcheck' 'eslint' 'pylint'
  'nvm' 'node' 'direnv' 'starship' 'pbcopy' 'eza'
  'docker' 'sqlite3' 'colima'
)

if [[ "Darwin" == "${HHS_MY_OS}" ]]; then
  DEVELOPER_TOOLS+=('brew' 'xcode-select')
fi

export HHS_DEV_TOOLS=${HHS_DEV_TOOLS:-$(tr ' ' '\n' <<<"${DEVELOPER_TOOLS[@]}" | sort --unique)}
