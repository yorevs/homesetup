#!/usr/bin/env bash
# shellcheck disable=2034

#  Script: fetch.bash
# Purpose: Fetch URL resource using the most commons ways.
# Created: Oct 24, 2018
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: homesetup@gmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <https://opensource.org/licenses/MIT>
#
# Copyright (c) 2024, HomeSetup team

# Current script version.
VERSION=1.0.0

# Help message to be displayed by the application.
USAGE="usage: ${APP_NAME} <method> [options] <url>

  Fetch URL resource using the most commons ways.

    Arguments:

        method                      : The http method to be used [ GET, HEAD, POST, PUT, PATCH, DELETE ].
        url                         : The url to make the request.

    Options:
        --headers <json_headers>    : The http request headers.
        --body    <json_body>       : The http request body (payload).
        --format                    : Format the json RESPONSE.
        --silent                    : Omits all informational messages.
"

# Functions to be unset after quit.
UNSETS=(
  format_json fetch_with_curl parse_args do_fetch main
)

# Common application functions.
[[ -s "${HHS_DIR}/bin/app-commons.bash" ]] && source "${HHS_DIR}/bin/app-commons.bash"

# Request timeout in seconds.
REQ_TIMEOUT=3

# Execution return code.
RET_VAL=0

# Provided request headers.
HEADERS=

# Provided request body.
BODY=

# Provide a silent request/RESPONSE.
SILENT=

# Response body.
RESPONSE=

# Http status code.
STATUS=0

# @purpose: Do the request according to the method
function fetch_with_curl() {

  aux=$(mktemp)

  curl_opts=(
    '-s' '--fail' '-L' '--output' "${aux}" '-m' "${REQ_TIMEOUT}" '--write-out' "%{http_code}"
  )

  if [[ -z "${HEADERS}" && -z "${BODY}" ]]; then
    STATUS=$(curl "${curl_opts[@]}" -X "${METHOD}" "${URL}")
  elif [[ -z "${HEADERS}" && -n "${BODY}" ]]; then
    STATUS=$(curl "${curl_opts[@]}" -X "${METHOD}" -d "${BODY}" "${URL}")
  elif [[ -n "${HEADERS}" && -n "${BODY}" ]]; then
    STATUS=$(curl "${curl_opts[@]}" -X "${METHOD}" -d "${BODY}" "${URL}")
  elif [[ -n "${HEADERS}" && -z "${BODY}" ]]; then
    STATUS=$(curl "${curl_opts[@]}" -X "${METHOD}" "${URL}")
  fi

  if [[ -s "${aux}" ]]; then
    RESPONSE=$(grep . --color=none "${aux}")
    \rm -f "${aux}"
  fi

  if [[ ${STATUS} -ge 200 && ${STATUS} -lt 400 ]]; then
    RET_VAL=0
  else
    RET_VAL=1
  fi

  return $RET_VAL
}

# ------------------------------------------
# Basics

# @purpose: Parse command line arguments
parse_args() {

  [[ $# -lt 2 ]] && usage 1

  shopt -s nocasematch
  case "${1}" in
    'GET' | 'HEAD' | 'POST' | 'PUT' | 'PATCH' | 'DELETE')
      METHOD="$(tr '[:lower:]' '[:upper:]' <<< "${1}")"
      shift
      ;;
    *) quit 2 "Method \"${1}\" is not not valid!" ;;
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

# @purpose: Fetch the url using the most common ways.
do_fetch() {
  fetch_with_curl
  return $?
}

# @purpose: Program entry point
main() {

  parse_args "${@}"

  case "${METHOD}" in
    'GET' | 'HEAD' | 'DELETE')
      [[ -n "${BODY}" ]] && quit 1 "${METHOD} does not accept a body"
      ;;
    'PUT' | 'POST' | 'PATCH')
      [[ -z "${BODY}" ]] && quit 1 "${METHOD} requires a body"
      ;;
  esac

  [[ -z "${SILENT}" ]] && echo -e "Fetching: ${METHOD} ${HEADERS} ${URL} ..."

  if do_fetch; then
    echo "${RESPONSE}"
    quit 0
  else
    if [[ -z "${SILENT}" ]]; then
      msg="Failed to process request: (Status=${STATUS})"
      __hhs_errcho "${msg} => [resp:${RESPONSE:-<empty>}]"
    else
      echo "${RET_VAL}" 1>&2
      quit 0
    fi
  fi
}

main "${@}"
quit 1
