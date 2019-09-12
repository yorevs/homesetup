#!/usr/bin/env bash
# shellcheck disable=SC1117

#  Script: uninstall.sh
# Purpose: Uninstall HomeSetup
# Created: Dec 21, 2018
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <http://unlicense.org/>
    
# This script name.
PROC_NAME=$(basename "$0")

# Help message to be displayed by the script.
USAGE="
Usage: $PROC_NAME
"

# Import pre-defined Bash Colors
# shellcheck source=/dev/null
[ -f ~/.bash_colors ] && \. ~/.bash_colors

# Purpose: Quit the program and exhibits an exit message if specified.
# @param $1 [Req] : The exit return code.
# @param $2 [Opt] : The exit message to be displayed.
quit() {
    
    # Unset all declared functions
    unset -f quit usage check_installation uninstall_dotfiles
    ret=$1
    shift
    [ "$ret" -gt 1 ] && printf "%s" "${RED}"
    [ "$#" -gt 0 ] && printf "%s" "$*"
    # Unset all declared functions
    printf "%s\n" "${NC}"
    exit "$ret"
}

# Usage message.
# @param $1 [Req] : The exit return code. 0 = SUCCESS, 1 = FAILURE
usage() {
    quit "$1" "$USAGE"
}

check_installation() {
    
    # Dotfiles used by HomeSetup
    ALL_DOTFILES=(
        "bashrc"
        "bash_profile"
        "bash_aliases"
        "bash_prompt"
        "bash_env"
        "bash_colors"
        "bash_functions"
    )

    if [ -n "$HOME_SETUP" ] && [ -d "$HOME_SETUP" ]; then

        printf "%s\n" "${BLUE}"
        echo '#'
        echo '# Uninstall settings:'
        echo "# - HOME_SETUP: $HOME_SETUP"
        echo "# - METHOD: Remove"
        echo "# - FILES: ${ALL_DOTFILES[*]}"
        printf "%s\n" "#${NC}"

        printf "%s\n" "${RED}"
        read -r -n 1 -p "HomeSetup will be completely removed and backups restored. Continue y/[n] ?" ANS
        printf "%s\n" "${NC}"
        [ -n "$ANS" ] && echo ''

        if [ "$ANS" = "y" ] || [ "$ANS" = "Y" ]; then
            uninstall_dotfiles
        else
            quit 1 "Uninstallation cancelled!"
        fi
    else
        quit 2 "Installation files were not found or removed !"
    fi
}

uninstall_dotfiles() {

    printf "%s\n" "Removing installed dotfiles ..."
    for next in ${ALL_DOTFILES[*]}; do
        test -n "$next" -a -f "$HOME/.${next}" && rm -fv "$HOME/.${next}"
    done

    # shellcheck disable=SC2164
    cd ~
    rm -rfv "$HOME_SETUP" 
    [ -L "$HOME/bin" ] && rm -f "$HOME/bin"
    echo ''

    if [ -d "$HHS_DIR" ]; then
        BACKUPS=( "$(find "$HHS_DIR" -iname "*.orig")" )
        printf "%s\n" "Restoring backups ..."
        for next in ${BACKUPS[*]}; do
            cp -v "${next}" "${HOME}/$(basename "${next%.*}")"
        done
        echo ''
        rm -rfv "$HHS_DIR"
    fi
    echo ''

    printf "%s\n" "Unsetting aliases and variables ..."
    unalias -a
    unset HOME_SETUP
    unset HHS_DIR
    unset DOTFILES_VERSION
    export PS1='\[\h:\W \u \$ '
    export PS2="$PS1"

    echo "HomeSetup successfully removed."
    echo "? To reload your old dotfiles type: #> source ~/.bashrc"
    echo "? Your old PS1 (prompt) and aliases will be restored next time you open the terminal."
    echo "? Your temporary PS1 => '$PS1'"
    echo ''
}

check_installation