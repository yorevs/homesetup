#!/usr/bin/env bash
# shellcheck disable=SC1090

#  Script: hhs-aliases.bash
# Created: Oct 5, 2019
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <http://unlicense.org/>
# !NOTICE: Do not change this file. To customize your functions edit the file ~/.functions

# @function: Manipulate custom aliases (add/remove/edit/list).
# @param $1 [Req] : The alias name.
# @param $2 [Opt] : The alias expression.
function __hhs_aliases() {

  local alias_file alias_name alias_expr pad pad_len all_aliases is_sorted=0

  if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    echo "Usage: ${FUNCNAME[0]} [-s|--sort] [alias] [alias_expr]"
    echo ''
    echo 'Options: '
    echo '           -e | --edit    : Edit the aliases file.'
    echo '           -s | --sort    : Sort results ASC.'
    echo '      List all aliases    : When both [alias] and [alias_expr] are NOT provided.'
    echo '      Add/Set an alias    : When both [alias] and [alias_expr] are provided.'
    echo '      Remove the alias    : When [alias] is provided but [alias_expr] is not provided.'
    echo ''
    return 1
  else
    alias_file="$HOME/.aliases"
    touch "$alias_file"
    test "$1" = '-e' -o "$1" = "--edit" && vi "$alias_file" && return 0
    test "$1" = '-s' -o "$1" = "--sort" && is_sorted=1 && shift

    alias_name="$1"
    shift
    alias_expr="$*"

    if [ -z "$alias_name" ] && [ -z "$alias_expr" ]; then
      # List all aliases
      test "$is_sorted" = "0" && all_aliases=$(grep . "$alias_file") || all_aliases=$(grep . "$alias_file" | sort)
      if [ -n "$all_aliases" ]; then
        pad=$(printf '%0.1s' "."{1..60})
        pad_len=40
        echo ' '
        echo "${YELLOW}Available custom aliases:"
        echo ' '
        (
          local name expr offset=18
          local columns="$(($(tput cols) - pad_len - offset))"
          IFS=$'\n'
          for next in $all_aliases; do
            local re='^alias .+=.+'
            if [[ $next =~ $re ]]; then
              name=$(echo -en "$next" | cut -d'=' -f1 | cut -d ' ' -f2)
              expr=$(echo -en "$next" | cut -d'=' -f2-)
              printf "%s" "${HHS_HIGHLIGHT_COLOR}${name//alias /}"
              printf '%*.*s' 0 $((pad_len - ${#name})) "$pad"
              echo -en "${YELLOW} is aliased to ${WHITE}${expr:0:$columns}"
            else
              echo -en "${GREEN}${next:0:$columns}${NC}"
            fi
            [ "${#expr}" -ge "$columns" ] && echo "..."
            echo -e "${NC}"
          done
          IFS="$HHS_RESET_IFS"
        )
        echo -e "${NC}"
      else
        echo -e "${ORANGE}No aliases were found in \"$alias_file\" !${NC}"
      fi
    elif [ -n "$alias_name" ] && [ -n "$alias_expr" ]; then
      # Add/Set one alias
      ised -E -e "s#(^alias $alias_name=.*)*##g" -e '/^\s*$/d' "$alias_file"
      echo "alias $alias_name='$alias_expr'" >>"$alias_file"
      echo -e "${GREEN}Alias set: ${WHITE}\"$alias_name\" is ${HHS_HIGHLIGHT_COLOR}'$alias_expr' ${NC}"
      \. "$alias_file"
    elif [ -n "$alias_name" ] && [ -z "$alias_expr" ]; then
      # Remove one alias
      ised -E -e "s#(^alias $alias_name=.*)*##g" -e '/^\s*$/d' "$alias_file"
      unalias "$alias_name" &>/dev/null
      # shellcheck disable=SC2181
      [[ $? -eq 0 ]] && echo -e "${YELLOW}Alias removed: ${WHITE}\"$alias_name\" ${NC}"
    fi
  fi

  return 0
}
