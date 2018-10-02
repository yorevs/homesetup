#!/usr/bin/env bash

#  Script: bash_aliases.sh
# Purpose: Configure some useful shell aliases
# Created: Aug 26, 2008
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#
# Original project: https://github.com/mathiasbynens/dotfiles

# Navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ~="cd ~" # `cd` is probably faster to type though
alias -- -="cd -"
alias ?="pwd"
alias q="exit"

# General
alias save='save-dir'
alias load='load-dir'
alias reload='source $HOME/.bashrc'

alias pk='function _() { test -n "$1" && plist $1 kill }; };_'

# Enable aliases to be sudo’ed
alias sudo='sudo '

# Always use color output for `ls`
alias ls="command ls ${colorflag}"

# List all files colorized in long format
alias l="ls -lhF ${colorflag}"

# List all files colorized in long format, including dot files
alias ll="ls -lahF ${colorflag}"

# List all dotfiles
alias lll="ls -lhdF .?*!(d) ${colorflag}"

# List all dotdirs
alias lld="ls -lhd .?*/ ${colorflag}"

# List all directories recursively (Nth level depth) as a tree
alias lt='function _() { test -n "$1" -a -n "$2" && tree $1 -L $2; test -z "$1" && tree $1; };_'

# Always enable colored `grep` output
# Note: `GREP_OPTIONS="--color=auto"` is deprecated, hence the alias usage.
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Commands
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias cls='clear'
alias vi='vim'
alias tl='tail -F'

# Dates
# Get week number
alias week='date +%V'
alias now='date +"%d-%m-%Y %T"'
alias now-ms='date "+%s%S"'

# Show active network interfaces
alias ifa="ifconfig | pcregrep -M -o '^[^\t:]+:([^\n]|\n\t)*status: active'"

# IP addresses

# External
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
# Local
alias ipl='for iface in $(ifa | grep -o "^en[0-9]\|^eth[0-9]"); do echo "Local($iface) IP: $(ipconfig getifaddr $iface)"; done'
# All IPs
alias ips="ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"

# Mac Stuff
# Delete all .DS_store files
alias clean-ds="find . -type f -name '*.DS_Store' -ls -delete"
alias edit='function _() { vi $1; source $1; };_'
alias dots='ls -lhadF .?*'

# Flush Directory Service cache
alias flush="dscacheutil -flushcache && killall -HUP mDNSResponder"

# Clean up LaunchServices to remove duplicates in the “Open With” menu
alias ls-cleanup="/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user && killall Finder"

# Show/hide hidden files in Finder
alias show-files="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
alias hide-files="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"

# set JAVA_HOME using jenv
alias jenv_set_java_home='export JAVA_HOME="$HOME/.jenv/versions/`jenv version-name`"'

# Canonical hex dump; some systems have this symlinked
command -v hd > /dev/null || alias hd="hexdump -C"

# macOS has no `md5sum`, so use `md5` as a fallback
command -v md5sum > /dev/null || alias md5sum="md5"

# macOS has no `sha1sum`, so use `shasum` as a fallback
command -v sha1sum > /dev/null || alias sha1sum="shasum"

# macOS has no `wget, co using curl instead`
alias wget='curl -O'

# Evaluate mathemathical expression
alias calc='python -c "import sys,math;print(eval(sys.argv[1]));"'

# URL-encode strings
alias urlencode='python -c "import sys, urllib as ul; print ul.quote_plus(sys.argv[1]);"'
alias urldecode='python -c "import sys, urllib as ul; print ul.unquote_plus(sys.argv[1]);"'

# Git Stuff
alias gs='git s'
alias gf='git f'
alias gco='git co'
alias gta='git a'
alias gb='git b'
alias gd='git d'
alias gp='git p'
alias gprb='git prb'
alias gpr='git pull --rebase' 
alias gl='git l'
alias gcm='git cm'
alias gca='git ca'
alias gtps='git ps origin HEAD'

alias gba='function _() { test -n "$1" -a -n "$2" && for x in $(find "$1" -maxdepth 1 -type d -iname "$2"); do cd $x; pwd; git status | head -n 1; cd - > /dev/null; done || echo "Usage: gba <dirname> <fileext>"; };_'
alias gsa='function _() { test -n "$1" && for x in $(find "$1" -maxdepth 1 -type d -iname "*.git"); do cd $x; pwd; git status; cd - > /dev/null; done || echo "Usage: gsa <dirname>"; };_'

alias git-show='git diff-tree --no-commit-id --name-status -r'
alias git-show-diff='function _() { git diff $1^1 $1 -- $2; };_'

# Gradle
alias gwb='gradle clean build -x test'
alias gwr='gradle bootRun'
alias gwi='gradle init'
alias gww='gradle wrapper --gradle-version'

# Docker
alias drm='for next in $(docker volume ls -qf dangling=true); do echo "Removing Docker volume: $next"; docker volume rm $next; done'

# Vue
alias vue-run='npm run dev'
alias vue-init='vue init webpack '

# Directory Shortcuts
alias work='cd $WORKSPACE'
alias repos='cd $GIT_REPOS'
alias desk='cd $DESKTOP'
alias home='cd $HOME'
alias db='cd $DROPBOX'
alias dl='cd $DOWNLOADS'
alias dev='cd $DEV_FILES'
alias hhs='cd $HOME_SETUP'

# Functions Shortcuts
alias sf="search-files"
alias sd="search-directories"
alias ss="search-string"
