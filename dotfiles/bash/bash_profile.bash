#!/usr/bin/env bash
# shellcheck disable=SC2155,SC1090

#  Script: bash_profile.bash
# Purpose: This file is user specific remote login file. Environment variables listed in this
#          file are invoked every time the user is logged in remotely i.e. using ssh session.
#          If this file is not present, system looks for either .bash_login or .profile files.
# Created: Aug 26, 2008
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <http://unlicense.org/>
# !NOTICE: Do not change this file. To customize your profile edit the file `~/.profile`

# inspiRED by: https://github.com/mathiasbynens/dotfiles

export HOME=${HOME:-~/}
export USER=${USER:-$(whoami)}

# Load the shell dotfiles, and then:
#   source -> ~/.path can be used to extend `$PATH`
#   source -> ~/.prompt can be used to extend/override .bash_prompt
#   source -> ~/.aliases can be used to extend/override .bash_aliases
#   source -> ~/.profile can be used to extend/override .bash_profile
#   source -> ~/.env can be used to extend/override .bash_env
#   source -> ~/.colors can be used to extend/override .bash_colors
#   source -> ~/.functions can be used to extend/override .bash_functions

# Install and load all dotfiles. Custom dotfiles comes last, so defaults can be overriden.
# Notice that the order here is important, do not reorder it.
DOTFILES=(
  profile bash_colors colors bash_env env bash_prompt prompt
  bash_aliases aliasdef aliases bash_functions functions bash_completions
)

# Load all HomeSetup dotfiles
for file in ${DOTFILES[*]}; do
  [ -f "${HOME}/.${file}" ] && \. "${HOME}/.${file}"
done

unset file

# -----------------------------------------------------------------------------------
# Set default shell options

case $HHS_MY_SHELL in

  bash)
    # If set, bash matches filenames in a case-insensitive fashion when performing pathname expansion.
    shopt -u nocaseglob
    # If set, the extended pattern matching features described above under Pathname Expansion are enabled.
    shopt -s extglob
    # If set, minor errors in the spelling of a directory component in a cd command will be corrected.
    shopt -s cdspell
    # Make bash check its window size after a process completes
    shopt -s checkwinsize
    # If set, bash matches patterns in a case-insensitive fashion when  performing  matching while executing case or [[ conditional commands.
    shopt -u nocasematch
    export HHS_TERM_OPTS='nocaseglob extglob cdspell checkwinsize nocasematch'
    ;;
  *)
    export HHS_TERM_OPTS=''
    ;;
esac

# Input-rc Options:
# - completion-ignore-case: Turns off the case-sensitive completion
# - colored-stats: Displays possible completions using different colors to indicate their type
# - <shift>+<tab> Will cicle forward though complete options

if ! [ -f ~/.inputrc ]; then
  {
    echo "set completion-ignore-case on"
    echo "set colored-stats on"
    echo "TAB: complete"
    echo "\"\e[Z\": menu-complete"
  } > ~/.inputrc
else
  case $HHS_MY_OS in
    Darwin)
      sed -i '' -E \
        -e 's/(^set colored-stats) .*/\1 on/g' \
        -e 's/(^set completion-ignore-case) .*/\1 on/g' \
        -e 's/(^TAB:) .*/\1 complete/g' \
        -e 's/(^\"\e\[Z\":) .*/\1 menu-complete/g' \
        ~/.inputrc
      ;;
    Linux)
      sed -i'' -r \
        -e 's/(^set colored-stats) .*/\1 on/g' \
        -e 's/(^set completion-ignore-case) .*/\1 on/g' \
        -e 's/(^TAB:) .*/\1 complete/g' \
        -e 's/(^\"\e\[Z\":) .*/\1 menu-complete/g' \
        ~/.inputrc
      ;;
  esac
fi

# Add custom paths to the system `$PATH`
[ -f "$HOME/.path" ] && export PATH="$(grep . "$HOME/.path" | tr '\n' ':'):$PATH"

# Add `$HHS_DIR/bin` to the system `$PATH`
paths -q -a "$HHS_DIR/bin"

# Check for updates
hhs updater execute --check

# Erase what is before the MOTD message and print HHS MOTD
echo -e "\033[1J\033[H${HHS_MOTD}${NC}"
