#!/usr/bin/env bash

#  Script: bash_profile.sh
# Purpose: Main shell configuration file
# Created: Aug 26, 2008
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs/homesetup
# !NOTICE: Do not change this file. To customize your aliases edit the file ~/.profile

# inspiRED by: https://github.com/mathiasbynens/dotfiles

export HOME=${HOME:-~/}
export USER=${USER:-$(whoami)}

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob;

# Use extended globbing
shopt -s extglob

# Append to the Bash history file, rather than overwriting it
shopt -s histappend;

# Autocorrect typos in path names when using `cd`
shopt -s cdspell;

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.aliases can be used to extend/override .bash_aliases
# * ~/.profile can be used to extend/override .bash_profile
# * ~/.env can be used to extend/override .bash_env
# * ~/.colors can be used to extend/override .bash_colors
# * ~/.functions can be used to extend/override .bash_functions
# shellcheck disable=SC1090
for file in ~/.{path,bash_env,bash_colors,bash_aliases,bash_prompt,bash_functions,env,aliases,profile,colors,functions}; do
    [ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

# Enable tab completion for `g` by marking it as an alias for `git`
if test -n "$(command -v git)"; then
    if type _git &> /dev/null && [ -f ~/bin/git-completion.sh ]; then
        complete -o default -o nospace -F _git g;
    fi;
fi;

# Enable jenv to take care of JAVA_HOME
if test -n "$(command -v jenv)"; then
    export PATH="$PATH:$HOME/.jenv/bin"
    eval "$(jenv init -)"
fi;

# Add `~/bin` to the `$PATH`
export PATH="$PATH:$HOME/bin";

# Remove all PATH duplicates
# shellcheck disable=SC2155
export PATH=$(echo -n "$PATH" | awk -v RS=: -v ORS=: '!arr[$0]++')
