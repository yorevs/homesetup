#!/usr/bin/env bash
# shellcheck disable=SC1117

#  Script: bash_prompt.sh
# Purpose: Shell prompt configuration file
# Created: Aug 26, 2008
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <http://unlicense.org/>
# !NOTICE: Do not change this file. To customize your prompt edit the file ~/.prompt

# inspiRED by: https://github.com/mathiasbynens/dotfiles
# Heavily inspiRED by @necolas’s prompt: https://github.com/necolas/dotfiles
# Improved with: http://ezprompt.net

if [[ $COLORTERM = gnome-* && $TERM = xterm ]] && infocmp gnome-256color >/dev/null 2>&1; then
    export TERM='gnome-256color';
elif infocmp xterm-256color >/dev/null 2>&1; then
    export TERM='xterm-256color';
fi;

# Configure git stuff
function prompt_git() {
    local s='';
    local branchName='';

    # Check if the current directory is in a Git repository.
    if [ -n "$(command -v git)" ] && [ "$(git rev-parse --is-inside-work-tree &>/dev/null; echo "${?}")" == '0' ]
    then

        # check if the current directory is in .git before running git checks
        if [ "$(git rev-parse --is-inside-git-dir 2> /dev/null)" == 'false' ]; then

            # Ensure the index is up to date.
            git update-index --really-refresh -q &>/dev/null;

            # Check for uncommitted changes in the index.
            if ! git diff --quiet --ignore-submodules --cached; then
                s+='+';
            fi;

            # Check for unstaged changes.
            if ! git diff-files --quiet --ignore-submodules --; then
                s+='!';
            fi;

            # Check for untracked files.
            if [ -n "$(git ls-files --others --exclude-standard)" ]; then
                s+='?';
            fi;

            # Check for stashed files.
            if git rev-parse --verify refs/stash &>/dev/null; then
                s+='$';
            fi;

        fi;

        # Get the short symbolic ref.
        # If HEAD isn’t a symbolic ref, get the short SHA for the latest commit
        # Otherwise, just give up.
        branchName="$(git symbolic-ref --quiet --short HEAD 2> /dev/null || \
            git rev-parse --short HEAD 2> /dev/null || \
            echo '(unknown)')";

        [ -n "${s}" ] && s=" [${s}]";

        echo -e "${1}${branchName}${2}${s}";
    else
        return;
    fi;
}

# Command history style
HIST_STYLE="${WHITE}${HIST_ICN} ";

# Highlight the user name when logged in as root.
if [[ "${USER}" == "root" ]]; then
    USER_STYLE="${WHITE} ${ROOT_ICN} ${RED}";
else
    USER_STYLE="${WHITE} ${USER_ICN} ${GREEN}";
fi;

# Highlight the hostname when connected via SSH.
if [[ "${SSH_TTY}" ]]; then
    HOST_STYLE="${WHITE} ${NET_ICN} ${RED}";
else
    HOST_STYLE="${WHITE} ${AT_ICN} ${PURPLE}";
fi;

# Folder and Git styles
PATH_STYLE="${WHITE} ${FOLDER_ICN} ${ORANGE}";
GIT_STYLE="${WHITE} ${GIT_ICN} ${CYAN}\" \"${BLUE}";

# User prompt
PROMPT="${WHITE} \$>${NC} "

# Set the terminal title and prompt.
# Check ${HOME_SETUP}/misc/prompt-codes.txt for more details

PS1="${HIST_STYLE}\!"; # The history number of this command
PS1+="${USER_STYLE}\u"; # Logged username
PS1+="${HOST_STYLE}\h"; # Hostname
PS1+="${PATH_STYLE}\W"; # Working directory base path
PS1+="\$(prompt_git \"${GIT_STYLE}\")"; # Git repository details
PS1+="${PROMPT}"; # Prompt symbol
export PS1;

PS2="${PROMPT}";
export PS2;
