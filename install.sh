#!/usr/bin/env bash

#  Script: install.sh
# Purpose: Install and configure all dofiles
# Created: Aug 26, 2008
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@gmail.com

# Current script version.
VERSION=0.9.0

# This script name.
PROC_NAME="$(basename $0)"

# Help message to be displayed by the script.
USAGE="
Usage: $PROC_NAME [-t|--type <all>] [-d|--dir <home_setup_dir>]

    *** [all]: Install all scripts into the user home folder.
"

# Purpose: Quit the program and exhibits an exit message if specified.
# @param $1 [Req] : The exit return code.
# @param $2 [Opt] : The exit message to be displayed.
quit() {
    
    test -n "$2" -o "$2" != "" && echo -e "$2"
    echo ''
    exit $1
}

# Usage message.
usage() {
    quit 1 "$USAGE"
}

# Check if the user passed the help parameters.
test "$1" = '-h' -o "$1" = '--help' -o -z "$1" -o "$1" = "" && usage

# Loop through the command line options.
# Short opts: -w, Long opts: --Word
while test -n "$1"
do
    case "$1" in
        -t | --type)
            shift
            OPT="$1"
        ;;
        -d | --dir)
            shift
            DIR="$1"
        ;;
        
        *)
            quit 1 "Invalid option: \"$1\""
        ;;
    esac
    shift
done

test -z "$DIR" && DIR=`pwd`

# HomeSetup folder
HOME_SETUP=${HOME_SETUP:-$DIR}
test -d "$HOME_SETUP" || mkdir -p "$DIR"

echo ''
echo '#'
echo '# Install settings:'
echo "# - HOME_SETUP: $HOME_SETUP"
echo "# - OPTTIONS: $OPT"
echo '#'
echo ''

read -n 1 -p "Your .dotfiles will be replaced. Continue y/[n] ?" ANS
test -z "$ANS" -o "$ANS" = "n" -o "$ANS" = "N" && quit 0
echo ''
echo ''

# If all option is used, do it at once
if test "$OPT" = "all" -o "$OPT" = "ALL"
then
    # Bin directory
    echo -n "Linking: " && ln -sfv $HOME_SETUP/bin ~/
    test -d ~/bin && echo -e '[ OK ]\n'

    # Bash dotfiles
    echo -n "Linking: " && ln -sfv $HOME_SETUP/bashrc.sh ~/.bashrc
    test -f ~/.bashrc && echo -e '[ OK ]\n'
    echo -n "Linking: " && ln -sfv $HOME_SETUP/bash_profile.sh ~/.bash_profile
    test -f ~/.bash_profile && echo -e '[ OK ]\n'
    echo -n "Linking: " && ln -sfv $HOME_SETUP/bash_aliases.sh ~/.bash_aliases
    test -f ~/.bash_aliases && echo -e '[ OK ]\n'
    echo -n "Linking: " && ln -sfv $HOME_SETUP/bash_prompt.sh ~/.bash_prompt
    test -f ~/.bash_prompt && echo -e '[ OK ]\n'
    echo -n "Linking: " && ln -sfv $HOME_SETUP/bash_env.sh ~/.bash_env
    test -f ~/.bash_env && echo -e '[ OK ]\n'
    echo -n "Linking: " && ln -sfv $HOME_SETUP/bash_colors.sh ~/.bash_colors
    test -f ~/.bash_colors && echo -e '[ OK ]\n'
    echo -n "Linking: " && ln -sfv $HOME_SETUP/bash_functions.sh ~/.bash_functions
    test -f ~/.bash_functions && echo -e '[ OK ]\n'
else
    # Bin directory
    echo ''
    read -n 1 -sp 'Link  ~/bin folder (y/[n])? ' ANS
    test "$ANS" = 'y' -o "$ANS" = 'Y' && echo -en "$ANS \nLinking: " && ln -sfv $HOME_SETUP/bin ~/ && test -d ~/bin && echo '[ OK ]'

    # Bash
    echo ''
    read -n 1 -sp 'Link .bashrc (y/[n])? ' ANS
    test "$ANS" = 'y' -o "$ANS" = 'Y' && echo -en "$ANS \nLinking: " && ln -sfv $HOME_SETUP/bashrc.sh ~/.bashrc && test -f ~/.bashrc && echo '[ OK ]'
    echo ''
    read -n 1 -sp 'Link .bash_profile (y/[n])? ' ANS
    test "$ANS" = 'y' -o "$ANS" = 'Y' && echo -en "$ANS \nLinking: " && ln -sfv $HOME_SETUP/bash_profile.sh ~/.bash_profile && test -f ~/.bash_profile && echo '[ OK ]'
    echo ''
    read -n 1 -sp 'Link .bash_aliases (y/[n])? ' ANS
    test "$ANS" = 'y' -o "$ANS" = 'Y' && echo -en "$ANS \nLinking: " && ln -sfv $HOME_SETUP/bash_aliases.sh ~/.bash_aliases && test -f ~/.bash_aliases && echo '[ OK ]'
    echo ''
    read -n 1 -sp 'Link .bash_prompt (y/[n])? ' ANS
    test "$ANS" = 'y' -o "$ANS" = 'Y' && echo -en "$ANS \nLinking: " && ln -sfv $HOME_SETUP/bash_prompt.sh ~/.bash_prompt && test -f ~/.bash_prompt && echo '[ OK ]'
    echo ''
    read -n 1 -sp 'Link .bash_env (y/[n])? ' ANS
    test "$ANS" = 'y' -o "$ANS" = 'Y' && echo -en "$ANS \nLinking: " && ln -sfv $HOME_SETUP/bash_env.sh ~/.bash_env && test -f ~/.bash_env && echo '[ OK ]'
    echo ''
    read -n 1 -sp 'Link .bash_colors (y/[n])? ' ANS
    test "$ANS" = 'y' -o "$ANS" = 'Y' && echo -en "$ANS \nLinking: " && ln -sfv $HOME_SETUP/bash_colors.sh ~/.bash_colors && test -f ~/.bash_colors && echo '[ OK ]'
    echo ''
    read -n 1 -sp 'Link .bash_functions (y/[n])? ' ANS
    test "$ANS" = 'y' -o "$ANS" = 'Y' && echo -en "$ANS \nLinking: " && ln -sfv $HOME_SETUP/bash_functions.sh ~/.bash_functions && test -f ~/.bash_functions && echo '[ OK ]'
fi

echo ''
echo 'ww      ww   eEEEEEEEEe   LL           cCCCCCCc    oOOOOOOo    mm      mm   eEEEEEEEEe'
echo 'WW      WW   EE           LL          Cc          OO      Oo   MM M  M MM   EE        '
echo 'WW  ww  WW   EEEEEEEE     LL          Cc          OO      OO   MM  mm  MM   EEEEEEEE  '
echo 'WW W  W WW   EE           LL     ll   Cc          OO      Oo   MM      MM   EE        '
echo 'ww      ww   eEEEEEEEEe   LLLLLLLll    cCCCCCCc    oOOOOOOo    mm      mm   eEEEEEEEEe'
echo ''

echo "? To apply all settings on this shell type: source ~/.bashrc" 
echo ''

quit 0