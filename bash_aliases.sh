#!/usr/bin/env bash
# shellcheck disable=SC1117,SC2142,SC1090

#  Script: bash_aliases.sh
# Purpose: This file is used to configure some useful shell aliases
# Created: Aug 26, 2008
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <http://unlicense.org/>
# !NOTICE: Do not change this file. To customize your aliases edit the file ~/.aliases

# inspiRED by: https://github.com/mathiasbynens/dotfiles

# Removes all aliases before setting them
unalias -a

# @function: Check if a command exists.
# @param $1 [Req] : The command to check.
__hhs_has() { 
    type "$1" > /dev/null 2>&1
}

# -----------------------------------------------------------------------------------
# Navigational
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ~='cd ~'
alias -- -='cd -'

# shellcheck disable=SC2035,SC2139
alias ?='pwd'

# -----------------------------------------------------------------------------------
# General
alias q="exit 0"

# Enable aliases to be sudo’ed
alias sudo='sudo '

# Always use color output for `ls`
alias ls='command ls ${COLOR_FLAG} -F'

# List all files colorized in long format
alias l='ls -lh'

# List all directories
alias lsd="ls -d */"

# List all file names sorted by name
alias lss='function _() { col=$1; [ -z "$1" ] && col=9; ls -la | sort -k "$col"; };_'

# List all files colorized in long format, including dot files
alias ll='ls -lah'

# List all dotfiles
alias lll='ls -lhd .??* | grep "^-"'

# List all dotdirs
alias lld='ls -lhd .??*/'

# Always enable colored `grep` output
# Note: `GREP_OPTIONS="--color=auto"` is deprecated, hence the alias usage.
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# For safety, by default those commands will input for confirmation
alias rm='rm -iv'
alias cp='cp -iv'
alias mv='mv -iv'

# Setting some defaults
alias cls='clear'
alias df='df -H'
alias du='du -hcd 1'

# Use vim instead of vi
__hhs_has "vim" && alias vi='vim'

# Interpret escape sequences
alias more='more -R'
alias less='less -R'

# Make mount command output pretty and human readable format
alias mount='mount | column -t'

# Create all folders using a dot notation path and immediatelly change into it
alias mkcd='function _() { if [ -n "$1" -a ! -d "$1" ]; then dir="${1//.//}"; mkdir -p $dir; pushd $dir >/dev/null; echo "${GREEN}Directory created: $dir ${NC}"; fi; };_'

# Top shortcut ordered by cpu
alias cpu='top -o cpu'

# Top shortcut ordered by Memory
alias mem='top -o rsize'

# Base64 encode shortcuts
__hhs_has "base64" && alias encode="base64"

# Linux boxes have a different syntaxes for some commands, so we craete the alias to match the correct OS.
if [ "Linux" = "$MY_OS" ]; then 
    alias ised="sed -i'' -r"
    __hhs_has "base64" && alias decode='base64 -d'
elif [ "Darwin" = "$MY_OS" ]; then
    alias ised="sed -i '' -E"
    __hhs_has "base64" && alias decode='base64 -D'
fi

# Date and time shortcuts
alias week='date +%V'
alias now='date +"%d-%m-%Y %T"'
alias ts='date "+%s%S"'

# macOS has no `wget, so using curl instead`
__hhs_has "wget" || alias wget='curl -O'

# Generate a random number int the range <min> <max>
alias rand='function _() { test -n "$1" -a -n "$2" && echo "$(( RANDOM % ($2 - $1 + 1 ) + $1 ))" || echo "Usage: rand <min> <max>"; };_'

# Reload the bash session
alias reload='cls; \. ~/.bashrc && echo -e "${HHS_WELCOME}"'

# Kills all processes specified by $1
alias pk='function _() { test -n "$1" && plist $1 kill; };_'

# Swaps between PS1 & PS2 prompts 
alias ps1='export PS1=$PS1_STYLE'
alias ps2='export PS1=$PS2_STYLE'

# -----------------------------------------------------------------------------------
# Tool aliases

# Tree: List all directories recursively (Nth level depth) as a tree
__hhs_has "tree" && alias lt='function _() { test -n "$1" -a -n "$2" && tree $1 -L $2 || tree $1; };_'

# Jenv: Set JAVA_HOME using jenv
__hhs_has "jenv" && alias jenv_set_java_home='export JAVA_HOME="$HOME/.jenv/versions/`jenv version-name`"'

# Dropbox: Recursively delete Dropbox conflicted files from the current directory
[ -d "$DROPBOX" ] && alias db-clean="find . -name *\ \(*conflicted* -exec rm -v {} \;"

# -----------------------------------------------------------------------------------
# Python aliases

if __hhs_has "python"; then

    # linux has no `json_pp`, so using python instead
    __hhs_has "json_pp" || alias json_pp='python -m json.tool'
    
    # Evaluate mathematical expression
    alias calc='python -c "import sys,math; print(eval(\" \".join(sys.argv[1:])));"'

    # URL-encode strings
    alias urle='python -c "import sys, urllib as ul; print ul.quote_plus(sys.argv[1]);"'
    alias urld='python -c "import sys, urllib as ul; print ul.unquote_plus(sys.argv[1]);"'

    # Generate a UUID
    alias uuid='python -c "import uuid as ul; print(ul.uuid4())"'

    # Convert unicode to hexadecimal
    alias utoh='function _() { print-uni.py $* | hexdump -Cb; };_'
fi

# -----------------------------------------------------------------------------------
# Perl aliases

if __hhs_has "perl"; then

    # Clean escape (\EscXX) codes from text
    alias cse="perl -pe 's/\x1b((\[[0-9;]*[a-zA-Z])|(\([a-zA-Z]))*//g'"
    # Copy to clipboard pbcopy required
    __hhs_has "pbcopy" && alias clipboard="cse | pbcopy"
fi

# -----------------------------------------------------------------------------------
# IP related

# External IP
__hhs_has "dig" && alias ip='a=$(dig -4 TXT +time=1 +short o-o.myaddr.l.google.com @ns1.google.com);echo ${a//\"}'

# Local networking (requires pcregrep)
if __hhs_has "pcregrep"; then

    # Show active network interfaces
    alias ifa="ifconfig | pcregrep -M -o '^[^\t:]+:([^\n]|\n\t)*status: active'"
    # Local IP of active interfaces
    alias ipl='for iface in $(ifa | grep -o "^en[0-9]\|^eth[0-9]"); do echo "Local($iface) IP : $(ipconfig getifaddr $iface)"; done'
fi

# All IPs of all interfaces
__hhs_has "ifconfig" && alias ips="ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"

# -----------------------------------------------------------------------------------
# Mac Stuff

if [ "Darwin" = "$MY_OS" ]; then 

    # Delete all .DS_store files
    alias clean-ds="find . -type f -name '*.DS_Store' -ls -delete"

    # Flush Directory Service cache
    __hhs_has "dscacheutil" && alias flush="dscacheutil -flushcache && killall -HUP mDNSResponder"

    # Clean up LaunchServices to remove duplicates in the “Open With” menu
    __hhs_has "lsregister" && alias ls-cleanup="/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user && killall Finder"

    if __hhs_has "defaults"; then

        # Show/hide hidden files in Finder
        alias show-files="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
        alias hide-files="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"
        # Hide/show all desktop icons
        alias showdeskicons="defaults write com.apple.finder CreateDesktop -bool true && killall Finder"
        alias hidedeskicons="defaults write com.apple.finder CreateDesktop -bool false && killall Finder"
    fi

    # Canonical hex dump; some systems have this symlinked
    __hhs_has "hd" || alias hd='hexdump -C'

    # macOS has no `md5sum`, so use `md5` as a fallback
    __hhs_has "md5sum" || alias md5sum='md5'

    # macOS has no `sha1sum`, so use `shasum` as a fallback
    __hhs_has "sha1" || alias sha1='shasum'
    __hhs_has "sha1sum" || alias sha1sum='sha1'
fi

# -----------------------------------------------------------------------------------
# Directory Shortcuts

alias desk='cd ${DESKTOP}'
alias hhs='cd ${HOME_SETUP}'
alias temp='cd ${TEMP}'

# -----------------------------------------------------------------------------------
# Handy Terminal Shortcuts

# Show the cursor using tput
alias show-cursor='tput cnorm'

# Hide the cursor using tput
alias hide-cursor='tput civis'

# Save current cursor position
alias save-cursor-pos='tput sc'

# Restore saved cursor position
alias restore-cursor-pos='tput rc'

# Enable line wrapping
alias enable-line-wrap='tput smam'

# Disable line wrapping
alias disable-line-wrap='tput rmam'

# 
# EXPERIMENTAL {
# 

# -----------------------------------------------------------------------------------
# Git Stuff

if __hhs_has "git"; then

    alias __hhs_git_status='git status && gl -n 1'
    alias __hhs_git_fetch='git fetch -p'
    alias __hhs_git_history='git log -p'
    alias __hhs_git_branch='git branch'
    alias __hhs_git_diff='git diff'
    alias __hhs_git_pull='git pull'
    alias __hhs_git_log='git log --oneline --graph --decorate --pretty=format:"%C(blue)%h%C(red)%d %C(yellow)(%cr) %C(cyan)<%ce> %C(white)\"%s\"%Creset"'
    alias __hhs_git_checkout='git checkout'
    alias __hhs_git_add='git add'
    alias __hhs_git_commit='git commit -m'
    alias __hhs_git_amend='git commit --amend --no-edit'
    alias __hhs_git_branch_all='function _() { test -n "$1" -a -n "$2" && for x in $(find "$1" -maxdepth 1 -type d -iname "$2"); do cd $x; pwd; git status | head -n 1; cd - > /dev/null; done || echo "Usage: gba <dirname> <fileext>"; };_'
    alias __hhs_git_status_all='function _() { test -n "$1" && for x in $(find "$1" -maxdepth 1 -type d -iname "*.git"); do cd $x; pwd; git status; cd - > /dev/null; done || echo "Usage: gsa <dirname>"; };_'
    alias __hhs_git_pull_rebase='git pull --rebase'
    alias __hhs_git_push='git push origin HEAD'
    alias __hhs_git_show='git diff-tree --no-commit-id --name-status -r'
    alias __hhs_git_diff_show='function _() { git diff $1^1 $1 -- $2; };_'
    alias __hhs_git_difftool='git difftool -t opendiff'
fi

# -----------------------------------------------------------------------------------
# Gradle Stuff

if __hhs_has "gradle"; then

    # Prefer using the wrapper instead of the command itself
    alias __hhs_gradlew='function _() { [ -f "./gradlew" ] && ./gradlew $* || gradle $*; };_'
    alias __hhs_gradle_build='gw clean build'
    alias __hhs_gradle_run='gw bootRun -x Test'
    alias __hhs_gradle_test='gw Test'
    alias __hhs_gradle_init='gw init'
    alias __hhs_gradle_quiet='gw -q'
    alias __hhs_gradle_wrapper='gw wrapper --gradle-version'
    alias __hhs_gradle_tasks='gradle -q :tasks --all'
    alias __hhs_gradle_projects='gradle -q projects'
fi

# -----------------------------------------------------------------------------------
# Docker stuff
# inspiRED by https://hackernoon.com/handy-docker-aliases-4bd85089a3b8

if __hhs_has "docker"; then

    alias __hhs_docker_images='docker images'
    alias __hhs_docker_service='docker service'
    alias __hhs_docker_logs='docker logs'
    alias __hhs_docker_exec='function _() { [ -n "$2" ] && docker exec -it "$1" "$2" || docker exec -it "$1" /bin/sh; };_'
    alias __hhs_docker_remove='for next in $(docker volume ls -qf dangling=true); do echo "Removing Docker volume: $next"; docker volume rm $next; done'
    alias __hhs_docker_remove_image='docker rmi'
    alias __hhs_docker_ps='docker ps --format "{{.ID}} - {{.Names}} - {{.Status}} - {{.Image}}"'
    alias __hhs_docker_pidof='function _() { docker ps | grep "$1" | awk '"'"'{print $1}'"'"'; };_'
    alias __hhs_docker_tail_logs='function _() { docker logs -f $(docker ps | grep "$1" | awk '"'"'{print $1}'"'"'); };_'
    alias __hhs_docker_top='docker stats --format "table {{.Container}}\t{{.Name}}\t{{.CPUPerc}}\t{{.NetIO}}\t{{.BlockIO}}"'
fi

#
# } EXPERIMENTAL
#

# Source the custom alias shortcuts
if [ -s "$HOME/.bash_aliasdef" ]; then
    \. "$HOME/.bash_aliasdef"
fi
