# .bashrc

#  Script: bash_prompt.sh
# Purpose: Shell configuration main entry point file
# Created: Aug 26, 2008
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com

# Source global definitions
if [ -f /etc/bashrc ]
then
    source /etc/bashrc
fi

if [ -n "$PS1" -a -f ~/.bash_profile ]
then
    source ~/.bash_profile;
fi
