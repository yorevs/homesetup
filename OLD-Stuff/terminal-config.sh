#!/bin/bash

################################################################################
# C-Shell: terminal-config.sh
# Purpose: Configure the terminal using the bash template files.
# Autor: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
# Mailto: hugos@inatel.br
# Data, Jul 11, 2013
################################################################################

HOME=${HOME:-~/}

BASH_TPLS=$HOME/Dropbox/Hugs-Home-Setup/BashTemplates

PROG_NAME=$(basename $0 | cut -d "." -f 1)

echo "[$PROG_NAME] Configuring local terminal variables"

read -p "[$PROG_NAME] This will replace existing local variables! Continue (y/n) ? " -n 1 ANS
echo ' '
ANS=$(echo $ANS | tr '[A-Z]' '[a-z]')

if test "$ANS" = "y"
then
    ln -sf $BASH_TPLS/bashrc.sh $HOME/.bashrc
    ln -sf $BASH_TPLS/bash_aliases.sh $HOME/.bash_aliases
    ln -sf $BASH_TPLS/bash_profile.sh $HOME/.bash_profile
    ln -sf $BASH_TPLS/bash_env.sh $HOME/.bash_env
    echo "[$PROG_NAME] Configuration summary: Files = 4"
else
    echo "[$PROG_NAME] Configuration summary: Files = 0"
fi

echo "[$PROG_NAME] Done."
echo ' '
