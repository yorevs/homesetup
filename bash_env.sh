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
export TEMP="/tmp"
export TRASH="$HOME/.Trash/"

# Setting history length see HISTSIZE and HISTFILESIZE in bash(1)
export HISTSIZE=1000
export HISTFILESIZE=2000