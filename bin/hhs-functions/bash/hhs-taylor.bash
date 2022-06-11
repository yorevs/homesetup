#!/usr/bin/env bash
# shellcheck disable=SC1090

#  Script: hhs-taylor.bash
# Created: Oct 5, 2019
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <https://opensource.org/licenses/MIT>
# !NOTICE: Do not change this file. To customize your functions edit the file ~/.functions

# @function: Tail a log using colors and patterns specified on `.tailor' file
# @param $1 [Req] : The log file name.
function __hhs_tailor() {

  local file

  if [[ "$#" -eq 0 || "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: ${FUNCNAME[0]} [filename]"
    echo ''
    echo '  Notes: '
    echo '    filename: If not provided, stdin will be used instead'
    return 1
  else
    [[ -f "${HHS_DIR}/.tailor" ]] || echo -e "
    THREAD_NAME_RE=\" *[-a-zA-Z0-9_ ]+ *\"
    THREAD_NAME_STYLE=\"${PURPLE}\"
    FQDN_RE=\"(([a-zA-Z\.][a-zA-Z0-9]*[\.\$])+[a-zA-Z0-9]+)\"
    FQDN_STYLE=\"${CYAN}\"
    LOG_LEVEL_RE=\"INFO|DEBUG|FINE\"
    LOG_LEVEL_STYLE=\"${BLUE}\"
    LOG_LEVEL_WARN_RE=\"WARN[ING]*\"
    LOG_LEVEL_WARN_STYLE=\"${YELLOW}\"
    LOG_LEVEL_ERR_RE=\"SEVERE|FATAL|ERROR\"
    LOG_LEVEL_ERR_STYLE=\"${RED}\"
    DATE_FMT_RE=\"([0-9]{2,4}\-*)* ([0-9]{2}\:*)+\.[0-9]{3}\"
    DATE_FMT_STYLE=\"${DIM}\"
    URI_FMT_RE=\"((https?|ftp|file):\/)?\/[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*\.*[-A-Za-z0-9\+&@#/%=~_|]\"
    URI_FMT_STYLE=\"${ORANGE}\"
    " >"${HHS_DIR}/.tailor"

    [[ -f "${HHS_DIR}/.tailor" ]] && \. "${HHS_DIR}/.tailor"
    file="${1:-/dev/stdin}"

    if [[ "${file}" = '/dev/stdin' ]]; then
      while read -r stream; do
        echo "${stream}" | esed \
          -e "s/\[(${THREAD_NAME_RE})\]/\[${THREAD_NAME_STYLE}\1${NC}\]/g" \
          -e "s/(${LOG_LEVEL_RE})/${LOG_LEVEL_STYLE}\1${NC}/g" \
          -e "s/(${LOG_LEVEL_WARN_RE})/${LOG_LEVEL_WARN_STYLE}\1${NC}/g" \
          -e "s/(${LOG_LEVEL_ERR_RE})/${LOG_LEVEL_ERR_STYLE}\1${NC}/g" \
          -e "s/(${DATE_FMT_RE})/${DATE_FMT_STYLE}\1${NC}/g" \
          -e "s/ (${FQDN_RE}) / ${FQDN_STYLE}\1${NC} /g" \
          -e "s/(${URI_FMT_RE})/${URI_FMT_STYLE}\1${NC}/g"
      done <"${file}"
    else
      [[ -d "${file}" ]] || touch "${file}"
      tail -n 25 -F "${file}" | esed \
        -e "s/\[(${THREAD_NAME_RE})\]/\[${THREAD_NAME_STYLE}\1${NC}\]/g" \
        -e "s/(${LOG_LEVEL_RE})/${LOG_LEVEL_STYLE}\1${NC}/g" \
        -e "s/(${LOG_LEVEL_WARN_RE})/${LOG_LEVEL_WARN_STYLE}\1${NC}/g" \
        -e "s/(${LOG_LEVEL_ERR_RE})/${LOG_LEVEL_ERR_STYLE}\1${NC}/g" \
        -e "s/(${DATE_FMT_RE})/${DATE_FMT_STYLE}\1${NC}/g" \
        -e "s/ (${FQDN_RE}) / ${FQDN_STYLE}\1${NC} /g" \
        -e "s/(${URI_FMT_RE})/${URI_FMT_STYLE}\1${NC}/g"
    fi

  fi

  return $?
}
