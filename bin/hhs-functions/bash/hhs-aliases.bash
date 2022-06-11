#!/usr/bin/env bash
# shellcheck disable=SC1090

#  Script: hhs-aliases.bash
# Created: Oct 5, 2019
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <https://opensource.org/licenses/MIT>
# !NOTICE: Do not change this file. To customize your functions edit the file ~/.functions

# @function: Manipulate custom aliases (add/remove/edit/list).
# @param $1 [Req] : The alias name.
# @param $2 [Opt] : The alias expression.
function __hhs_aliases() {
  
  HHS_ALIASES_FILE=${HHS_ALIASES_FILE:-$HHS_DIR/.aliases}

  local filter='.+' alias_name alias_expr pad pad_len all_aliases is_sorted=0 name expr
  local col_offset=18 columns re
  
  touch "${HHS_ALIASES_FILE}"

  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: ${FUNCNAME[0]} [-s|--sort] <alias> <alias_expr>"
    echo ''
    echo '    Options: '
    echo '      -e | --edit    : Open the aliases file for editing.'
    echo '      -s | --sort    : Sort results ASC.'
    echo '      -r | --remove  : Remove an alias.'
    echo ''
    echo '  Notes: '
    echo '    List all aliases    : When [alias_expr] is NOT provided. If [alias] is provided, filter results using it.'
    echo '    Add/Set an alias    : When both [alias] and [alias_expr] are provided.'
    echo ''
    return 1
  else

    if [[ "$1" == '-e' || "$1" == "--edit" ]]; then
      __hhs_edit "${HHS_ALIASES_FILE}"
      return $?
    elif [[ "$1" == '-r' || "$1" == "--remove" ]] && [[ -n "$2" ]]; then
      alias_name="$2"
      # Remove one alias
      ised -e "s#(^alias ${alias_name}=.*)*##g" -e '/^\s*$/d' "${HHS_ALIASES_FILE}"
      if unalias "${alias_name}" &>/dev/null; then
        echo -e "${YELLOW}Alias removed: ${WHITE}\"${alias_name}\" ${NC}"
      else
        echo -e "${RED}Alias not found: \"${alias_name}\" ${NC}"
      fi
      return $?
    fi
    if [[ "$1" == '-s' || "$1" == "--sort" ]]; then
      is_sorted=1
      shift
    fi

    alias_name="$1"
    shift
    alias_expr="${*}"
    alias_expr="${alias_expr//$'\n'/ }"

    if [[ -z "${alias_expr}" ]]; then
      # List all aliases; if sorted, skips comments
      if [[ "$is_sorted" == "0" ]]; then
        all_aliases=$(grep -v ^\# "${HHS_ALIASES_FILE}")
      else
        all_aliases=$(grep -v ^\# "${HHS_ALIASES_FILE}" | sort)
      fi
      if [[ -n "${all_aliases}" ]]; then
        pad=$(printf '%0.1s' "."{1..60})
        pad_len=40
        [[ -n "${alias_name}" ]] && filter="${alias_name}"
        echo ' '
        echo "${YELLOW}Available custom aliases matching [${filter}]:"
        echo ' '
        (
          columns="$(($(tput cols) - pad_len - col_offset))"
          IFS=$'\n'
          for next in ${all_aliases}; do
            re="^alias .+=.+"
            if [[ ${next} =~ ${re} ]]; then
              name=$(echo -en "${next}" | cut -d'=' -f1 | cut -d ' ' -f2)
              [[ ${name} =~ ${filter} ]] || continue
              expr=$(echo -en "${next}" | cut -d'=' -f2-)
              printf "%s" "${HHS_HIGHLIGHT_COLOR}${name//alias /}"
              printf '%*.*s' 0 $((pad_len - ${#name})) "${pad}"
              echo -en "${YELLOW} is aliased to ${WHITE}${expr:0:${columns}}"
            else
              echo -en "${GREEN}${next:0:${columns}}${NC}"
            fi
            [[ "${#expr}" -ge "${columns}" ]] && echo "..."
            echo -e "${NC}"
          done
          IFS="${RESET_IFS}"
        )
        echo -e "${NC}"
      else
        echo -e "${ORANGE}No aliases were found in \"${HHS_ALIASES_FILE}\" !${NC}"
      fi
    elif [[ -n "${alias_name}" && -n "${alias_expr}" ]]; then
      # Add/Set one alias
      ised -e "s#(^alias ${alias_name}=.*)*##g" -e '/^\s*$/d' "${HHS_ALIASES_FILE}"
      echo "alias ${alias_name}='${alias_expr}'" >>"${HHS_ALIASES_FILE}"
      echo -e "${GREEN}Alias set: ${WHITE}\"${alias_name}\" is ${HHS_HIGHLIGHT_COLOR}'${alias_expr}' ${NC}"
      \. "${HHS_ALIASES_FILE}"
    fi
  fi

  return 0
}
