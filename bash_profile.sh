#!/usr/bin/env bash
# shellcheck disable=SC2155,SC1090

#  Script: bash_profile.sh
# Purpose: Main shell configuration file
# Created: Aug 26, 2008
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs/homesetup
# !NOTICE: Do not change this file. To customize your aliases edit the file `~/.profile`

# inspiRED by: https://github.com/mathiasbynens/dotfiles

export HOME=${HOME:-~/}
export USER=${USER:-$(whoami)}

# If set, bash matches filenames in a case-insensitive fashion when performing pathname expansion.
shopt -u nocaseglob

# If set, the extended pattern matching features described above under Pathname Expansion are enabled.
shopt -s extglob

# If set, minor errors in the spelling of a directory component in a cd command will be corrected.
shopt -s cdspell

# If set, bash matches patterns in a case-insensitive fashion when  performing  matching while executing case or [[ conditional commands.
shopt -u nocasematch

# This turns off the case-sensitive completion.
[ -f ~/.inputrc ] || echo "set completion-ignore-case On" > ~/.inputrc
[ "Darwin" = "$(uname -s)" ] && sed -i '' -E "s#(^set completion-ignore-case .*)*#set completion-ignore-case On#g" ~/.inputrc
[ "Linux" = "$(uname -s)" ] && sed -i'' -r "s#(^set completion-ignore-case .*)*#set completion-ignore-case On#g" ~/.inputrc

# Load the shell dotfiles, and then:
#   source -> ~/.path can be used to extend `$PATH`.
#   source -> ~/.aliases can be used to extend/override .bash_aliases
#   source -> ~/.profile can be used to extend/override .bash_profile
#   source -> ~/.env can be used to extend/override .bash_env
#   source -> ~/.colors can be used to extend/override .bash_colors
#   source -> ~/.functions can be used to extend/override .bash_functions

# Install and load all dotfiles. Custom dotfiles comes last, so defaults can be overriden.
for file in ~/.{bash_env,bash_colors,bash_aliases,bash_prompt,bash_functions,env,aliases,profile,colors,functions}; do
    [ -r "$file" ] && [ -f "$file" ] && source "$file";
done;

unset file

# Enable tab completion for `git` by marking it as an alias for `git`
if [ -n "$(command -v git)" ]; then
    if type _git &> /dev/null && [ -f ~/bin/git-completion.sh ]; then
        complete -o default -o nospace -F _git g
    fi;
fi;

# Add `~/bin` to the system `$PATH`
export PATH="$PATH:$HOME/bin"

# Add custom paths to the system `$PATH`
if [ -f ~/.path ]; then
    export PATH="$(grep . ~/.path | tr '\n' ':'):$PATH"
fi

# Remove all `$PATH` duplicates
export PATH=$(echo -n "$PATH" | awk -v RS=: -v ORS=: '!arr[$0]++')
