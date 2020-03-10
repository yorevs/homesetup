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

# Remove all aliases before setting them again.
unalias -a

# @function: Check if a command is available on the current shell session.
# @param $1 [Req] : The command to check.
function __hhs_has() {
  [[ $# -eq 0 || '-h' == "$1" ]] && echo "Usage: ${FUNCNAME[0]} <command>" && return 1
  type "$1" > /dev/null 2>&1
}

# shellcheck disable=SC2139
# @function: Check if an alias does not exists and create it, otherwise just ignore it. Do not support the use of single quotes in the expression
# @param $1 [Req] : The alias to set/check.
# @param $* [Req] : The alias expression.
function __hhs_alias() {
  
  local all_args alias_expr alias_name
  
  [[ $# -eq 0 || '-h' == "$1" ]] && echo "Usage: ${FUNCNAME[0]} <alias_name>='<alias_expr>" && return 1

  all_args="${*}"
  alias_expr="${all_args#*=}"
  alias_name="${all_args//=*/}"

  if ! type "$alias_name" > /dev/null 2>&1; then
    if alias "${alias_name}"="${alias_expr}" > /dev/null 2>&1; then
      return 0
    else
      echo "${RED}Failed to alias: \"${alias_name}\" !${NC}" 2>&1
      return 1
    fi
  fi

  return 1
}

# -----------------------------------------------------------------------------------
# @category: Navigational

# @alias: Change-back two previous directories
alias ...='.. 2'
# @alias: Change-back three previous directories
alias ....='.. 3'
# @alias: Change-back four previous directories
alias .....='.. 4'
# @alias: Change the current directory to HOME dir
alias ~='cd ~'
# @alias: Change the current directory to the previous dir
alias -- -='cd -'

# shellcheck disable=SC2139,SC2035
# @alias: Display the current directory path
alias ?='pwd'

# -----------------------------------------------------------------------------------
# @category: General

# @alias: Short for `exit 0' from terminal
alias q="exit 0"

# @alias: Enable aliases to be sudo’ed
alias sudo='sudo '

# @alias: Always use color output for `ls`
alias ls='\ls ${COLOR_FLAG} -F'

# @alias: List all files colorized in long format
alias l='ls -lh'

# @alias: List all directories in long format
alias lsd="ls -d */"

# @alias: List all files colorized in long format, including dot files
alias ll='ls -lah'

# @alias: List all .dotfiles colorized in long format
alias lll='ls -lhd .??* | grep "^-"'

# @alias: List all .dotfolders colorized in long format
alias lld='ls -lhd .??*/'

# @alias: Always enable colored `grep` output
alias grep='\grep --color=auto' # Note: `GREP_OPTIONS="--color=auto"` is deprecated, hence the alias usage.
# @alias: Always enable colored `fgrep` output
alias fgrep='\fgrep --color=auto'
# @alias: Always enable colored `egrep` output
alias egrep='\egrep --color=auto'

# @alias: By default `rm' will prompt for confirmation and will be verbose
alias rm='\rm -iv'
# @alias: By default `cp' will prompt for confirmation and will be verbose
alias cp='\cp -iv'
# @alias: By default `mv' will prompt for confirmation and will be verbose
alias mv='\mv -iv'

# @alias: Make `df' command output pretty and human readable format
alias df='\df -H'
# @alias: Make `du' command output pretty and human readable format
alias du='\du -hcd 1'
# @alias: Make `ps' command output pretty and human readable format
alias psg='\ps aux | \grep -v grep | \grep -i -e VSZ -e'

# @alias: Use `vim' instead of `vi' if installed
__hhs_has "vim" && alias vi='\vim'

# @alias: `more' will interpret escape sequences
alias more='\more -r'
# @alias: `less' will interpret escape sequences
alias less='\less -r'

# @alias: Make `mount' command output pretty and human readable format
alias mount='\mount | column -t'

# @alias: `top' shortcut ordered by cpu
alias cpu='\top -o cpu'

# @alias: `top' shortcut ordered by Memory
alias mem='\top -o rsize'

# @alias: Date&Time - Display current week number
alias week='\date +%V'
# @alias: Date&Time - Display current date and time
alias now='\date +"(Week:%V) %Y-%m-%d %T %Z"'
# @alias: Date&Time - Display current timestamp
alias ts='\date "+%s%S"'
# @alias: Date&Time - Display current time in millis
alias time-ms='python -c "import time; print(int(round(time.time() * 1000)))"'

# @alias: If `wget' is not available, use `curl' instead
__hhs_has "wget" || alias wget='\curl -O'

# @alias: Make PS1 prompt active
alias ps1='export PS1=$PS1_STYLE'
# @alias: Make PS2 prompt active
alias ps2='export PS1=$PS2_STYLE'

# @alias: Execute the previous command again, but this time running with sudo.
alias please='sudo !!'

# -----------------------------------------------------------------------------------
# @category: HomeSetup

# @alias: Shortcut for hhs vault plug-in
alias __hhs_vault='hhs vault execute'
# @alias: Shortcut for hhs hspm plug-in
alias __hhs_hspm='hhs hspm execute'
# @alias: Shortcut for hhs firebase plug-in
alias __hhs_dotfiles='hhs firebase execute'
# @alias: Shortcut for hhs updater plug-in
alias __hhs_hhu='hhs updater execute'
# @alias: Reload HomeSetup
alias __hhs_reload='cls; source ${HOME}/.bashrc'
# @alias: Clear and reset all cursor attributes and IFS
alias __hhs_clear='reset-cursor-attrs; echo -en "\033[2J\033[H${NC}"; export IFS="${RESET_IFS}"'
# @alias: Clear the screen and reset the terminal
alias __hhs_reset="__hhs_clear; \reset"

# -----------------------------------------------------------------------------------
# @category: Tool aliases

# @alias: Jenv - Set JAVA_HOME using jenv
__hhs_has "jenv" && alias jenv_set_java_home='export JAVA_HOME="${HOME}/.jenv/versions/`jenv version-name`"'

# @alias: Dropbox - Recursively delete Dropbox conflicted files from the current directory
[[ -d "${DROPBOX}" ]] && alias cleanup-db="find . -name *\ \(*conflicted* -exec rm -v {} \;"

# @alias: Shortcut for base64 encode
__hhs_has "base64" && alias encode="base64"

# -----------------------------------------------------------------------------------
# @category: OS Specific aliases

# Linux boxes have a different syntax for some commands, so we create the alias to match the correct OS.
case "${HHS_MY_OS}" in

  Linux)
    # @alias: Same as sed -i'' -r (Linux)
    alias ised="sed -i'' -r"
    # @alias: Same as sed -r (Linux)
    alias esed="sed -r"
    # @alias: Shortcut for base64 decode (Linux)
    __hhs_has "base64" && alias decode='base64 -d'
    ;;

  Darwin)
    # @alias: Same as sed -i '' -E (Darwin)
    alias ised="sed -i '' -E"
    # @alias: Same as sed -E (Darwin)
    alias esed="sed -E"
    # @alias: Shortcut for base64 decode (Darwin)
    __hhs_has "base64" && alias decode='base64 -D'

    # @alias: Delete all .DS_store files recursively
    alias cleanup-ds="find . -type f -name '*.DS_Store' -ls -delete"

    # @alias: Flush Directory Service cache
    __hhs_has "dscacheutil" && alias flush="dscacheutil -flushcache && killall -HUP mDNSResponder"

    # @alias: Clean up LaunchServices to remove duplicates in the "Open With" menu
    alias cleanup-reg="/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user && killall Finder"

    # @alias: Show hidden files in Finder
    alias show-files="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
    # @alias: Hide hidden files in Finder
    alias hide-files="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"

    # @alias: Show all desktop icons
    alias show-deskicons="defaults write com.apple.finder CreateDesktop -bool true && killall Finder"
    # @alias: Hide all desktop icons
    alias hide-deskicons="defaults write com.apple.finder CreateDesktop -bool false && killall Finder"

    # @alias: Canonical hex dump; some systems have this symlinked
    __hhs_has "hd" || alias hd='\hexdump -C'

    # @alias: If `md5sum' is not available, use `md5' instead`
    __hhs_has "md5sum" || alias md5sum='\md5'

    # @alias: If `sha1' is not available, use `shasum' instead`
    __hhs_has "sha1" || alias sha1='\shasum'
    ;;
esac

# -----------------------------------------------------------------------------------
# @category: Handy Terminal Shortcuts

case "${HHS_MY_SHELL}" in

  bash)
    # @alias: Make terminal cursor visible (Bash)
    alias show-cursor='tput cnorm'
    # @alias: Make terminal cursor invisible (Bash)
    alias hide-cursor='tput civis'
    # @alias: Save terminal cursor position (Bash)
    alias save-cursor-pos='tput sc'
    # @alias: Restore terminal cursor position (Bash)
    alias restore-cursor-pos='tput rc'
    # @alias: Enable terminal line wrap (Bash)
    alias enable-line-wrap='tput smam'
    # @alias: Disable terminal line wrap (Bash)
    alias disable-line-wrap='tput rmam'
    # @alias: Enable terminal echo (Bash)
    alias enable-echo='stty echo -raw'
    # @alias: Disable terminal echo (Bash)
    alias disable-echo='stty raw -echo min 0'
    # @alias: Reset all terminal cursor attributes (Bash)
    alias reset-cursor-attrs='show-cursor; enable-line-wrap; enable-echo'
    ;;
  zsh)
    # @alias: Make terminal cursor visible (Zsh)
    alias show-cursor='echo -e "\033[?25h"'
    # @alias: Make terminal cursor invisible (Zsh)
    alias hide-cursor='echo -e "\033[?25l"'
    # @alias: Save terminal cursor position (Zsh)
    alias save-cursor-pos='' # TODO Check how to do
    # @alias: Restore terminal cursor position (Zsh)
    alias restore-cursor-pos='' # TODO Check how to do
    # @alias: Enable terminal line wrap (Zsh)
    alias enable-line-wrap='' # TODO Check how to do
    # @alias: Disable terminal line wrap (Zsh)
    alias disable-line-wrap='' # TODO Check how to do
    # @alias: Enable terminal echo (Zsh)
    alias enable-echo='' # TODO Check how to do
    # @alias: Disable terminal echo (Zsh)
    alias disable-echo='' # TODO Check how to do
    # @alias: Reset all terminal cursor attributes (Zsh)
    alias reset-cursor-attrs='' # TODO Check how to do
    ;;
esac

# -----------------------------------------------------------------------------------
# @category: Python aliases

if __hhs_has "python"; then

  # @alias: Evaluate mathematical expressions
  alias calc='python -c "import sys,math; print(eval(\" \".join(sys.argv[1:])));"'
  # @alias: URL-encode strings
  alias urle='python -c "import sys, urllib as ul; print ul.quote_plus(sys.argv[1]);"'
  # @alias: URL-decode strings
  alias urld='python -c "import sys, urllib as ul; print ul.unquote_plus(sys.argv[1]);"'
  # @alias: Generate a UUID
  alias uuid='python -c "import uuid as ul; print(ul.uuid4())"'
fi

# -----------------------------------------------------------------------------------
# @category: Perl aliases

if __hhs_has "perl"; then

  # @alias: Remove escape (\EscXX) codes from text
  alias clean_escapes="perl -pe 's/\x1b((\[[0-9;]*[a-zA-Z])|(\([a-zA-Z]))*//g'"
  # @alias: Copy to clipboard removing any escape sequences. pbcopy is required
  __hhs_has "pbcopy" && alias clipboard="clean_escapes | pbcopy"
fi

# -----------------------------------------------------------------------------------
# @category: Git aliases

if __hhs_has "git"; then

  # @alias: Git - Enhancement for `git status'
  alias __hhs_git_status='git status && gl -n 1'
  # @alias: Git - Shortcut for `git fetch'
  alias __hhs_git_fetch='git fetch -p'
  # @alias: Git - Shortcut for `git log'
  alias __hhs_git_history='git log -p'
  # @alias: Git - Shortcut for `git branch'
  alias __hhs_git_branch='git branch'
  # @alias: Git - Shortcut for `git diff'
  alias __hhs_git_diff='git diff'
  # @alias: Git - Shortcut for `git pull'
  alias __hhs_git_pull='git pull'
  # @alias: Git - Enhancement for `git log'
  alias __hhs_git_log='git log --oneline --graph --decorate --pretty=format:"%C(blue)%h%C(red)%d %C(yellow)(%cr) %C(cyan)<%ce> %C(white)\"%s\"%Creset"'
  # @alias: Git - Shortcut for `git checkout'
  alias __hhs_git_checkout='git checkout'
  # @alias: Git - Shortcut for `git add'
  alias __hhs_git_add='git add'
  # @alias: Git - Shortcut for `git commit'
  alias __hhs_git_commit='git commit -m'
  # @alias: Git - Shortcut for `git commit amend'
  alias __hhs_git_amend='git commit --amend --no-edit'
  # @alias: Git - Shortcut for `git pull rebase'
  alias __hhs_git_pull_rebase='git pull --rebase --autostash --all --verbose --no-recurse-submodules'
  # @alias: Git - Shortcut for `git push'
  alias __hhs_git_push='git push origin HEAD'
  # @alias: Git - Enhancement for `git diff-tree'
  alias __hhs_git_show='git diff-tree --no-commit-id --name-status -r'
  # @alias: Git - Enhancement for `git difftool'
  alias __hhs_git_difftool='git difftool -t opendiff'
fi

# -----------------------------------------------------------------------------------
# @category: Gradle aliases

if __hhs_has "gradle"; then

  # @alias: Gradle - Enhancement for `gradle build'
  alias __hhs_gradle_build='gw clean build'
  # @alias: Gradle - Enhancement for `gradle bootRun'
  alias __hhs_gradle_run='gw bootRun -x Test'
  # @alias: Gradle - Shortcut for `gradle Test'
  alias __hhs_gradle_test='gw Test'
  # @alias: Gradle - Shortcut for `gradle init'
  alias __hhs_gradle_init='gw init'
  # @alias: Gradle - Shortcut for `gradle -q'
  alias __hhs_gradle_quiet='gw -q'
  # @alias: Gradle - Shortcut for `gradle wrapper'
  alias __hhs_gradle_wrapper='gw wrapper --gradle-version'
  # @alias: Gradle -  Displays all available gradle projects
  alias __hhs_gradle_projects='gw -q projects'
  # @alias: Gradle - Displays all available gradle project tasks
  alias __hhs_gradle_tasks='gw -q :tasks --all'
fi

# -----------------------------------------------------------------------------------
# @category: Docker aliases

# inspiRED by https://hackernoon.com/handy-docker-aliases-4bd85089a3b8
if __hhs_has "docker" && docker info &> /dev/null; then

  # @alias: Docker - Enhancement for `docker images'
  alias __hhs_docker_images='docker images | hl "(REPOSITORY|TAG|IMAGE ID|CREATED|SIZE|$)"'
  # @alias: Docker - Shortcut for `docker service'
  alias __hhs_docker_service='docker service'
  # @alias: Docker - Shortcut for `docker logs'
  alias __hhs_docker_logs='docker logs'
  # @alias: Docker - Shortcut for `docker container rm'
  alias __hhs_docker_remove='docker container rm'
  # @alias: Docker - Shortcut for `docker rmi'
  alias __hhs_docker_remove_image='docker rmi'
  # @alias: Docker - Enhancement for `docker ps'
  alias __hhs_docker_ps='docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Image}}\t{{.Ports}}\t{{.Status}}"'
  # @alias: Docker - Enhancement for `docker stats'
  alias __hhs_docker_top='docker stats --format "table {{.Container}}\t{{.Name}}\t{{.CPUPerc}}\t{{.NetIO}}\t{{.BlockIO}}"'
  # @alias: Docker - Enhancement for `docker container ls'
  alias __hhs_docker_ls='docker container ls -a'
  # @alias: Docker - Enhancement for `docker compose up'
  alias __hhs_docker_up='docker-compose up --force-recreate --build --remove-orphans --detach'
  # @alias: Docker - Shortcut for `docker compose stop'
  alias __hhs_docker_down='docker-compose stop'
fi

# Load alias definitions
[[ -s "${HOME}/.aliasdef" ]] && \. "${HOME}/.aliasdef"
