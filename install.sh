#!/usr/bin/env bash

#  Script: ${app.sh}
# Purpose: ${purpose}
# Created: Mon DD, YYYY
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@gmail.com

# Current script version.
VERSION=0.9.0

# This script name.
PROC_NAME="$(basename $0)"

# Help message to be displayed by the script.
USAGE="
Usage: $PROC_NAME <home_setup_dir> [all]

    *** [all]: Install all scripts into the home folder.
"

# Purpose: Quit the program and exhibits an exit message if specified.
# @param $1 [Req] : The exit return code.
# @param $2 [Opt] : The exit message to be displayed.
quit() {
    
    if test -n "$2" -o "$2" != ""; then
        echo -e "$2"
    fi

    echo ''
    echo ''
    exit $1
}

# Usage message.
usage() {
    quit 1 "$USAGE"
}

HOME_SETUP=${:-$1}

# Check if the user passed the help parameters.
test "$1" = '-h' -o "$1" = '--help' -o -z "$HOME_SETUP" -o "$HOME_SETUP" = "" && usage

# If all option is used, do it at once
if test "$2" = "all" -o "$2" = "ALL"
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

    # Git dotfiles
    echo -n "Linking: " && ln -sfv $HOME_SETUP/gitconfig ~/.gitconfig
    test -f ~/.gitconfig && echo -e '[ OK ]\n'
    echo -n "Linking: " && ln -sfv $HOME_SETUP/gitconfig ~/.gitconfig_global
    test -f ~/.gitconfig_global && echo -e '[ OK ]\n'
    echo -n "Linking: " && ln -sfv $HOME_SETUP/gitignore ~/.gitignore
    test -f ~/.gitignore && echo -e '[ OK ]\n'
    echo -n "Linking: " && ln -sfv $HOME_SETUP/gitignore ~/.gitignore_global
    test -f ~/.gitignore_global && echo -e '[ OK ]\n'

    # Vim dotfile
    echo -n "Linking: " && ln -sfv $HOME_SETUP/viminfo ~/.viminfo
    test -f ~/.viminfo && echo -e '[ OK ]\n'
    
    quit 0
fi

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

# Git
echo ''
read -n 1 -sp 'Link .gitconfig (y/[n])? ' ANS
test "$ANS" = 'y' -o "$ANS" = 'Y' && echo -en "$ANS \nLinking: " && ln -sfv $HOME_SETUP/gitconfig ~/.gitconfig && test -f ~/.gitconfig && echo '[ OK ]'
echo ''
read -n 1 -sp 'Link .gitconfig_global (y/[n])? ' ANS
test "$ANS" = 'y' -o "$ANS" = 'Y' && echo -en "$ANS \nLinking: " && ln -sfv $HOME_SETUP/gitconfig ~/.gitconfig_global && test -f ~/.gitconfig_global && echo '[ OK ]'
echo ''
read -n 1 -sp 'Link .gitignore_global (y/[n])? ' ANS
test "$ANS" = 'y' -o "$ANS" = 'Y' && echo -en "$ANS \nLinking: " && ln -sfv $HOME_SETUP/gitignore ~/.gitignore_global && test -f ~/.gitignore_global && echo '[ OK ]'
echo ''
read -n 1 -sp 'Link .gitignore (y/[n])? ' ANS
test "$ANS" = 'y' -o "$ANS" = 'Y' && echo -en "$ANS \nLinking: " && ln -sfv $HOME_SETUP/gitignore ~/.gitignore && test -f ~/.gitignore && echo '[ OK ]'

# Vim
echo ''
read -n 1 -sp 'Link .viminfo (y/[n])? ' ANS
test "$ANS" = 'y' -o "$ANS" = 'Y' && echo -en "$ANS \nLinking: " && ln -sfv $HOME_SETUP/viminfo ~/.viminfo && test -f ~/.viminfo && echo '[ OK ]'

quit 0