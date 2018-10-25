#!/usr/bin/env bash

#  Script: bash_env.sh
# Purpose: Configure shell environment variables
# Created: Aug 26, 2008
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs/homesetup

# Home Sweet Homes
command -v java >/dev/null && export JAVA_HOME="/Library/Java/JavaVirtualMachines/Current/Contents/Home"
command -v java >/dev/null && export JDK_HOME="$JAVA_HOME"
command -v python >/dev/null && export PYTHON_HOME="/System/Library/Frameworks/Python.framework/Versions/Current"
command -v qmake >/dev/null && export QT_HOME="$HOME/Applications/QT/Current/clang_64"
command -v xcode-select >/dev/null && export XCODE_HOME="xcode-select -p"
export MACOS_SDK="$XCODE_HOME/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk"


# Other environment variables
test -d "$HOME/Dropbox" && export DROPBOX="$HOME/Dropbox"
export HOME_SETUP="$HOME/HomeSetup"
command -v git >/dev/null && export GIT_REPOS="$HOME/GIT-Repository"
command -v svn >/dev/null && export SVN_REPOS="$HOME/SVN-Repository"
export WORKSPACE="$HOME/Workspace"
export DESKTOP="$HOME/Desktop"
export DOWNLOADS="$HOME/Downloads"
export TEMP="${TEMP:-$TMPDIR}"
export TRASH="${TRASH:-$HOME/.Trash}"

# shellcheck disable=SC2155
export DOTFILES_VERSION=$(grep . "$HOME_SETUP/VERSION")

# Setting history length ( HISTSIZE and HISTFILESIZE ) in bash
export HISTSIZE=${HISTSIZE:-500}
export HISTFILESIZE=${HISTFILESIZE:-500}

# Languages and encodings
export LANG=${LANG:-en_US.UTF-8}
export LC_CTYPE=${LC_CTYPE:-UTF-8}
export NLS_LANG=${NLS_LANG:-AMERICAN_AMERICA.AL32UTF8}

# Development tools. To override it please export the same variable at ~/.env
export DEFAULT_DEV_TOOLS=(
    "bash" "brew" "tree" "vim" "pcregrep" "shfmt" "shellcheck"
    "node" "java" "python" "ruby" "gcc" "make" "qmake"
    "doxygen" "ant" "mvn" "gradle" "git" "svn" "cvs"
    "nvm" "npm" "jenv" "eslint" "gpg" "base64" "md5" "shasum"
)