#!/usr/bin/env bash
# shellcheck disable=SC1117

#  Script: dotfiles.sh
# Purpose: Manage your HomeSetup dotfiles and more
# Created: Oct 25, 2018
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs#homesetup

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
    unset -f quit usage version exec_command cmd_help cmd_firebase load_fb_settings

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

# TODO
FIREBASE_FILE=${FIREBASE_FILE:-$HOME/.firebase}

# TODO
DOTFILES_FILE=${DOTFILES_FILE:-$HOME_SETUP/dotfiles.json}

# Loads Firebase settings from file.
load_fb_settings() {

    test -f "$FIREBASE_FILE" || quit 2 "Your need to setup your Firebase credentials first."
    # shellcheck disable=SC1090
    test -f "$FIREBASE_FILE" && source "$FIREBASE_FILE"
    [ -z "$PROJECT_ID" ] || [ -z "$FIREBASE_URL" ] || [ -z "$PASSPHRASE" ] && quit 2 "Invalid settings file!"
    return 0
}

# Download the User dotfiles from Firebase.
download_dotfiles() {

    fetch.sh GET --silent "$FIREBASE_URL" > "$DOTFILES_FILE"
    ret=$?
    test $ret -eq 0 && echo "${GREEN}Dotfiles sucessfully downloaded from ${args[0]}${NC}"
    test $ret -eq 0 || quit 2 "${RED}Failed to download Dotfiles from ${args[0]}${NC}"
    return $ret
}

# Execute a dotfiles command.
exec_command() {

    shopt -s nocasematch
    case "${COMMAND}" in
        # Do stuff related to firebase
        cmd_firebase)
            cmd_firebase "$@"
            ret=$?
        ;;
        cmd_help)
            cmd_help "$@"
            ret=$?
        ;;
        *)
            quit 1 "Invalid command \"${COMMAND}\" !"
        ;;
    esac
    shopt -u nocasematch
    quit $ret
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

    local body
    local f_aliases
    local f_colors
    local f_env
    local f_functions
    local f_profile
    local fb_re_resp
    task="$1"
    shift
    args=( "$@" )
    test -z "${args[*]}" -a "$task" != 'setup' && quit 2 "Invalid number of arguments for task: \"$task\" !"

    shopt -s nocasematch
    case "$task" in
        setup)
            test -f "$FIREBASE_FILE" && rm -f "$FIREBASE_FILE"
            while [ ! -f "$FIREBASE_FILE" ];
            do
                clear
                local setupContent=""
                echo "### Firebase setup"
                echo "-------------------------------"
                read -r -p 'Please type you Project ID: ' ANS
                [ -z "$ANS" ] || [ "$ANS" = "" ] && printf "%s\n" "${RED}Invalid Project ID: ${ANS}${NC}" && sleep 1 && continue
                setupContent="${setupContent}PROJECT_ID=${ANS}\n"
                setupContent="${setupContent}FIREBASE_URL=https://${ANS}.firebaseio.com/Dotfiles.json\n"
                read -r -p 'Please type a password to encrypt you data: ' ANS
                [ -z "$ANS" ] || [ "$ANS" = "" ] && printf "%s\n" "${RED}Invalid password: ${ANS}${NC}" && sleep 1 && continue
                setupContent="${setupContent}PASSPHRASE=${ANS}\n"
                echo -e '# Your Firebase credentials:\n' > "$FIREBASE_FILE"
                echo -e "$setupContent" >> "$FIREBASE_FILE"
            done
            printf '%s\n' "${GREEN}Configuration successfully saved!${NC}"
            echo ''
            return 0
        ;;
        upload)
            load_fb_settings
            test -f "$HOME"/.aliases && f_aliases=$(grep . "$HOME"/.aliases | base64)
            test -f "$HOME"/.colors && f_colors=$(grep . "$HOME"/.colors | base64)
            test -f "$HOME"/.env && f_env=$(grep . "$HOME"/.env | base64)
            test -f "$HOME"/.functions && f_functions=$(grep . "$HOME"/.functions | base64)
            test -f "$HOME"/.profile && f_profile=$(grep . "$HOME"/.profile | base64)
            body="{ \"${args[0]}\" : { "
            test -f "$HOME"/.aliases && body="${body}\"aliases\" : \"$f_aliases\","
            test -f "$HOME"/.colors && body="${body}\"colors\" : \"$f_colors\","
            test -f "$HOME"/.env && body="${body}\"env\" : \"$f_env\","
            test -f "$HOME"/.functions && body="${body}\"functions\" : \"$f_functions\","
            test -f "$HOME"/.profile && body="${body}\"profile\" : \"$f_profile\""
            body="${body}, } }"
            match=', } }'
            repl=' } }'
            body="${body//$match/$repl}"
            fetch.sh PATCH --silent --body "$body" "$FIREBASE_URL" &> /dev/null
            ret=$?
            test $ret -eq 0 && echo "${GREEN}Dotfiles sucessfully saved as ${args[0]}${NC}"
            test $ret -eq 0 || quit 2 "${RED}Failed to save Dotfiles as ${args[0]}${NC}"
            return 0
        ;;
        download)
            printf "%s\n" "${RED}"
            read -r -n 1 -p "All of your current .dotfiles will be replaced. Continue y/[n] ?" ANS
            printf "%s\n" "${NC}"
            test -z "$ANS" || test "$ANS" = "n" || test "$ANS" = "N" && quit 1
            load_fb_settings
            download_dotfiles
            fb_re_resp='s#.*\[{]\"aliases\"\:\"(.*)\",?\"colors\"\:\"(.*)\",?\"env\"\:\"(.*)\",?\"functions\"\:\"(.*)\",?\"profile\"\:\"(.*)\"[}][}].*'
            f_aliases=$(grep . "$DOTFILES_FILE" | sed -E "$fb_re_resp#\1#" | base64 -D 2>/dev/null)
            f_colors=$(grep . "$DOTFILES_FILE" | sed -E "$fb_re_resp#\2#" | base64 -D 2>/dev/null)
            f_env=$(grep . "$DOTFILES_FILE" | sed -E "$fb_re_resp#\3#" | base64 -D 2>/dev/null)
            f_functions=$(grep . "$DOTFILES_FILE" | sed -E "$fb_re_resp#\4#" | base64 -D 2>/dev/null)
            f_profile=$(grep . "$DOTFILES_FILE" | sed -E "$fb_re_resp#\5#" | base64 -D 2>/dev/null)
            test -n "$f_aliases" && echo "$f_aliases" > "$HOME/.aliases"
            test -n "$f_colors" && echo "$f_colors" > "$HOME/.colors"
            test -n "$f_env" && echo "$f_env" > "$HOME/.env"
            test -n "$f_functions" && echo "$f_functions" > "$HOME/.functions"
            test -n "$f_profile" && echo "$f_profile" > "$HOME/.profile"
            rm -f "$DOTFILES_FILE"
            printf "%s\n" "? To activate the new dotfiles type: #> ${GREEN}source ~/.bashrc${NC}"
            echo ''
            return 0
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
