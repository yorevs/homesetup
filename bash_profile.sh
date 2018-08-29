#!/usr/bin/env bash

#  Script: bash_profile.sh
# Purpose: Main shell configuration file
# Created: Aug 26, 2008
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#
# Original project: https://github.com/mathiasbynens/dotfiles

HOME=${HOME:-~/}
USER=${USER:-`whoami`}

unset USERNAME

# Add `~/bin` to the `$PATH`
export PATH="$HOME/bin:$PATH";

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob;

# Append to the Bash history file, rather than overwriting it
shopt -s histappend;

# Autocorrect typos in path names when using `cd`
shopt -s cdspell;

# Enable tab completion for `g` by marking it as an alias for `git`
if type _git &> /dev/null && [ -f ~/bin/git-completion.sh ]; then
    complete -o default -o nospace -F _git g;
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
