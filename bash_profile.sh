#!/usr/bin/env bash

#  Script: bash_profile.sh
# Purpose: Main shell configuration file
# Created: Aug 26, 2008
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs/homesetup
#
# Original project: https://github.com/mathiasbynens/dotfiles

HOME=${HOME:-~/}
USER=${USER:-`whoami`}

# Add `~/bin` to the `$PATH`
export PATH="$HOME/bin:$PATH";

# Languages and encodings
export LANG=en_US.UTF-8
export NLS_LANG=AMERICAN_AMERICA.AL32UTF8

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob;

# Use extended globbing
shopt -s extglob

# Append to the Bash history file, rather than overwriting it
shopt -s histappend;

# Autocorrect typos in path names when using `cd`
shopt -s cdspell;

# Enable tab completion for `g` by marking it as an alias for `git`
if test -n "$(command -v git)"; then
    if type _git &> /dev/null && [ -f ~/bin/git-completion.sh ]; then
        complete -o default -o nospace -F _git g;
    fi;
fi;

# Enable jenv to take care of JAVA_HOME
if test -n "$(command -v jenv)"; then
    export PATH="$HOME/.jenv/bin:$PATH"
    eval "$(jenv init -)"
fi;

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.aliases can be used to extend/override .bash_aliases
# * ~/.profile can be used to extend/override .bash_profile
# * ~/.env can be used to extend/override .bash_env
for file in ~/.{path,bash_env,bash_colors,bash_aliases,bash_prompt,bash_functions,aliases,profile,env}; do
    [ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;
