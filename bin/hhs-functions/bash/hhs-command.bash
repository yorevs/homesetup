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

  local cmdName cmdId cmdExpr pad pad_len mselectFile allCmds=() index=1

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

    # shellcheck disable=SC2046
    IFS=$'\n' read -d '' -r -a allCmds IFS="$HHS_RESET_IFS" <"$HHS_CMD_FILE"

    case "$1" in
    -e | --edit)
      vi "$HHS_CMD_FILE"
      return 0
      ;;
    -a | --add)
      shift
      cmdName=$(echo -en "$1" | tr -s '[:space:]' '_' | tr '[:lower:]' '[:upper:]')
      shift
      cmdExpr="$*"
      if [ -z "$cmdName" ] || [ -z "$cmdExpr" ]; then
        printf "${RED}Invalid arguments: \"$cmdName\"\t\"$cmdExpr\"${NC}"
        return 1
      fi
      ised -e "s#(^Command $cmdName: .*)*##" -e '/^\s*$/d' "$HHS_CMD_FILE"
      echo "Command $cmdName: $cmdExpr" >>"$HHS_CMD_FILE"
      sort "$HHS_CMD_FILE" -o "$HHS_CMD_FILE"
      echo "${GREEN}Command stored: ${WHITE}\"$cmdName\" as ${HIGHLIGHT_COLOR}$cmdExpr ${NC}"
      ;;
    -r | --remove)
      shift
      # Command ID can be the index or the alias
      cmdId=$(echo -en "$1" | tr -s '[:space:]' '_' | tr '[:lower:]' '[:upper:]')
      local re='^[1-9]+$'
      if [[ $cmdId =~ $re ]]; then
        cmdExpr=$(awk "NR==$1" "$HHS_CMD_FILE" | awk -F ': ' '{ print $0 }')
        ised -e "s#(^$cmdExpr)*##" -e '/^\s*$/d' "$HHS_CMD_FILE"
      elif [ -n "$cmdId" ]; then
        ised -e "s#(^Command $cmdId: .*)*##" -e '/^\s*$/d' "$HHS_CMD_FILE"
      else
        printf "${RED}Invalid arguments: \"$cmdId\"\t\"$cmdExpr\"${NC}"
        return 1
      fi
      echo "${YELLOW}Command removed: ${WHITE}\"$cmdId\" ${NC}"
      ;;
    -l | --list)
      if [ ${#allCmds[@]} -ne 0 ]; then

        pad=$(printf '%0.1s' "."{1..60})
        pad_len=40
        echo ' '
        echo "${YELLOW}Available commands (${#allCmds[@]}) stored:"
        echo ' '
        (
          IFS=$'\n'
          for next in ${allCmds[*]}; do
            cmdName="( $index ) $(echo -en "$next" | awk -F ':' '{ print $1 }')"
            cmdExpr=$(echo -en "$next" | awk -F ': ' '{ print $2 }')
            printf "${HIGHLIGHT_COLOR}${cmdName}"
            printf '%*.*s' 0 $((pad_len - ${#cmdName})) "$pad"
            echo "${YELLOW}is stored as: ${WHITE}'${cmdExpr}'"
            index=$((index + 1))
          done
          IFS="$HHS_RESET_IFS"
        )
        echo -e "${NC}"
      else
        echo "${YELLOW}No commands available yet !${NC}"
      fi
      ;;
    '')
      if [ ${#allCmds[@]} -ne 0 ]; then
        clear
        echo "${YELLOW}Available commands (${#allCmds[@]}) stored:"
        echo -en "${WHITE}"
        IFS=$'\n'
        mselectFile=$(mktemp)
        __hhs_mselect "$mselectFile" "${allCmds[*]}"
        # shellcheck disable=SC2181
        if [ "$?" -eq 0 ]; then
          selIndex=$(grep . "$mselectFile") # selIndex is zero-based
          cmdExpr=$(awk "NR==$((selIndex + 1))" "$HHS_CMD_FILE" | awk -F ': ' '{ print $2 }')
          [ -z "$cmdExpr" ] && cmdExpr=$(grep "Command $1:" "$HHS_CMD_FILE" | awk -F ': ' '{ print $2 }')
          [ -n "$cmdExpr" ] && echo "#> $cmdExpr" && eval "$cmdExpr"
        fi
        IFS="$HHS_RESET_IFS"
      else
        echo "${ORANGE}No commands available yet !${NC}"
      fi
      ;;
    [A-Z0-9_]*)
      cmdExpr=$(awk "NR==$1" "$HHS_CMD_FILE" | awk -F ': ' '{ print $2 }')
      [ -z "$cmdExpr" ] && cmdExpr=$(grep "Command $1:" "$HHS_CMD_FILE" | awk -F ': ' '{ print $2 }')
      [ -n "$cmdExpr" ] && echo -e "#> $cmdExpr" && eval "$cmdExpr"
      ;;
    *)
      echo -e "${RED}Invalid arguments: \"$1\"${NC}"
      return 1
      ;;
    esac
  fi

  [ -f "$mselectFile" ] && command rm -f "$mselectFile"

  return 0
}
