#!/usr/bin/env bash
# shellcheck disable=SC1117

#  Script: bash_prompt.bash
# Purpose: Shell prompt configuration file
# Created: Aug 26, 2018
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <https://opensource.org/licenses/MIT>
# !NOTICE: Do not change this file. To customize your prompt edit the file ~/.prompt

# inspiRED by: https://github.com/mathiasbynens/dotfiles
# Heavily inspiRED by @necolas’s prompt: https://github.com/necolas/dotfiles
# Improved with: http://ezprompt.net

export HHS_ACTIVE_DOTFILES="${HHS_ACTIVE_DOTFILES} bash_prompt"

# Configure git stuff.
function __hhs_git_prompt() {

  local st_flag='' branch_name=''

  # check if the current directory is in .git before running git checks.
  if [[ "$(git rev-parse --is-inside-git-dir 2>/dev/null)" == 'false' ]]; then

    # Ensure the index is up to date.
    git update-index --really-refresh -q &>/dev/null

    # Check for uncommitted changes in the index.
    if ! git diff --quiet --ignore-submodules --cached; then
      st_flag+='+'
    fi

    # Check for unstaged changes.
    if ! git diff-files --quiet --ignore-submodules --; then
      st_flag+='!'
    fi

    # Check for untracked files.
    if [[ -n "$(git ls-files --others --exclude-standard)" ]]; then
      st_flag+='?'
    fi

    # Check for stashed files.
    if git rev-parse --verify refs/stash &>/dev/null; then
      st_flag+='$'
    fi

    # Get the short symbolic ref. If HEAD isn’t a symbolic ref, get the short SHA for the latest commit
    # Otherwise, just give up.
    branch_name="$(git symbolic-ref --quiet --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null || echo '(unknown)')"

    [[ -n "${st_flag}" ]] && st_flag=" [${st_flag}]"

    echo -e "${1}${branch_name}${2}${st_flag}"
  else
    return
  fi
}

if [[ ${COLORTERM} == gnome-* && ${TERM} == xterm ]] && infocmp gnome-256color >/dev/null 2>&1; then
  export TERM='gnome-256color'
elif infocmp xterm-256color >/dev/null 2>&1; then
  export TERM='xterm-256color'
fi

# Icons to be displayed. Check https://fontawesome.com/cheatsheet?from=io for details.
# Use __hhs_utoh <4digit-hex> to find out the octal value of the icon.
HIST_ICN="${HIST_ICN:-\357\207\232}"
USER_ICN="${USER_ICN:-\357\200\207}"
ROOT_ICN="${ROOT_ICN:-\357\224\205}"
GIT_ICN="${GIT_ICN:-\357\204\246}"
AT_ICN="${AT_ICN:-\357\207\272}"
NET_ICN="${NET_ICN:-\357\233\277}"
FOLDER_ICN="${FOLDER_ICN:-\357\201\273}"

# The history number of this command.
HIST_STYLE="\[${WHITE}\]${HIST_ICN} \#"

# Logged username. Highlight when logged in as root.
if [[ "${USER}" == "root" ]]; then
  USER_STYLE="\[${WHITE}\] ${ROOT_ICN}\[${RED}\] \u"
else
  USER_STYLE="\[${WHITE}\] ${USER_ICN}\[${GREEN}\] \u"
fi

# The hostname. Highlight when connected via SSH.
if [[ "${SSH_TTY}" ]]; then
  HOST_STYLE="\[${WHITE}\] ${NET_ICN}\[${RED}\] \H"
else
  HOST_STYLE="\[${WHITE}\] ${AT_ICN}\[${PURPLE}\] \h"
fi

# Working directory base path.
PATH_STYLE="\[${WHITE}\] ${FOLDER_ICN} \[${ORANGE}\] \W"

# Git repository details.
# Check if the current directory is a Git repository.
if __hhs_has git && git rev-parse --is-inside-work-tree &>/dev/null; then
  GIT_STYLE="\[${WHITE}\]\$(__hhs_git_prompt \" ${GIT_ICN} \[${CYAN}\]\")"
else
  GIT_STYLE=''
fi

# User prompt format.
PROMPT="\[${WHITE}\] \$ "

# Set the terminal title and prompt.
# Check ${HHS_HOME}/docs/devel/bash-prompt-codes.md for more details

#unset PROMPT_COMMAND
PROMPT_COMMAND=''

# PS1 Style: Color and icons (default).
PS1_STYLE=$"${HIST_STYLE}${USER_STYLE}${HOST_STYLE}${PATH_STYLE}${GIT_STYLE}${PROMPT}"

# PS2 Style: Continuation prompt.
PS2_STYLE=$'... '

export PS1=${CUSTOM_PS1:-$PS1_STYLE}
export PS2=${CUSTOM_PS2:-$PS2_STYLE}
