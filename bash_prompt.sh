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

# Icons to be displayed. Check https://fontawesome.com/cheatsheet?from=io for details
HIST_ICN="\357\207\232"
USER_ICN="\357\200\207"
ROOT_ICN="\357\224\205"
GIT_ICN="\357\204\246"
AT_ICN="\357\207\272"
NET_ICN="\357\233\277"
FOLDER_ICN="\357\201\273"

# Command history style
HIST_STYLE="\[${HIST_ICN}\] ";

# Highlight the user name when logged in as root.
if [[ "${USER}" == "root" ]]; then
    USER_STYLE="\[${ROOT_ICN}\] ${RED}";
else
    USER_STYLE="\[${USER_ICN}\] ${WHITE}";
fi;

# Highlight the hostname when connected via SSH.
if [[ "${SSH_TTY}" ]]; then
    HOST_STYLE+="\[${NET_ICN}\] ${RED}";
else
    HOST_STYLE+="\[${AT_ICN}\] ${PURPLE}";
fi;

# Folder and Git styles
FOLDER_STYLE="\[${FOLDER_ICN}\] \[${ORANGE}\]";
GIT_STYLE="\[${WHITE}\] \[${GIT_ICN}\] \[${CYAN}\]\" \"\[${BLUE}\]";

# User prompt
PROMPT="\$> "

# Set the terminal title and prompt.
PS1="\[${WHITE}\]\[${HIST_STYLE}\]\!"; # The history number of this command
PS1+="\[${WHITE}\] \[${USER_STYLE}\]\u"; # Logged username
PS1+="\[${WHITE}\] \[${HOST_STYLE}\]\h"; # Hostname
PS1+="\[${WHITE}\] \[${FOLDER_STYLE}\]\W"; # Working directory full path
PS1+="\$(prompt_git \"\[${GIT_STYLE}\]\")"; # Git repository details
PS1+="\[${WHITE}\] \[${PROMPT}\]"; # Prompt symbol
PS1+="\[${NC}\]"; # Reset default color
export PS1;

PS2="\[${YELLOW}\]→ \[${NC}\]";
export PS2;
