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
#   \. -> ~/.path can be used to extend `$PATH`
#   \. -> ~/.prompt can be used to extend/override .bash_prompt
#   \. -> ~/.aliases can be used to extend/override .bash_aliases
#   \. -> ~/.profile can be used to extend/override .bash_profile
#   \. -> ~/.env can be used to extend/override .bash_env
#   \. -> ~/.colors can be used to extend/override .bash_colors
#   \. -> ~/.functions can be used to extend/override .bash_functions

# Removes all aliases before setting them
unalias -a

# Install and load all dotfiles. Custom dotfiles comes last, so defaults can be overriden.
# Notice that the order here is important, do not reorder it.
for file in ~/.{profile,bash_colors,colors,bash_env,env,bash_aliases,aliases,bash_prompt,prompt,bash_functions,functions}; do
    [ -f "$file" ] && \. "$file";
done;

unset file

# -----------------------------------------------------------------------------------
# Set default shell options

# If set, bash matches filenames in a case-insensitive fashion when performing pathname expansion.
#unset-nocaseglob

# If set, the extended pattern matching features described above under Pathname Expansion are enabled.
#set-extglob

# If set, minor errors in the spelling of a directory component in a cd command will be corrected.
#set-cdspell

# Make bash check its window size after a process completes
#set-checkwinsize

# If set, bash matches patterns in a case-insensitive fashion when  performing  matching while executing case or [[ conditional commands.
#unset-nocasematch

# This turns off the case-sensitive completion.
[ -f ~/.inputrc ] || echo "set completion-ignore-case On" > ~/.inputrc
[ "Darwin" = "${HHS_MY_OS}" ] && sed -i '' -E "s#(^set completion-ignore-case .*)*#set completion-ignore-case On#g" ~/.inputrc
[ "Linux" = "${HHS_MY_OS}" ] && sed -i'' -r "s#(^set completion-ignore-case .*)*#set completion-ignore-case On#g" ~/.inputrc

# -----------------------------------------------------------------------------------
# Load other stuff

# Enable tab completion for `git` by marking it as an alias for `git`
if command -v git &> /dev/null; then
    if [ "bash" = "$HHS_MY_SHELL" ]; then
        if [ -s "$HHS_DIR/bin/git-completion.sh" ]; then
            \. "$HHS_DIR/bin/git-completion.sh" # This loads git bash complete
            complete -o default -o nospace -F _git g
        fi
    fi
fi

# Add custom paths to the system `$PATH`
if [ -f "$HOME/.path" ]; then
    export PATH="$(grep . "$HOME/.path" | tr '\n' ':'):$PATH"
fi

# Add `$HHS_DIR/bin` to the system `$PATH`
paths -a "$HHS_DIR/bin"

# Remove all `$PATH` duplicates
export PATH=$(echo -n "$PATH" | awk -v RS=: -v ORS=: '!arr[$0]++')
