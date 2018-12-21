#!/usr/bin/env bash
# shellcheck disable=SC1117

#  Script: uninstall.sh
# Purpose: Uninstall HomeSetup
# Created: Dec 21, 2018
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs/homesetup
    
# This script name.
PROC_NAME=$(basename "$0")

# Help message to be displayed by the script.
USAGE="
Usage: $PROC_NAME
"

# Purpose: Quit the program and exhibits an exit message if specified.
# @param $1 [Req] : The exit return code.
# @param $2 [Opt] : The exit message to be displayed.
quit() {
    
    # Unset all declared functions
    unset -f quit usage check_installation uninstall_dotfiles

    test "$1" != '0' -a "$1" != '1' && echo -e "${RED}"
    test -n "$2" -a "$2" != "" && printf "%s\n" "${2}"
    test "$1" != '0' -a "$1" != '1' && echo -e "${NC}"
    echo ''
    exit "$1"
}

# Usage message.
usage() {
    quit 2 "$USAGE"
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
        
        # shellcheck disable=SC1090
        source "$HOME_SETUP/bash_colors.sh"

        printf "%s\n" "${BLUE}"
        echo '#'
        echo '# Uninstall settings:'
        echo "# - HOME_SETUP: $HOME_SETUP"
        echo "# - METHOD: Remove"
        echo "# - FILES: ${ALL_DOTFILES[*]}"
        printf "%s\n" "#${NC}"

        printf "%s\n" "${RED}"
            read -r -n 1 -p "HomeSetup will be removed and backups restored. Continue y/[n] ?" ANS
            printf "%s\n" "${NC}"
            if [ "$ANS" = "y" ] || [ "$ANS" = "Y" ]; then
                
                test -n "$ANS" && echo ''
                uninstall_dotfiles
            else
                test -n "$ANS" && echo ''
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
    test -L "$HOME/bin" && rm -f "$HOME/bin"
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
    printf "%s\n" "? To reload your old dotfiles type: #> source ~/.bashrc"
    printf "%s\n" "? Your old PS1 (prompt) and aliases will be restored next time you open the terminal."
    printf "%s\n" "? Your temporary PS1 => '$PS1'"
    echo ''
}

check_installation