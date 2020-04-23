#!/usr/bin/env bash
# shellcheck disable=SC2155

#  Script: bash_env.bash
# Purpose: This file is used to configure shell environment variables
# Created: Aug 26, 2018
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <http://unlicense.org/>
# !NOTICE: Do not change this file. To customize your environment variables edit the file ~/.env

# System locale (defaults)
export LANG=${LANG:-en_US.UTF-8}
export LANGUAGE=${LANGUAGE:-en_US:en}
export LC_ALL=${LANG}

# Save the original IFS
export RESET_IFS="$IFS"

# Current OS and Terminal
export HHS_MY_OS="$(uname -s)"
export HHS_MY_SHELL="${SHELL//\/bin\//}"

# ----------------------------------------------------------------------------
# Home Sweet Homes

# Java
if command -v java > /dev/null; then
  export JAVA_HOME=${JAVA_HOME:-"/Library/Java/JavaVirtualMachines/Current/Contents/Home"}
  export JDK_HOME="${JDK_HOME:-$JAVA_HOME}"
fi

# Python
if command -v python > /dev/null; then
  export PYTHON_HOME="/System/Library/Frameworks/Python.framework/Versions/Current"
fi

# Qt
if command -v qmake > /dev/null || [[ -d /usr/local/opt/qt/bin ]]; then
  export QT_HOME="/usr/local/opt/qt/bin"
fi

if [[ "Darwin" == "$HHS_MY_OS" ]]; then
  # Hide the annoying warning about zsh
  export BASH_SILENCE_DEPRECATION_WARNING=1
  # XCode
  if command -v xcode-select > /dev/null; then
    export XCODE_HOME="$(xcode-select -p)"
    export MACOS_SDK="$XCODE_HOME/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk"
  fi
fi

# ----------------------------------------------------------------------------
# Commonly used folders
export TEMP="${TEMP:-$TMPDIR}"
export TRASH="${TRASH:-${HOME}/.Trash}"
export EDITOR="${EDITOR:-vi}"

# ----------------------------------------------------------------------------
# Bash History

# Setting history length ( HISTSIZE and HISTFILESIZE ) in bash
export HISTSIZE=${HISTSIZE:-1000}
export HISTFILESIZE=${HISTFILESIZE:-2000}
export HISTTIMEFORMAT=${HISTTIMEFORMAT:-"[%F %T] "}

# History control ( ignore duplicates and spaces )
export HISTCONTROL=${HISTCONTROL:-"ignoreboth:erasedups"}
export HISTFILE="${HISTFILE:-${HOME}/.bash_history}"

# ----------------------------------------------------------------------------
# HomeSetup variables

# Fixed
export HHS_HOME="${HOME}/HomeSetup"
export HHS_DIR="${HOME}/.hhs"
export HHS_VERSION="$(head -1 "${HHS_HOME}"/.VERSION)"
export HHS_MOTD="$(eval "echo -e \"$(< "${HHS_HOME}"/.MOTD)\"")"
export HHS_SAVED_DIRS_FILE="${HHS_DIR}/.saved_dirs"
export HHS_CMD_FILE="${HHS_DIR}/.cmd_file"
export HHS_PATHS_FILE="${HHS_DIR}/.path"
export HHS_WARNINGS_FILE="${HHS_DIR}/.warnings.log"

# Customizeable
export HHS_SILENT_WARNINGS=${HHS_SILENT_WARNINGS:-}
export HHS_DEFAULT_EDITOR=${HHS_DEFAULT_EDITOR:-}
export HHS_MENU_MAXROWS=${HHS_MENU_MAXROWS:-15}
export HHS_PUNCH_FILE="${HHS_PUNCH_FILE:-${HHS_DIR}/.punches}"
export HHS_VAULT_FILE="${HHS_VAULT_FILE:-${HHS_DIR}/.vault}"
export HHS_VAULT_USER="${HHS_VAULT_USER:-${USER}}"

command -v git > /dev/null && export GIT_REPOS="${GIT_REPOS:-${HOME}/GIT-Repository}"
command -v svn > /dev/null && export SVN_REPOS="${SVN_REPOS:-${HOME}/SVN-Repository}"

[[ -d "${HOME}/Workspace" ]] && export WORKSPACE="${WORKSPACE:-${HOME}/Workspace}"
[[ -d "${HOME}/Desktop" ]] && export DESKTOP="${DESKTOP:-${HOME}/Desktop}"
[[ -d "${HOME}/Downloads" ]] && export DOWNLOADS="${DOWNLOADS:-${HOME}/Downloads}"
[[ -d "${HOME}/Dropbox" ]] && export DROPBOX="${DROPBOX:-${HOME}/Dropbox}"

# Development tools. To override it please export HHS_DEV_TOOLS variable at ~/.env
DEFAULT_DEV_TOOLS=(
  'hexdump' 'vim' 'xcode-select' 'brew' 'bats' 'tree'
  'pcregrep' 'shfmt' 'shellcheck' 'java' 'rvm' 'ruby'
  'gcc' 'make' 'qmake' 'doxygen' 'ant' 'mvn' 'gradle'
  'svn' 'docker' 'nvm' 'node' 'vue' 'eslint' 'gpg' 'md5'
  'shasum' 'htop' 'dialog' 'telnet' 'figlet' 'asciinema' 'base64'
  'git' 'go' 'python' 'jq' 'jenv' 'perl' 'ifconfig' 'groovy'
)

export HHS_DEV_TOOLS=${HHS_DEV_TOOLS:-$(tr ' ' '\n' <<< "${DEFAULT_DEV_TOOLS[@]}" | uniq | sort | tr '\n' ' ')}
