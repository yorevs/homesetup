# .bashrc

# User specific aliases and functions

# Source global definitions
if [ -f /etc/bashrc ]; then
    source /etc/bashrc
fi

if [ -n "$PS1" -a -f ~/.bash_profile ]; then
    source ~/.bash_profile;
fi

# Setting history length see HISTSIZE and HISTFILESIZE in bash(1)
export HISTSIZE=1000
export HISTFILESIZE=2000
