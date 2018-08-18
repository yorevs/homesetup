#!/usr/bin/env bash

HOME=${HOME:-~/}
USER=${USER:-hugo}

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
# * ~/.extra can be used for other settings you don’t want to commit.
# * ~/.aliases can be used to extend .bash_aliases
# * ~/.profile can be used to extend .bash_profile
for file in ~/.{path,extra,bash_env,bash_colors,bash_aliases,bash_prompt,bash_functions,aliases,profile,env}; do
    [ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;
