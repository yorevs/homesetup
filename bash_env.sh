#!/usr/bin/env bash
# shellcheck disable=SC2155

#  Script: bash_env.sh
# Purpose: This file is used to configure shell environment variables
# Created: Aug 26, 2008
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <http://unlicense.org/>
# !NOTICE: Do not change this file. To customize your environment variables edit the file ~/.env

# System locale
export LC_ALL=en_US
export LANG=en_US.UTF-8
export MY_OS="$(uname -s)"

# ----------------------------------------------------------------------------
# Home Sweet Homes

# Java
if command -v java >/dev/null; then
    export JAVA_HOME="/Library/Java/JavaVirtualMachines/Current/Contents/Home"
    export JDK_HOME="$JAVA_HOME"
fi

# Python
command -v python >/dev/null && export PYTHON_HOME="/System/Library/Frameworks/Python.framework/Versions/Current"

# Qt
[ -d /usr/local/opt/qt/bin ] && export QT_HOME="/usr/local/opt/qt/bin"

# XCode
if command -v xcode-select >/dev/null; then
    export XCODE_HOME="$(xcode-select -p)"
    export MACOS_SDK="$XCODE_HOME/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk"
fi

# ----------------------------------------------------------------------------
# Other environment variables
export TEMP="${TEMP:-$TMPDIR}"
export TRASH="${TRASH:-$HOME/.Trash}"
export HOME_SETUP="$HOME/HomeSetup"
export HHS_DIR="$HOME/.hhs"
command -v git >/dev/null && export GIT_REPOS="$HOME/GIT-Repository"
command -v svn >/dev/null && export SVN_REPOS="$HOME/SVN-Repository"
[ -d "$HOME/Dropbox" ] && export DROPBOX="$HOME/Dropbox"
export WORKSPACE="$HOME/Workspace"
export DESKTOP="$HOME/Desktop"
export DOWNLOADS="$HOME/Downloads"

# Setting history length ( HISTSIZE and HISTFILESIZE ) in bash
export HISTSIZE=${HISTSIZE:-1000}
export HISTFILESIZE=${HISTFILESIZE:-2000}
export HISTTIMEFORMAT="[%F %T] "
# History control ( ignore duplicates and spaces )
export HISTCONTROL="ignoreboth:erasedups"
export HISTFILE="$HOME/.bash_history"

# ----------------------------------------------------------------------------
# HomeSetup variables

# Fixed
export DOTFILES_VERSION=$(grep . "$HOME_SETUP/.VERSION")
export HHS_WELCOME="${ORANGE}${MY_OS} ${GREEN}¯\_(ツ)_/¯ Welcome to HomeSetup\xef\x87\xb9 ${BLUE}v${DOTFILES_VERSION}${NC}"
export RESET_IFS="$IFS"
# Customizeable
export MSELECT_MAX_ROWS=${MSELECT_MAX_ROWS:-10}
export SAVED_DIRS="${SAVED_DIRS:-$HHS_DIR/.saved_dirs}"
export CMD_FILE="${CMD_FILE:-$HHS_DIR/.cmd_file}"
export PUNCH_FILE="${PUNCH_FILE:-$HHS_DIR/.punches}"
export PATHS_FILE="${PATHS_FILE:-$HOME/.path}"

# Development tools. To override it please export DEV_TOOLS variable at ~/.env
DEFAULT_DEV_TOOLS=(
    "bash" "ssh" "xcode-select" "brew" "tree" "vim" "pcregrep"  
    "shfmt" "node" "java" "rvm" "ruby" "go" "gcc" "make" "qmake"
    "doxygen" "ant" "mvn" "gradle" "git" "svn" "cvs" "docker"
    "nvm" "npm" "jenv" "vue" "eslint" "gpg" "base64" "md5" "shasum"
    "htop" "dialog" "telnet" "figlet" "shellcheck" "perl" "hexdump" 
    "iconfig" "python" "python3"
)

export DEV_TOOLS=${DEV_TOOLS:-${DEFAULT_DEV_TOOLS[*]}}