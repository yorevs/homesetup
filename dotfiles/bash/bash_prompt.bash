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

  if __hhs_has git && git rev-parse --is-inside-work-tree &>/dev/null; then

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
    
  fi
}

if [[ ${COLORTERM} == gnome-* && ${TERM} == xterm ]] && infocmp gnome-256color >/dev/null 2>&1; then
  export TERM='gnome-256color'
elif infocmp xterm-256color >/dev/null 2>&1; then
  export TERM='xterm-256color'
fi

# Prompt colors
PROMPT_COLOR="\[${HHS_PROMPT_COLOR:-$WHITE}\]"
ALERT_COLOR="\[${RED}\]"
OK_COLOR="\[${GREEN}\]"
DIR_COLOR="\[${ORANGE}\]"
GIT_COLOR="\[${CYAN}\]"
HOST_COLOR="\[${PURPLE}\]"

# Prompt icons
MACOS_ICN="\357\205\271"
LINUX_ICN="\357\214\232"
UBUNTU_ICN="\357\214\233"
CENTOS_ICN="\357\214\204"
FEDORA_ICN="\357\214\213"

USER_ICN="\357\220\225"
ROOT_ICN="\357\222\234"
AT_ICN="\357\207\272"
NET_ICN="\357\203\250"
FOLDER_ICN="\357\201\273"
GIT_ICN="\357\204\246"

# Icons to be displayed. Check https://fontawesome.com/cheatsheet?from=io for details.
# Use __hhs_utoh <4digit-hex> to find out the octal value of the icon.

MY_OS="$(uname -s)"

case "${MY_OS}" in
  Darwin)
    MY_OS_ICN="${MACOS_ICN}"
  ;;
  Linux)
    # Most of linux distros have this file to detect the releases.
    OS_RELEASE="$(grep '^ID=' '/etc/os-release' 2>/dev/null)"
    OS_RELEASE="${OS_RELEASE#*=}"    # Extracting ID=
    OS_RELEASE="${OS_RELEASE//\"/}"  # Removing leading quotes
    case "${OS_RELEASE}" in
      ubuntu)
        MY_OS_ICN="${UBUNTU_ICN}"
      ;;
      centos)
        MY_OS_ICN="${CENTOS_ICN}"
      ;;
      fedora)
        MY_OS_ICN="${FEDORA_ICN}"
      ;;
      *)
        MY_OS_ICN="${LINUX_ICN}"
      ;;
    esac
  ;;
  *)
    MY_OS_ICN="${LINUX_ICN}"
  ;;
esac

# Terminal title.
TITLE="HomeSetup-v${HHS_VERSION}"
ESCAPED_TITLE="\[\e]2;${TITLE}\a\]"

# The history number of this command.
HIST_STYLE="${PROMPT_COLOR}${MY_OS_ICN} (\!)"

# Logged username. Highlight when logged in as root.
if [[ "${USER}" == "root" ]]; then
  USER_STYLE="${PROMPT_COLOR} ${ROOT_ICN}${ALERT_COLOR} \u"
else
  USER_STYLE="${PROMPT_COLOR} ${USER_ICN}${OK_COLOR} \u"
fi

# The hostname. Highlight when connected via SSH.
if [[ "${SSH_TTY}" ]]; then
  HOST_STYLE="${PROMPT_COLOR} ${NET_ICN}${ALERT_COLOR} \H"
else
  HOST_STYLE="${PROMPT_COLOR} ${AT_ICN}${HOST_COLOR} \h"
fi

# Working directory base path.
PATH_STYLE="${PROMPT_COLOR} ${FOLDER_ICN} ${DIR_COLOR} \W"

# Git repository details.
# Check if the current directory is a Git repository.
GIT_STYLE="${PROMPT_COLOR}\$(__hhs_git_prompt \" ${GIT_ICN} ${GIT_COLOR}\")"

# User prompt format.
PROMPT="${PROMPT_COLOR}${ESCAPED_TITLE} \$ "

# Set the terminal title and prompt.
# Check ${HHS_HOME}/docs/devel/bash-prompt-codes.md for more details.

# PS1 Style: Color and icons (default).
PS1_STYLE=$"${HIST_STYLE}${USER_STYLE}${HOST_STYLE}${PATH_STYLE}${GIT_STYLE}${PROMPT}"

# PS2 Style: Continuation prompt.
PS2_STYLE=$'... '

export PS1=${HHS_CUSTOM_PS1:-$PS1_STYLE}
export PS2=${HHS_CUSTOM_PS2:-$PS2_STYLE}

unset PROMPT_COMMAND
