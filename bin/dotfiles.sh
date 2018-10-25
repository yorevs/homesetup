#!/usr/bin/env bash
# shellcheck disable=SC1117

#  Script: dotfiles.sh
# Purpose: Manage your HomeSetup dotfiles and more
# Created: Oct 25, 2018
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs/homesetup

# Current script version.
VERSION=0.9.0

# This script name.
PROC_NAME=$(basename "$0")

# Help message to be displayed by the script.
USAGE="
Usage: $PROC_NAME <command> [<args>]

    Commands:
        FB | firebase   : Execute Firebase tasks; type: '$PROC_NAME help FB' for details.
        H  | help       : Provides a help about the command.
"

# Import pre-defined .bash_colors
# shellcheck disable=SC1090
test -f ~/.bash_colors && source ~/.bash_colors

# Purpose: Quit the program and exhibits an exit message if specified.
# @param $1 [Req] : The exit return code.
# @param $2 [Opt] : The exit message to be displayed.
quit() {

    test "$1" != '0' -a "$1" != '1' && printf "%s" "${RED}"
    test -n "$2" -a "$2" != "" && printf "%s\n" "${2}"
    test "$1" != '0' -a "$1" != '1' && printf "%s" "${NC}"

    # Unset all declared functions
    unset -f quit usage version exec_command cmd_help cmd_firebase

    exit "$1"
}

# Usage message.
usage() {
    quit 1 "$USAGE"
}

# Version message.
version() {
    quit 1 "$VERSION"
}

# Check if the user passed the help or version parameters.
test "$1" = '-h' -o "$1" = '--help' && usage
test "$1" = '-v' -o "$1" = '--version' && version

# Execute a dotfiles command.
exec_command() {

    shopt -s nocasematch
    case "${COMMAND}" in
        # Do stuff related to firebase
        cmd_firebase)
            cmd_firebase "$@"
        ;;
        cmd_help)
            cmd_help "$@"
        ;;
        *)
            quit 1 "Invalid command \"${COMMAND}\" !"
        ;;
    esac
    shopt -u nocasematch
    quit 0
}

# Provides a help about the command.
cmd_help() {
    shopt -s nocasematch
    case "$1" in
        # Do stuff related to firebase
        FB | firebase)
            echo "Execute firebase synchronization tasks."
            echo "Usage: $PROC_NAME firebase <task> [args]"
            echo ""
            echo "  Tasks:"
            echo "        setup               : Setup your Firebase account to use with your HomeSetup installation."
            echo "       upload <db_alias>    : Upload your custom .dotfiles to your Firebase 'Realtime Database'."
            echo "     download <db_alias>    : Download your custom .dotfiles from your Firebase 'Realtime Database'."
            echo "        merge <db_alias>    : Merge your custom .dotfiles with the ones at your Firebase 'Realtime Database'."
        ;;
        H | help)
            echo "Provides a help to the given command."
            echo "Usage: $PROC_NAME help <command>"
        ;;
        *)
            quit 1 "Command \"$1\" does not exist!"
        ;;
    esac
    shopt -u nocasematch
}

# Execute a Firebase command
cmd_firebase() {

    FIREBASE_FILE=${FIREBASE_FILE:-$HOME/.firebase}
    task="$1"
    shift
    args=( "$@" )

    echo "T: $task"
    echo "A: ${args[*]}"

    test -z "${args[*]}" -a "$task" != 'setup' && quit 2 "Invalid number of arguments for task: \"$task\" !"

    shopt -s nocasematch
    case "$task" in
        setup)
            echo "TODO Setup"
        ;;
        upload)
            test -f "$FIREBASE_FILE" || quit 2 "Your need to setup your Firebase credentials first."
            # shellcheck disable=SC1090
            test -f "$FIREBASE_FILE" && source "$FIREBASE_FILE"
        ;;
        download)
            echo "TODO Download"
        ;;
        merge)
            echo "TODO Merge"
        ;;
        *)
            quit 2 "Invalid firebase task: \"$task\" !"
        ;;
    esac
    shopt -u nocasematch
}

test -z "$1" && usage

shopt -s nocasematch
# Loop through the command line options.
case "$1" in
    # Do stuff related to firebase
    FB | firebase)
        COMMAND="cmd_firebase"
        shift
    ;;
    # Help about the command
    H | help)
        COMMAND="cmd_help"
        shift
    ;;
    *)
        quit 1 "Invalid option: \"$1\""
    ;;
esac
shopt -u nocasematch

exec_command "$@"

quit 0
