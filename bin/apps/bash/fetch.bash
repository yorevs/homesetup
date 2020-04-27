#!/usr/bin/env bash
# shellcheck disable=SC2034

#  Script: fetch.bash
# Purpose: Fetch REST APIs data easily.
# Created: Oct 24, 2018
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <https://opensource.org/licenses/MIT>

# Current script version.
VERSION=1.0.0

# Help message to be displayed by the script.
USAGE="
Usage: ${APP_NAME} <method> [options] <url>

        method                      : The http method to be used [ GET, POST, PUT, PATCH, DELETE ].
        url                         : The url to make the request.

    Options:
        --headers <json_headers>    : The http request headers.
        --body    <json_body>       : The http request body (payload).
        --format                    : Format the json response.
        --silent                    : Omits all informational messages.
"

# Functions to be unset after quit
UNSETS=(
  format_json do_fetch parse_args
)

# shellcheck disable=SC1090
[[ -s "${HHS_DIR}/bin/app-commons.bash" ]] && \. "${HHS_DIR}/bin/app-commons.bash"

# Request timeout in seconds
REQ_TIMEOUT=5

# Return code
RET=0

# @purpose: Format or not the output
format_json() {

  # Piped input
  read -r response
  [[ -n "${FORMAT}" ]] && echo -e "${response}" | __hhs_json_print
  [[ -z "${FORMAT}" ]] && echo -e "${response}"
}

# shellcheck disable=SC2086
# @purpose: Do the request
do_fetch() {

  curl_opts=(-s --fail -m "$REQ_TIMEOUT")

  if [[ -z "${HEADERS}" && -z "${BODY}" ]]; then
    body=$(curl ${curl_opts[*]} -X "${METHOD}" "${URL}")
  elif [[ -z "${HEADERS}" && -n "${BODY}" ]]; then
    body=$(curl ${curl_opts[*]} -X "${METHOD}" -d "${BODY}" "${URL}")
  elif [[ -n "${HEADERS}" && -n "${BODY}" ]]; then
    body=$(curl ${curl_opts[*]} -X "${METHOD}" -d "${BODY}" "${URL}")
  elif [[ -n "${HEADERS}" && -z "${BODY}" ]]; then
    body=$(curl ${curl_opts[*]} -X "${METHOD}" "${URL}")
  fi
  RET=$?
  if [[ ${RET} -eq 0 && -n "${body}" ]]; then
    echo "${body}" | format_json
  fi

  return ${RET}
}

# ------------------------------------------
# Basics

# @purpose: Parse command line arguments
parse_args() {

  [[ $# -lt 2 ]] && usage 1

  shopt -s nocasematch
  case "$1" in
    'GET' | 'POST' | 'PUT' | 'PATCH' | 'DELETE')
      METHOD="$(echo "$1" | tr '[:lower:]' '[:upper:]')"
      shift
      ;;
    *) quit 2 "Method \"$1\" is not not valid!" ;;
  esac
  shopt -u nocasematch

  # Loop through the command line options.
  while test -n "$1"; do
    case "$1" in
      --headers)
        shift
        HEADERS=" -H ${1//,/ -H }"
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
}

# @purpose: Program entry point
main() {

  parse_args "${@}"

  shopt -s nocasematch
  case "${METHOD}" in
    'GET' | 'DELETE') [[ -n "${BODY}" ]] && quit 2 "${METHOD} does not accept any body" ;;
    'PUT' | 'POST' | 'PATCH') [[ -z "${BODY}" ]] && quit 2 "${METHOD} requires a body" ;;
  esac
  shopt -u nocasematch

  [[ -z "${SILENT}" ]] && echo -e "Fetching: ${METHOD} ${URL} ..."

  if do_fetch; then
    quit 0
  else
    [[ -z "${SILENT}" ]] && msg="Failed to process request: (Ret=${RET})"
    quit ${RET} "$msg"
  fi
}

main "${@}"
quit 0
