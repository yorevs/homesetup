#!/usr/bin/env bash

#  Script: bash_env.sh
# Purpose: Configure shell environment variables
# Created: Aug 26, 2008
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs/homesetup

# Home Sweet Homes
export JAVA_HOME="/Library/Java/JavaVirtualMachines/Current/Contents/Home"
export JDK_HOME="$JAVA_HOME"
export PYTHON_HOME="/System/Library/Frameworks/Python.framework/Versions/Current"
export QT_HOME="$HOME/Applications/Current/clang_64"
export XCODE_HOME="/Applications/Xcode.app/Contents/Developer"
export MACOS_SDK="$XCODE_HOME/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk"


# Other environment variables
export DROPBOX="$HOME/Dropbox"
export HOME_SETUP="$HOME/HomeSetup"
export GIT_REPOS="$HOME/GIT-Repository"
export SVN_REPOS="$HOME/SVN-Repository"
export WORKSPACE="$HOME/Workspace"
export DESKTOP="$HOME/Desktop"
export DOWNLOADS="$HOME/Downloads"
export TEMP="$TMPDIR"
export TRASH="$HOME/.Trash/"
# shellcheck disable=SC2155
export DOTFILES_VERSION=$(cat "$HOME_SETUP/VERSION")

# Setting history length ( HISTSIZE and HISTFILESIZE ) in bash
export HISTSIZE=500
export HISTFILESIZE=500

# Languages and encodings
export LANG=en_US.UTF-8
export LC_CTYPE=UTF-8
export NLS_LANG=AMERICAN_AMERICA.AL32UTF8

# Development tools. To override it please export the same variable at ~/.env
export DEFAULT_DEV_TOOLS=(
    "bash" "brew" "tree" "vim" "pcregrep" "shfmt" "shellcheck"
    "node" "java" "python" "ruby" "gcc" "make" "qmake"
    "doxygen" "ant" "mvn" "gradle" "git" "svn" "cvs"
    "nvm" "npm" "jenv" "eslint" "gpg" "base64"
)