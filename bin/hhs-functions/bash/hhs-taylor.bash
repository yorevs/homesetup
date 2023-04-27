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
  
  if [[ "$(uname -s)" == "Darwin" ]]; then
    sed_flag="-E"
  else
    sed_flag="r"
  fi
  
  HHS_TAILOR_CONFIG_FILE="${HHS_TAILOR_CONFIG_FILE:-${HHS_DIR}/.tailor}"

  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: ${FUNCNAME[0]} [-F | -f | -r] [-q] [-b # | -c # | -n #] <file>"
    echo ''
    echo '  Notes: '
    echo '    filename: If not provided, stdin will be used instead'
    return 1
  else
    if [[ ! -f "${HHS_TAILOR_CONFIG_FILE}" ]]; then
      echo -e "
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
        DATE_FMT_RE=\"([0-9]{2,4}\-*)* ([0-9]{2}\:*)+(\.[0-9]{3})?\"
        DATE_FMT_STYLE=\"${VIOLET}\"
        URI_FMT_RE=\"((https?|ftp|file):\/)?\/[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*\.*[-A-Za-z0-9\+&@#/%=~_|]\"
        URI_FMT_STYLE=\"${ORANGE}\"" | sed -r 's/^ +//g'  >"${HHS_TAILOR_CONFIG_FILE}"
    fi
    
    \. "${HHS_TAILOR_CONFIG_FILE}"
    
    # shellcheck disable=SC2124,SC2206
    if [[ $# -gt 0 ]]; then
      all_args=(${*})
      args=${all_args[*]::${#all_args[@]}-1}
      last_idx=$((${#all_args[@]} - 1))
      file=${all_args[last_idx]}
    fi
    
    file=${file:-/dev/stdin}

    if [[ "${file}" = '/dev/stdin' ]]; then
      while read -r stream; do
        echo "${stream}" | sed ${sed_flag} \
          -e "s/\[(${THREAD_NAME_RE})\]/\[${THREAD_NAME_STYLE}\1${NC}\]/g" \
          -e "s/(${LOG_LEVEL_RE})/${LOG_LEVEL_STYLE}\1${NC}/g" \
          -e "s/(${LOG_LEVEL_WARN_RE})/${LOG_LEVEL_WARN_STYLE}\1${NC}/g" \
          -e "s/(${LOG_LEVEL_ERR_RE})/${LOG_LEVEL_ERR_STYLE}\1${NC}/g" \
          -e "s/(${DATE_FMT_RE})/${DATE_FMT_STYLE}\1${NC}/g" \
          -e "s/ (${FQDN_RE}) / ${FQDN_STYLE}\1${NC} /g" \
          -e "s/(${URI_FMT_RE})/${URI_FMT_STYLE}\1${NC}/g"
      done <"${file}"
    else
      [[ -f "${file}" ]] && touch "${file}"
      tail "${args[@]}" "${file}" | sed ${sed_flag} \
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
