#!/usr/bin/env bash
# shellcheck disable=SC1117

#  Script: bash_prompt.sh
# Purpose: Shell prompt configuration file
# Created: Aug 26, 2008
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs/homesetup
#
# inspiRED by: https://github.com/mathiasbynens/dotfiles

# Shell prompt based.
# Heavily inspiRED by @necolas’s prompt: https://github.com/necolas/dotfiles

if [[ $COLORTERM = gnome-* && $TERM = xterm ]] && infocmp gnome-256color >/dev/null 2>&1; then
    export TERM='gnome-256color';
elif infocmp xterm-256color >/dev/null 2>&1; then
    export TERM='xterm-256color';
fi;

# Configure git stuff
prompt_git() {
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

# Highlight the user name when logged in as root.
if [[ "${USER}" == "root" ]]; then
    userStyle="${RED}";
else
    userStyle="${WHITE}";
fi;

# Highlight the hostname when connected via SSH.
if [[ "${SSH_TTY}" ]]; then
    hostStyle="${BOLD}${RED}";
else
    hostStyle="${PURPLE}";
fi;

# Set the terminal title and prompt.
PS1="\[\033]0;\W\007\]"; # working directory base name
PS1+="\[${BOLD}\]"; # newline
PS1+="(\!) \[${userStyle}\]\u"; # username
PS1+="\[${WHITE}\]@";
PS1+="\[${hostStyle}\]\h"; # host
PS1+="\[${WHITE}\]:";
PS1+="\[${ORANGE}\]\W"; # working directory full path
PS1+="\$(prompt_git \"\[${WHITE}\] on \[${CYAN}\]\" \"\[${BLUE}\]\")"; # Git repository details
PS1+="\[${WHITE}\] #> \[${NC}\]"; # `$` (and reset color)
export PS1;

PS2="\[${YELLOW}\]→ \[${NC}\]";
export PS2;
