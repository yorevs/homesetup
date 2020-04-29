#!/usr/bin/env bash
# shellcheck disable=SC2034

#  Script: fetch.bash
# Purpose: Fetch REST APIs payload easily.
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
        --format                    : Format the json responseonse.
        --silent                    : Omits all informational messages.
"

# Functions to be unset after quit
UNSETS=(
  format_json do_fetch parse_args
)

# shellcheck disable=SC1090
[[ -s "${HHS_DIR}/bin/app-commons.bash" ]] && \. "${HHS_DIR}/bin/app-commons.bash"

# Request timeout in seconds
REQ_TIMEOUT=3

# Return code
RET=0

# @purpose: Format or not the output
format_json() {

  # Piped input
  read -r responseonse
  [[ -n "${FORMAT}" ]] && echo -e "${responseonse}" | __hhs_json_print
  [[ -z "${FORMAT}" ]] && echo -e "${responseonse}"
}

# shellcheck disable=SC2086
# @purpose: Do the request
do_fetch() {

  curl_opts=(-s --fail -m "$REQ_TIMEOUT")

  if [[ -z "${HEADERS}" && -z "${BODY}" ]]; then
    response=$(curl ${curl_opts[*]} -X "${METHOD}" "${URL}")
  elif [[ -z "${HEADERS}" && -n "${BODY}" ]]; then
    response=$(curl ${curl_opts[*]} -X "${METHOD}" -d "${BODY}" "${URL}")
  elif [[ -n "${HEADERS}" && -n "${BODY}" ]]; then
    response=$(curl ${curl_opts[*]} -X "${METHOD}" -d "${BODY}" "${URL}")
  elif [[ -n "${HEADERS}" && -z "${BODY}" ]]; then
    response=$(curl ${curl_opts[*]} -X "${METHOD}" "${URL}")
  fi
  RET=$?
  if [[ ${RET} -eq 0 && -n "${response}" ]]; then
    echo -en "${response}" | format_json
  elif [[ ${RET} -ne 0 && "${response}" ]]; then
    if [[ ${response} -ge 400 && ${response} -lt 600 ]]; then
      RET="${response}"
    fi
  fi

  return ${RET}
}

# ------------------------------------------
# Basics

# @purpose: Parse command line arguments
parse_args() {

  [[ $# -lt 2 ]] && usage 1

  shopt -s nocasematch
  case "${1}" in
    'GET' | 'POST' | 'PUT' | 'PATCH' | 'DELETE')
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

# @purpose: Program entry point
main() {

  parse_args "${@}"

  case "${METHOD}" in
    'GET' | 'DELETE') [[ -n "${BODY}" ]] && quit 2 "${METHOD} does not accept any body" ;;
    'PUT' | 'POST' | 'PATCH') [[ -z "${BODY}" ]] && quit 2 "${METHOD} requires a body" ;;
  esac

  [[ -z "${SILENT}" ]] && echo -e "Fetching: ${METHOD} ${HEADERS} ${URL} ..."

  if do_fetch; then
    quit 0
  else
    if [[ -z "${SILENT}" ]]; then
      msg="Failed to process request: (Ret=${RET})"
      __hhs_errcho "${msg}"
    else
      echo "${RET}" 1>&2
    fi
    quit 2
  fi
}

main "${@}"
quit 0
