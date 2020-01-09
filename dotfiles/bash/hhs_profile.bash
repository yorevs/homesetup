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

# Removes all aliases before setting them
unalias -a

# Install and load all dotfiles. Custom dotfiles comes last, so defaults can be overriden.
# Notice that the order here is important, do not reorder it.
for file in ~/.{profile,bash_colors,colors,bash_env,env,bash_prompt,prompt,bash_aliases,bash_aliasdef,aliases,bash_functions,functions}; do
  [ -f "$file" ] && source "$file"
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

if ! [ -f ~/.inputrc ]; then
  echo "set completion-ignore-case on" >~/.inputrc
  echo "set colored-stats on" >>~/.inputrc
else
  case $HHS_MY_OS in
    Darwin)
      sed -i '' -E \
        -e "s/(^set colored-stats) .*/\1 on/g" \
        -e "s/(^set completion-ignore-case) .*/\1 on/g" \
        ~/.inputrc
    ;;
    Linux)
      sed -i'' -r \
        -e "s/(^set colored-stats) .*/\1 on/g" \
        -e "s/(^set completion-ignore-case) .*/\1 on/g" \
        ~/.inputrc
    ;;
  esac
fi

# -----------------------------------------------------------------------------------
# Completions

AUTO_CPL_TYPES=()

case $HHS_MY_SHELL in

  bash)
    AUTO_CPL_D="$HHS_DIR/bin"
    
    # Enable tab completion for `git`
    # Thanks to: https://github.com/git/git/tree/master/contrib/completion
    if command -v git &>/dev/null; then
      if [ -f "$AUTO_CPL_D/git-completion.bash" ]; then
        source "$AUTO_CPL_D/git-completion.bash"
        AUTO_CPL_TYPES+=('Git')
      fi
    fi

    # Enable tab completion for `docker`
    # Thanks to: Built in docker scripts
    if command -v docker &>/dev/null; then
      if [ -f "$AUTO_CPL_D/docker-compose-completion.bash" ]; then
        source "$AUTO_CPL_D/docker-compose-completion.bash"
        AUTO_CPL_TYPES+=('Docker-Compose')
      fi
      if [ -f "$AUTO_CPL_D/docker-machine-completion.bash" ]; then
        source "$AUTO_CPL_D/docker-machine-completion.bash"
        AUTO_CPL_TYPES+=('Docker-Machine')
      fi
      if [ -f "$AUTO_CPL_D/docker-completion.bash" ]; then
        source "$AUTO_CPL_D/docker-completion.bash"
        AUTO_CPL_TYPES+=('Docker')
      fi
    fi

    # Enable tab completion for `gradle`
    # Thanks to: https://github.com/gradle/gradle-completion
    if command -v gradle &>/dev/null; then
        if [ -f "$AUTO_CPL_D/gradle-completion.bash" ]; then
          source "$AUTO_CPL_D/gradle-completion.bash"
          AUTO_CPL_TYPES+=('Gradle')
        fi
    fi
    
    # Enable tab completion for `HomeSetup`
    source "$AUTO_CPL_D/hhs-completion.bash"
    AUTO_CPL_TYPES+=('HomeSetup')
  ;;

esac

export HHS_AUTO_COMPLETIONS="${AUTO_CPL_TYPES[*]}"

unset AUTO_CPL_TYPES

# Add custom paths to the system `$PATH`
if [ -f "$HOME/.path" ]; then
  export PATH="$(grep . "$HOME/.path" | tr '\n' ':'):$PATH"
fi

# term_reset() {
#   show-cursor
#   enable-line-wrap
#   echo -e "${NC}"
#   trap SIGINT
# }

# trap term_reset SIGINT

# Add `$HHS_DIR/bin` to the system `$PATH`
paths -q -a "$HHS_DIR/bin"

# Check for updates
__hhs_auto-update-check
