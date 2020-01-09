#!/usr/bin/env bash

#  Script: hhs-command.bash
# Created: Oct 5, 2019
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <http://unlicense.org/>
# !NOTICE: Do not change this file. To customize your functions edit the file ~/.functions

# @function: Add/Remove/List/Execute saved bash commands.
# @param $1 [Opt] : The command options.
function __hhs_command() {

  HHS_CMD_FILE=${HHS_CMD_FILE:-$HHS_DIR/.cmd_file}

  local cmd_name cmd_alias cmd_expr pad pad_len mselect_file all_cmds=() index=1 sel_index

  touch "$HHS_CMD_FILE"

  if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    echo "Usage: ${FUNCNAME[0]} [options [cmd_alias] <cmd_expression>] | [cmd_index]"
    echo ''
    echo 'Options: '
    echo "    [cmd_index] : Execute the command specified by the command index."
    echo "             -e : Edit the commands file."
    echo "             -a : Store a command."
    echo "             -r : Remove a command."
    echo "             -l : List all stored commands."
    return 1
  else
    
    case "$1" in
    -e | --edit)
      edit "$HHS_CMD_FILE"
      return 0
      ;;
    -a | --add)
      shift
      cmd_name=$(echo -en "$1" | tr -s '[:space:]' '_' | tr '[:lower:]' '[:upper:]')
      shift
      cmd_expr="$*"
      if [ -z "$cmd_name" ] || [ -z "$cmd_expr" ]; then
        echo -e "${RED}Invalid arguments: \"$cmd_name\"\t\"$cmd_expr\"${NC}"
        return 1
      fi
      ised -e "s#(^Command $cmd_name: .*)*##g" -e '/^\s*$/d' "$HHS_CMD_FILE"
      IFS=$'\n' read -d '' -r -a all_cmds IFS="$HHS_RESET_IFS" < "$HHS_CMD_FILE"
      all_cmds+=("Command $cmd_name: $cmd_expr")
      printf "%s\n" "${all_cmds[@]}" > "$HHS_CMD_FILE"
      sort "$HHS_CMD_FILE" -o "$HHS_CMD_FILE"
      echo "${GREEN}Command stored: ${WHITE}\"$cmd_name\" as ${HHS_HIGHLIGHT_COLOR}$cmd_expr ${NC}"
      ;;
    -r | --remove)
      shift
      # Command ID can be the index or the alias
      cmd_alias=$(echo -en "$1" | tr -s '[:space:]' '_' | tr '[:lower:]' '[:upper:]')
      local re='^[1-9]+$'
      if [[ $cmd_alias =~ $re ]]; then
        cmd_expr=$(awk "NR==$1" "$HHS_CMD_FILE" | awk -F ': ' '{ print $0 }')
        [ -z "${cmd_expr}" ] && echo "${RED}Command index not found: \"${cmd_alias}\"" && return 1
        ised -e "/^${cmd_expr}$/d" "$HHS_CMD_FILE"
        echo "${YELLOW}Command ${WHITE}($cmd_alias)${NC} removed !"
      elif [ -n "$cmd_alias" ]; then
        cmd_expr=$(grep "${cmd_alias}" "$HHS_CMD_FILE")
        [ -z "${cmd_expr}" ] && echo "${RED}Command not found: \"${cmd_alias}\"" && return 1
        ised -e "s#(^Command $cmd_alias: .*)*##g" -e '/^\s*$/d' "$HHS_CMD_FILE"
        echo "${YELLOW}Command removed: ${WHITE}\"$cmd_alias\" ${NC}"
      else
        echo -e "${RED}Invalid arguments: \"$cmd_alias\"\t\"$cmd_expr\"${NC}"
        return 1
      fi
      ;;
    -l | --list)
      IFS=$'\n' read -d '' -r -a all_cmds IFS="$HHS_RESET_IFS" < "$HHS_CMD_FILE"
      if [ ${#all_cmds[@]} -ne 0 ]; then
        pad=$(printf '%0.1s' "."{1..60})
        pad_len=40
        echo ' '
        echo "${YELLOW}Available commands (${#all_cmds[@]}) stored:"
        echo ' '
        for next in ${all_cmds[*]}; do
          printf "${WHITE}(%03d) " $((index))
          cmd_name="$(echo -en "$next" | awk -F ':' '{ print $1 }')"
          cmd_expr=$(echo -en "$next" | awk -F ': ' '{ print $2 }')
          echo -n "${HHS_HIGHLIGHT_COLOR}${cmd_name}"
          printf '%*.*s' 0 $((pad_len - ${#cmd_name})) "$pad"
          echo "${YELLOW} is stored as: ${WHITE}'${cmd_expr}'"
          index=$((index + 1))
        done
        echo -e "${NC}"
      else
        echo "${YELLOW}No commands available yet !${NC}"
      fi
      ;;
    '')
      IFS=$'\n' read -d '' -r -a all_cmds IFS="$HHS_RESET_IFS" < "$HHS_CMD_FILE"
      if [ ${#all_cmds[@]} -ne 0 ]; then
        clear
        echo "${YELLOW}Available commands (${#all_cmds[@]}) stored:"
        echo -en "${WHITE}"
        IFS=$'\n'
        mselect_file=$(mktemp)
        if __hhs_mselect "$mselect_file" "${all_cmds[*]}"; then
          sel_index=$(grep . "$mselect_file")
          # sel_index is zero-based, so we need to increment this number
          cmd_expr=$(awk "NR==$((sel_index + 1))" "$HHS_CMD_FILE" | awk -F ': ' '{ print $2 }')
          [ -z "$cmd_expr" ] && cmd_expr=$(grep "Command $1:" "$HHS_CMD_FILE" | awk -F ': ' '{ print $2 }')
          [ -n "$cmd_expr" ] && echo "#> $cmd_expr" && eval "$cmd_expr"
        fi
        IFS="$HHS_RESET_IFS"
      else
        echo "${ORANGE}No commands available yet !${NC}"
      fi
      ;;
    [A-Z0-9_]*)
      cmd_expr=$(awk "NR==$1" "$HHS_CMD_FILE" | awk -F ': ' '{ print $2 }')
      [ -z "$cmd_expr" ] && cmd_expr=$(grep "Command $1:" "$HHS_CMD_FILE" | awk -F ': ' '{ print $2 }')
      [ -n "$cmd_expr" ] && echo -e "#> $cmd_expr" && eval "$cmd_expr"
      [ -z "$cmd_expr" ] && echo "${RED}Command aliased by \"$1\" was not found !${NC}"
      ;;
    *)
      echo -e "${RED}Invalid arguments: \"$1\"${NC}"
      return 1
      ;;
    esac
  fi

  [ -f "$mselect_file" ] && command rm -f "$mselect_file"

  return 0
}
