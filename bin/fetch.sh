#!/usr/bin/env bash
# shellcheck disable=SC1117

#  Script: fetch.sh
# Purpose: Fetch data using the REST API
# Created: Oct 24, 2018
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs/homesetup

# Current script version.
VERSION=0.9.0

# This script name.
PROC_NAME=$(basename "$0")

# Help message to be displayed by the script.
USAGE="
Usage: $PROC_NAME <method> [options] <url>

        method                      : The http method to be used [ GET, POST, PUT, PATCH, DELETE ].
        url                         : The url to make the request.
        
    Options:
        --headers <json_headers>    : The http request headers.
        --body    <json_body>       : The http request body (payload).
        --format                    : Format the json response.
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
    unset -f quit usage version format_json do_fetch
    
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
test -z "$1" && usage

shopt -s nocasematch
case "$1" in
    'GET' | 'POST' | 'PUT' | 'PATCH' | 'DELETE')
        METHOD="$(echo "$1" | tr '[:lower:]' '[:upper:]')"
        shift
    ;;
    *)
        quit 2 "Method $1 is not not valid!"
    ;;
esac
shopt -u nocasematch

# Loop through the command line options.
# Short opts: -<C>, Long opts: --<Word>
while test -n "$1"
do
    case "$1" in
        --headers)
            shift
            IFS=','
            arr=( "$1" )
            for h in ${arr[*]}; do
                HEADERS="$HEADERS -H $h"
            done
            IFS=' '
        ;;
        --body)
            shift
            BODY="$1"
        ;;
        --format)
            FORMAT=1
        ;;
        *)
            URL="$*"
            break
        ;;
    esac
    shift
done

test -z "$URL" && quit 2 "No URL was defined!"

if [ "GET" = "${METHOD}" ] || [ "DELETE" = "${METHOD}" ]; then
    test -n "${BODY}" && quit 2 "${METHOD} does not accept any body"
elif [ "PUT" = "${METHOD}" ] || [ "POST" = "${METHOD}" ]|| [ "PATCH" = "${METHOD}" ]; then
    test -z "${BODY}" && quit 2 "${METHOD} requires a body"
fi

# Format or not the output
format_json() {
    
    # Piped input
    read -r response
    test -n "${FORMAT}" && echo "$response" | json_pp -f json -t json -json_opt pretty indent escape_slash
    test -z "${FORMAT}" && echo "$response"
}

# Do the request
do_fetch() {
    
    test -z "$HEADERS" -a -z "${BODY}" && curl -X "${METHOD}" "${URL}"  2>/dev/null | format_json
    test -z "$HEADERS" -a -n "${BODY}" && curl -X "${METHOD}" -d "${BODY}" "${URL}"  2>/dev/null | format_json
    test -n "$HEADERS" -a -n "${BODY}" && curl -X "${METHOD}" -d "${BODY}" "${URL}"  2>/dev/null | format_json
    test -n "$HEADERS" -a -z "${BODY}" && curl -X "${METHOD}" "${URL}"  2>/dev/null | format_json
}

echo "Fetching (${METHOD}) $URL ..."
do_fetch

quit 0
