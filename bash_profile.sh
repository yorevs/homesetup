#!/usr/bin/env bash
# shellcheck disable=SC2155,SC1090

#  Script: bash_profile.sh
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
[ "Darwin" = "${MY_OS}" ] && sed -i '' -E "s#(^set completion-ignore-case .*)*#set completion-ignore-case On#g" ~/.inputrc
[ "Linux" = "${MY_OS}" ] && sed -i'' -r "s#(^set completion-ignore-case .*)*#set completion-ignore-case On#g" ~/.inputrc

# Load the shell dotfiles, and then:
#   source -> ~/.path can be used to extend `$PATH`.
#   source -> ~/.aliases can be used to extend/override .bash_aliases
#   source -> ~/.profile can be used to extend/override .bash_profile
#   source -> ~/.env can be used to extend/override .bash_env
#   source -> ~/.colors can be used to extend/override .bash_colors
#   source -> ~/.functions can be used to extend/override .bash_functions

# Install and load all dotfiles. Custom dotfiles comes last, so defaults can be overriden.
for file in ~/.{bash_env,bash_colors,bash_aliases,prompt,bash_prompt,bash_functions,profile,env,aliases,functions}; do
    [ -r "$file" ] && [ -f "$file" ] && \. "$file";
done;

unset file

# Add custom paths to the system `$PATH`
if [ -f "$HOME/.path" ]; then
    export PATH="$(grep . "$HOME/.path" | tr '\n' ':'):$PATH"
fi

# Add `$HOME/bin` to the system `$PATH`
paths -a "$HOME/bin"

# Remove all `$PATH` duplicates
export PATH=$(echo -n "$PATH" | awk -v RS=: -v ORS=: '!arr[$0]++')
