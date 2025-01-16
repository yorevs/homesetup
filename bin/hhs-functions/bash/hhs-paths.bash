#!/usr/bin/env bash

#  Script: hhs-paths.bash
# Created: Oct 5, 2019
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: taius.hhs@gmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <https://opensource.org/licenses/MIT>
#
# Copyright (c) 2025, HomeSetup team

# !NOTICE: Do not change this file. To customize your functions edit the file ~/.functions

# shellcheck disable=SC2155
# @function: Manage your custom PATH entries.
# @param $1 [Con] : The path to be added or removed.
function __hhs_paths() {

  local pad pad_len columns path_dir path custom private quiet

  HHS_PATHS_FILE=${HHS_PATHS_FILE:-${HHS_DIR}/.path} # Custom paths
  PATHS_D="/etc/paths.d"                             # Private system paths
  PVT_PATHS_D="/private/etc/paths"                   # General system path dir

  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "usage: ${FUNCNAME[0]} [options] <args>"
    echo ''
    echo '    Options: '
    echo '      -a <path> : Add to the current <path> to PATH.'
    echo '      -r <path> : Remove from the current <path> from PATH.'
    echo '      -e        : Edit current HHS_PATHS_FILE.'
    echo '      -c        : Attempt to clear non-existing paths. System paths are not affected.'
    echo '      -q        : Quiet mode on.'
    echo ''
    echo '  Notes: '
    echo '    - When no arguments are provided it will list all PATH payload'.
    return 1
  else
    # Remove duplicate items
    sort -u "${HHS_PATHS_FILE}" -o "${HHS_PATHS_FILE}"
    [[ "-q" == "$1" ]] && quiet=1 && shift
    if [[ -z "$1" || "-c" == "$1" ]]; then
      [[ -f "${HHS_PATHS_FILE}" ]] || touch "${HHS_PATHS_FILE}"
      pad=$(printf '%0.1s' "."{1..70})
      pad_len=70
      columns=66
      echo ' '
      echo "${YELLOW}Listing all PATH entries:${NC}"
      echo ' '
      for path in $(echo -e "${PATH//:/\\n}"); do
        path="${path:0:$columns}"
        [[ -f "${HHS_PATHS_FILE}" ]] && custom="$(grep ^"$path"$ "${HHS_PATHS_FILE}")"
        [[ -d "${PVT_PATHS_D}" ]] && private="$(find ${PVT_PATHS_D} -type f -exec cat {} \; | grep ^"${path}"$)"
        [[ -d "${PATHS_D}" ]] && path_dir="$(find ${PATHS_D} -type f -exec cat {} \; | grep ^"${path}"$)"
        echo -en "${HHS_HIGHLIGHT_COLOR}${path}"
        printf '%*.*s' 0 $((pad_len - ${#path})) "${pad}"
        [[ "${#path}" -ge "${columns}" ]] && echo -en "${NC}" || echo -en "${NC}"
        if [[ -d "$path" ]]; then
          echo -en "${GREEN} ${CHECK_ICN} => ${WHITE}"
        else
          if [[ "-c" == "$1" ]]; then
            ised -e "s#(^$path$)*##g" -e '/^\s*$/d' "${HHS_PATHS_FILE}"
            export PATH=${PATH//$path:/}
            echo -en "${RED} ${CROSS_ICN} => "
          else
            echo -en "${ORANGE} ${CROSS_ICN} => "
          fi
        fi
        [[ -n "${custom}" ]] && echo -n "${YELLOW}Custom paths${NC}"
        [[ -n "${path_dir}" ]] && echo -n "${YELLOW}Private system paths${PATHS_D}${NC}"
        [[ -n "${private}" ]] && echo -n "${YELLOW}General system path dir${PVT_PATHS_D}${NC}"
        if [[ -z "${custom}" && -z "${path_dir}" && -z "${private}" ]]; then
          echo -n "Shell export"
        fi
        echo -e "${NC}"
      done
      echo -e "${NC}"
    elif [[ "-e" == "$1" ]]; then
      __hhs_edit "${HHS_PATHS_FILE}"
      return 0
    elif [[ "-a" == "$1" ]]; then
      [[ -z "$2" ]] && __hhs_errcho "${FUNCNAME[0]}" "Path \"$2\" is not valid" && return 1
      grep -qxF "$2" "${HHS_PATHS_FILE}" && return 0
      ised -e "s#(^$2$)*##g" -e '/^\s*$/d' "${HHS_PATHS_FILE}"
      if [[ -d "$2" ]]; then
        echo "$2" >>"${HHS_PATHS_FILE}"
        export PATH="$2:${PATH}"
        [[ -z "${quiet}" ]] && echo "${GREEN}Path was added: ${WHITE}\"$2\" ${NC}"
      else
        __hhs_errcho "${FUNCNAME[0]}" "Path \"$2\" does not exist" && return 1
      fi
    elif [[ "-r" == "$1" ]]; then
      [[ -z "$2" ]] && __hhs_errcho "${FUNCNAME[0]}" "Path \"$2\" is not valid" && return 1
      if grep -qxF "$2" "${HHS_PATHS_FILE}" && [[ -z ${quiet} ]]; then
        if ised -e "s#(^$2$)*##g" -e '/^\s*$/d' "${HHS_PATHS_FILE}"; then
          export PATH=${PATH//$2:/}
          echo "${YELLOW}Path was removed: ${WHITE}\"$2\" ${NC}"
        fi
      else
        __hhs_errcho "${FUNCNAME[0]}" "Path \"$2\" is not valid" && return 1
      fi
    fi
  fi

  return 0
}
