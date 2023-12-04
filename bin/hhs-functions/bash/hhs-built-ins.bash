#!/usr/bin/env bash

#  Script: hhs-built-ins.bash
# Created: Oct 6, 2019
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: homesetup@gmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <https://opensource.org/licenses/MIT>
#
# Copyright (c) 2023, HomeSetup team

# !NOTICE: Do not change this file. To customize your functions edit the file ~/.functions

# @function: Generate a random number int the range <min> <max> (all limits included).
# @param $1 [Req] : The minimum range of the number.
# @param $2 [Req] : The maximum range of the number.
function __hhs_random() {

  if [[ $# -ne 2 ]]; then
    echo "Usage: ${FUNCNAME[0]} <min> <max>"
    return 1
  else
    echo "$((RANDOM % ($2 - $1 + 1) + $1))"
  fi

  return 0
}

# @function: Convert string into it's decimal ASCII representation.
# @param $1 [Req] : The string to convert.
function __hhs_ascof() {

  if [[ $# -eq 0 || '-h' == "$1" ]]; then
    echo "Usage: ${FUNCNAME[0]} <character>"
    return 1
  fi
  echo -en "\n${GREEN}Dec:${NC}"
  echo -en "${@}" | od -An -t uC | head -n 1 | sed 's/^ */ /g'
  echo -en "${GREEN}Hex:${NC}"
  echo -en "${@}" | od -An -t xC | head -n 1 | sed 's/^ */ /g'
  echo -en "${GREEN}Str:${NC}"
  echo -e " ${*}\n"

  return $?
}

# @function: Convert unicode to hexadecimal
# @param $1..$N [Req] : The unicode values to convert
function __hhs_utoh() {

  local result converted uni ret_val=1

  if [[ $# -le 0 || "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: ${FUNCNAME[0]} <5d-unicode>"
    echo ''
    echo '  Notes: '
    echo '    - unicode is a four digits hexadecimal number. E.g:. F205'
    echo '    - exceeding digits will be ignored'
    return 1
  else
    echo ''
    for next in "$@"; do
      hexa="${next:0:4}"
      # More digits will be ignored
      uni="$(printf '%04s' "${hexa}")"
      [[ ${uni} =~ [0-9A-Fa-f]{4} ]] || continue
      echo -e "[${HHS_HIGHLIGHT_COLOR}Unicode:'\u${uni}'${NC}]"
      converted=$(python3 -c "import struct; print(bytes.decode(struct.pack('<I', int('${uni}', 16)), 'utf_32_le'))" | hexdump -Cb)
      ret_val=$?
      result=$(awk '
      NR == 1 {printf "  Hex => "; print "\\\\x"$2"\\\\x"$3"\\\\x"$4}
      NR == 2 {printf "  Oct => "; print "\\"$2"\\"$3"\\"$4}
      NR == 1 {printf "  Icn => "; print "\\x"$2"\\x"$3"\\x"$4}
      ' <<<"${converted}")
      echo -e "${GREEN}${result}${NC}"
      echo ''
    done
  fi

  return ${ret_val}
}

# @function: Open a file or URL with the default program.
# @param $1 [Req] : The url or filename to open.
function __hhs_open() {

  local filename="$1"

  if __hhs_has open && \open "${filename}"; then
    return $?
  elif __hhs_has xdg-open && \xdg-open "${filename}"; then
    return $?
  elif __hhs_has vim && \vim "${filename}"; then
    return $?
  elif __hhs_has vi && \vi "${filename}"; then
    return $?
  else
    __hhs_errcho "${FUNCNAME[0]}: Unable to open \"${filename}\". No suitable application found !"
  fi

  return 1
}

# @function: Create and/or open a file using the default editor.
# @param $1 [Req] : The file path.
function __hhs_edit() {

  local filename="$1" editor="${EDITOR:-vi}"

  if [[ $# -le 0 || "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: ${FUNCNAME[0]} <file_path>"
    return 1
  else
    [[ -s "${filename}" ]] || touch "${filename}" >/dev/null 2>&1
    [[ -s "${filename}" ]] || __hhs_errcho "${FUNCNAME[0]}: Unable to create file \"${filename}\""

    if [[ -n "${editor}" ]] && __hhs_has "${editor}" && ${editor} "${filename}"; then
      return $?
    elif __hhs_has gedit && \gedit "${filename}"; then
      return $?
    elif __hhs_has emacs && \emacs "${filename}"; then
      return $?
    elif __hhs_has vim && \vim "${filename}"; then
      return $?
    elif __hhs_has vi && \vi "${filename}"; then
      return $?
    elif __hhs_has cat && \cat >"${filename}"; then
      return $?
    else
      __hhs_errcho "${FUNCNAME[0]}: Unable to find a suitable editor for the file \"${filename}\" !"
    fi
  fi

  return 1
}

# @function: Display information about the given command.
# @param $1 [Req] : The command to check.
function __hhs_about() {

  local cmd type_ret=() cmd_type cmd_details i=0

  if [[ $# -eq 0 || "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: ${FUNCNAME[0]} <command>"
    return 1
  else
    cmd=${1}
    IFS=$'\n'
    read -r -d '' -a type_ret orig_ret < <(type "${cmd}" 2>/dev/null)
    IFS="${OLDIFS}"
    if [[ ${#type_ret[@]} -gt 0 ]]; then
      echo ''
      if [[ "${type_ret[0]}" == *"is aliased to"* ]]; then
        cmd_details="Aliased:"
        cmd_type=${type_ret[0]//is aliased to \`/${WHITE}=> }
        cmd_type=${cmd_type// \`/: }
        cmd_type=${cmd_type// \'/}
        printf "${GREEN}%12s${BLUE} ${cmd_type//\%/%%} ${NC}\n" "${cmd_details}"
        # To avoid unalias the command, we do that in another subshell
        (
          if unalias "${cmd}" 2>/dev/null; then
            IFS=$'\n'
            read -r -d '' -a orig_ret < <(type "${cmd}" 2>/dev/null)
            IFS="${OLDIFS}"
            if [[ ${#orig_ret[@]} -gt 0 ]]; then
              cmd_type=${orig_ret//is/${WHITE}=>}
              printf "${GREEN}%12s${BLUE} ${cmd_type} ${NC}\n" "Unaliased:"
            fi
          fi
        )
      elif [[ "${type_ret[0]}" == *"is a function"* ]]; then
        printf "${GREEN}%12s${BLUE} ${type_ret[1]}${WHITE}=> \n" "Function:"
        for line in "${type_ret[@]:2}"; do
          printf "   %4d: %s\n" $((i += 1)) "${line}"
        done
      else
        cmd_type=${type_ret//is /${WHITE}=> }
        printf "${GREEN}%12s${BLUE} ${cmd_type//\%/%%} ${NC}\n" "Command:"
      fi
      echo -e "${NC}"
    else
      echo -e "${YELLOW}No matches found for: ${cmd}${NC}"
    fi
  fi

  return 0
}

# @function: Display a help for the given command.
# @param $1 [Req] : The command to get help.
function __hhs_help() {

  local cmd

  if [[ $# -eq 0 || "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: ${FUNCNAME[0]} <command>"
    return 1
  else
    cmd="${1}"
    if ! ${cmd} --help 2>/dev/null; then
      if ! ${cmd} -h 2>/dev/null; then
        if ! ${cmd} help 2>/dev/null; then
          if ! ${cmd} /? 2>/dev/null; then
            __hhs_errcho "${RED}Help not available for ${cmd}"
          fi
        fi
        return 1
      fi
    fi
  fi

  return 0
}

# @function: Display the current working dir and remote repository if it applies.
# @param $1 [Req] : The command to get help.
function __hhs_where_am_i() {
  echo "${GREEN}Current directory: ${NC}$(pwd -LP)"
  if __hhs_has git && git rev-parse --is-inside-work-tree &>/dev/null; then
    echo "${GREEN}Remote repository: ${NC}$(git remote -v | head -n 1 | awk '{print $2}')"
  fi
}
