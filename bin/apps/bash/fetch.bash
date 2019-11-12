#!/usr/bin/env bash
# shellcheck disable=SC1117,SC2034

#  Script: fetch.bash
# Purpose: Script to fetch REST APIs data.
# Created: Oct 24, 2018
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <http://unlicense.org/>

# Current script version.
VERSION=0.9.0

# Help message to be displayed by the script.
USAGE="
Usage: $APP_NAME <method> [options] <url>

        method                      : The http method to be used [ GET, POST, PUT, PATCH, DELETE ].
        url                         : The url to make the request.
        
    Options:
        --headers <json_headers>    : The http request headers.
        --body    <json_body>       : The http request body (payload).
        --format                    : Format the json response.
        --silent                    : Omits all informational messages.
"

# Functions to be unset after quit
UNSETS=( format_json do_fetch )

# shellcheck disable=SC1090
[ -s "$HHS_DIR/bin/app-commons.bash" ] && \. "$HHS_DIR/bin/app-commons.bash"

# Request timeout in seconds
REQ_TIMEOUT=5

# Return code
RET=0

shopt -s nocasematch
case "$1" in
'GET' | 'POST' | 'PUT' | 'PATCH' | 'DELETE')
  METHOD="$(echo "$1" | tr '[:lower:]' '[:upper:]')"
  shift
  ;;
*)
  quit 2 "Method \"$1\" is not not valid!"
  ;;
esac
shopt -u nocasematch

# Loop through the command line options.
while test -n "$1"; do
  case "$1" in
  --headers)
    shift
    IFS=','
    arr=("$1")
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
  --silent)
    SILENT=1
    ;;
  *)
    URL="$*"
    break
    ;;
  esac
  shift
done

[ -z "$URL" ] && quit 2 "No URL was defined!"

if [ "GET" = "${METHOD}" ] || [ "DELETE" = "${METHOD}" ]; then
  [ -n "${BODY}" ] && quit 2 "${METHOD} does not accept any body"
elif [ "PUT" = "${METHOD}" ] || [ "POST" = "${METHOD}" ] || [ "PATCH" = "${METHOD}" ]; then
  [ -z "${BODY}" ] && quit 2 "${METHOD} requires a body"
fi

# Format or not the output
format_json() {

  # Piped input
  read -r response
  [ -n "${FORMAT}" ] && echo -e "$response" | json_pp
  [ -z "${FORMAT}" ] && echo -e "$response"
}

# Do the request
# shellcheck disable=SC2086
do_fetch() {

  curl_opts=( -s --fail -m "$REQ_TIMEOUT" )

  if [ -z "$HEADERS" ] && [ -z "${BODY}" ]; then
    body=$(curl ${curl_opts[*]} -X "${METHOD}" "${URL}")
  elif [ -z "$HEADERS" ] && [ -n "${BODY}" ]; then
    body=$(curl ${curl_opts[*]} -X "${METHOD}" -d "${BODY}" "${URL}")
  elif [ -n "$HEADERS" ] && [ -n "${BODY}" ]; then
    body=$(curl ${curl_opts[*]} -X "${METHOD}" -d "${BODY}" "${URL}")
  elif [ -n "$HEADERS" ] && [ -z "${BODY}" ]; then
    body=$(curl ${curl_opts[*]} -X "${METHOD}" "${URL}")
  fi
  RET=$?
  if [ $RET -eq 0 ] && [ -n "${body}" ]; then
    echo "${body}" | format_json
  fi

  return $RET
}

[ -z "${SILENT}" ] && echo -e "Fetching: ${METHOD} $URL ..."

if do_fetch; then
  quit 0
else
  [ -z "${SILENT}" ] && msg="Failed to process request: (Ret=$RET)"
  quit $RET "$msg"
fi