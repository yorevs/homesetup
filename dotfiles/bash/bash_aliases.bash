#!/usr/bin/env bash
# shellcheck disable=SC1117,SC2142,SC1090

#  Script: bash_aliases.bash
# Purpose: This file is used to configure some useful shell aliases
# Created: Aug 26, 2008
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <http://unlicense.org/>
# !NOTICE: Do not change this file. To customize your aliases edit the file ~/.aliases

# inspiRED by: https://github.com/mathiasbynens/dotfiles

# This is the only function in this file, intentionally

# Removes all aliases before setting them.
unalias -a

# @function: Check if a command exists.
# @param $1 [Req] : The command to check.
function __hhs_has() {
  type "$1" > /dev/null 2>&1
}

# @function: Check if an alias exists and create it if it does not. Do not support the use of single quotes in the expression
# @param $1 [Req] : The alias to set/check. Use the format __hhs_alias <alias_name='<alias_expr>'
function __hhs_alias() {

  local all_args alias_expr alias_name

  all_args="${*}"
  alias_expr="${all_args#*=}"
  alias_name="${all_args//=*/}"

  if ! type "$alias_name" > /dev/null 2>&1; then
    # shellcheck disable=SC2139
    alias "${alias_name}"="${alias_expr}"
    ret=$?
    [[ $ret -eq 0 ]] || echo "${RED}Failed to alias: \"${alias_name}\" !${NC}" 2>&1
    return $ret
  fi

  return 1
}

# -----------------------------------------------------------------------------------
# Navigational
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ~='cd ~'
alias -- -='cd -'

# shellcheck disable=SC2035,SC2139
alias ?='pwd'

# -----------------------------------------------------------------------------------
# General

# Short for exit terminal
alias q="exit 0"

# Enable aliases to be sudo’ed
alias sudo='sudo '

# Always use color output for `ls`
alias ls='\ls ${COLOR_FLAG} -F'

# List all files colorized in long format
alias l='ls -lh'

# List all directories
alias lsd="ls -d */"

# List all files colorized in long format, including dot files
alias ll='ls -lah'

# List all dotfiles
alias lll='ls -lhd .??* | grep "^-"'

# List all dotdirs
alias lld='ls -lhd .??*/'

# Always enable colored `grep` output
# Note: `GREP_OPTIONS="--color=auto"` is deprecated, hence the alias usage.
alias grep='\grep --color=auto'
alias fgrep='\fgrep --color=auto'
alias egrep='\egrep --color=auto'

# For safety, by default those commands will input for confirmation
alias rm='\rm -iv'
alias cp='\cp -iv'
alias mv='\mv -iv'

# Nice command replacements
alias df='\df -H'
alias du='\du -hcd 1'
alias psg='\ps aux | grep -v grep | grep -i -e VSZ -e'

# Use vim instead of vi
__hhs_has "vim" && alias vi='\vim'

# Interpret escape sequences
alias more='\more -r'
alias less='\less -r'

# Make mount command output pretty and human readable format
alias mount='\mount | column -t'

# Top shortcut ordered by cpu
alias cpu='\top -o cpu'

# Top shortcut ordered by Memory
alias mem='\top -o rsize'

# Date and time shortcuts
alias week='\date +%V'
alias now='\date +"(Week:%V) %Y-%m-%d %T %Z"'
alias ts='\date "+%s%S"'

# macOS has no `wget, so using curl instead`
__hhs_has "wget" || alias wget='\curl -O'

# Swaps between PS1 & PS2 prompts
alias ps1='export PS1=$PS1_STYLE'
alias ps2='export PS1=$PS2_STYLE'

# Use jq for format json instead of json_pp if it is installed
__hhs_has "jq" && alias json_pp='\jq'

# HomeSetup
alias __hhs_vault='hhs vault execute'
alias __hhs_hspm='hhs hspm execute'
alias __hhs_dotfiles='hhs firebase execute'
alias __hhs_hhu='hhs updater execute'
alias __hhs_reload='cls; source ${HOME}/.bashrc'
alias __hhs_clear='cls; \reset'

# -----------------------------------------------------------------------------------
# Tool aliases

# Jenv: Set JAVA_HOME using jenv
__hhs_has "jenv" && alias jenv_set_java_home='export JAVA_HOME="$HOME/.jenv/versions/`jenv version-name`"'

# Dropbox: Recursively delete Dropbox conflicted files from the current directory
[ -d "$DROPBOX" ] && alias cleanup-db="find . -name *\ \(*conflicted* -exec rm -v {} \;"

# -----------------------------------------------------------------------------------
# Python aliases

if __hhs_has "python"; then

  # Linux has no `json_pp`, so using python instead
  __hhs_has "json_pp" || alias json_pp='python -m json.tool'

  # Evaluate mathematical expression
  __hhs_alias calc='python -c "import sys,math; print(eval(\" \".join(sys.argv[1:])));"'

  # URL-encode strings
  __hhs_alias urle='python -c "import sys, urllib as ul; print ul.quote_plus(sys.argv[1]);"'
  __hhs_alias urld='python -c "import sys, urllib as ul; print ul.unquote_plus(sys.argv[1]);"'

  # Generate a UUID
  __hhs_alias uuid='python -c "import uuid as ul; print(ul.uuid4())"'
fi

# Base64 encode shortcuts
__hhs_has "base64" && __hhs_alias encode="base64"

# -----------------------------------------------------------------------------------
# OS Specific aliases
# Linux boxes have a different syntaxes for some commands, so we craete the alias to match the correct OS.
case $HHS_MY_OS in

  Linux) # -- LINUX --
    __hhs_alias ised="sed -i'' -r"
    __hhs_alias esed="sed -r"
    __hhs_has "base64" && __hhs_alias decode='base64 -d'
    ;;

  Darwin) # -- MACOS --

    __hhs_alias ised="sed -i '' -E"
    __hhs_alias esed="sed -E"
    __hhs_has "base64" && __hhs_alias decode='base64 -D'

    # Delete all .DS_store files
    alias cleanup-ds="find . -type f -name '*.DS_Store' -ls -delete"

    # Flush Directory Service cache
    __hhs_has "dscacheutil" && __hhs_alias flush="dscacheutil -flushcache && killall -HUP mDNSResponder"

    # Clean up LaunchServices to remove duplicates in the “Open With” menu
    alias cleanup-reg="/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user && killall Finder"

    # Show/hide hidden files in Finder
    alias show-files="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
    alias hide-files="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"
    # Hide/show all desktop icons
    alias show-deskicons="defaults write com.apple.finder CreateDesktop -bool true && killall Finder"
    alias hide-deskicons="defaults write com.apple.finder CreateDesktop -bool false && killall Finder"

    # Canonical hex dump; some systems have this symlinked
    __hhs_has "hd" || alias hd='hexdump -C'

    # macOS has no `md5sum`, so use `md5` as a fallback
    __hhs_has "md5sum" || alias md5sum='md5'

    # macOS has no `sha1sum`, so use `shasum` as a fallback
    __hhs_has "sha1" || alias sha1='shasum'
    __hhs_has "sha1sum" || alias sha1sum='sha1'
    ;;
esac

# -----------------------------------------------------------------------------------
# Handy Terminal Shortcuts => TODO: adapt for zsh

case $HHS_MY_SHELL in

  bash)
    alias show-cursor='tput cnorm'
    alias hide-cursor='tput civis'
    alias save-cursor-pos='tput sc'
    alias restore-cursor-pos='tput rc'
    alias enable-line-wrap='tput smam'
    alias disable-line-wrap='tput rmam'
    alias enable-echo='stty echo -raw'
    alias disable-echo='stty raw -echo min 0'
    alias reset-cursor-attrs='show-cursor; enable-line-wrap; enable-echo'
    ;;
  zsh) # TODO Check how to do it
    alias show-cursor='echo -e "\033[?25h"'
    alias hide-cursor='echo -e "\033[?25l"'
    alias save-cursor-pos=''
    alias restore-cursor-pos=''
    alias enable-line-wrap=''
    alias disable-line-wrap=''
    alias enable-echo=''
    alias disable-echo=''
    alias reset-cursor-attrs=''
    ;;
esac

# This alias is going to clear and reset all cursor attributes and IFS
alias __hhs_clear='reset-cursor-attrs; echo -en "\033[2J\033[H${NC}"; export IFS="${RESET_IFS}"'

# Clear the screen and reset the terminal
alias __hhs_reset="cls; \reset"

# -----------------------------------------------------------------------------------
# Perl dependent aliases

if __hhs_has "perl"; then

  # Clean escape (\EscXX) codes from text
  alias __hhs_clean_escapes="perl -pe 's/\x1b((\[[0-9;]*[a-zA-Z])|(\([a-zA-Z]))*//g'"
  # Copy to clipboard pbcopy required
  __hhs_has "pbcopy" && alias clipboard="cse | pbcopy"
fi

# -----------------------------------------------------------------------------------
# Git dependent aliases

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
  alias __hhs_git_pull_rebase='git pull --rebase --autostash --all --verbose --no-recurse-submodules'
  alias __hhs_git_push='git push origin HEAD'
  alias __hhs_git_show='git diff-tree --no-commit-id --name-status -r'
  alias __hhs_git_difftool='git difftool -t opendiff'
fi

# -----------------------------------------------------------------------------------
# Gradle dependent aliases

if __hhs_has "gradle"; then

  alias __hhs_gradle_build='gw clean build'
  alias __hhs_gradle_run='gw bootRun -x Test'
  alias __hhs_gradle_test='gw Test'
  alias __hhs_gradle_init='gw init'
  alias __hhs_gradle_quiet='gw -q'
  alias __hhs_gradle_wrapper='gw wrapper --gradle-version'
  alias __hhs_gradle_tasks='gw -q :tasks --all'
  alias __hhs_gradle_projects='gw -q projects'
fi

# -----------------------------------------------------------------------------------
# Docker dependent aliases
# inspiRED by https://hackernoon.com/handy-docker-aliases-4bd85089a3b8

if __hhs_has "docker" && docker info &> /dev/null; then

  alias __hhs_docker_images='docker images | hl "(REPOSITORY|TAG|IMAGE ID|CREATED|SIZE|$)"'
  alias __hhs_docker_service='docker service'
  alias __hhs_docker_logs='docker logs'
  alias __hhs_docker_remove='docker container rm'
  alias __hhs_docker_remove_image='docker rmi'
  alias __hhs_docker_ps='docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Image}}\t{{.Ports}}\t{{.Status}}"'
  alias __hhs_docker_top='docker stats --format "table {{.Container}}\t{{.Name}}\t{{.CPUPerc}}\t{{.NetIO}}\t{{.BlockIO}}"'
  alias __hhs_docker_ls='docker container ls -a'
  alias __hhs_docker_up='docker-compose up --force-recreate --build --remove-orphans --detach'
  alias __hhs_docker_down='docker-compose stop'
fi

# Load alias definitions
[ -s "${HOME}/.aliasdef" ] && \. "${HOME}/.aliasdef"