#!/usr/bin/env bash

#  Script: hhs-punch.bash
# Created: Oct 5, 2019
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <http://unlicense.org/>
# !NOTICE: Do not change this file. To customize your functions edit the file ~/.functions

# @function: Punch the Clock. Add/Remove/Edit/List clock punches.
# @param $1 [Opt] : Punch options
function __hhs_punch() {

  local line_totals=() totals=() date_stamp time_stamp week_stamp opt lines=()
  local re pad pad_len sub_total sub_total_dec week_total week_total_dec success

  HHS_PUNCH_FILE=${HHS_PUNCH_FILE:-$HHS_DIR/.punches}

  if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    echo "Usage: ${FUNCNAME[0]} [options] <args>"
    echo ''
    echo '    Options: '
    echo '      -l        : List all registered punches.'
    echo '      -e        : Edit current punch file.'
    echo '      -r        : Reset punches for the current week.'
    echo '      -w <week> : Report (list) all punches of specified week using the pattern: week-N.punch.'
    echo ''
    echo '  Notes: '
    echo '    When no arguments are provided it will !!PUNCH THE CLOCK!!.'
    return 1
  else
    opt="$1"
    date_stamp="$(date +'%a %d-%m-%Y')"
    time_stamp="$(date +'%H:%M')"
    week_stamp="$(date +%V)"
    re="($date_stamp).*"
    # Create the punch file if it does not exist
    if [ ! -f "$HHS_PUNCH_FILE" ]; then
      echo "$date_stamp => " > "$HHS_PUNCH_FILE"
    fi
    # shellcheck disable=SC2207
    if [ "-w" = "$opt" ]; then
      shift
      week_stamp="${1:-$week_stamp}"
      week_stamp=$(printf "%02d" "${week_stamp}")
      WEEK_PUNCH_FILE="$(dirname "$HHS_PUNCH_FILE")/week-${week_stamp}.punch"
      if [ -f "$WEEK_PUNCH_FILE" ]; then
        lines=($(grep -E "^((Mon|Tue|Wed|Thu|Fri|Sat|Sun) )(([0-9]+-?)+) =>.*" "$WEEK_PUNCH_FILE"))
      else
        echo "${YELLOW}Week $week_stamp punch file ($WEEK_PUNCH_FILE) not found!"
        return 1
      fi
    else
      lines=($(grep -E "^((Mon|Tue|Wed|Thu|Fri|Sat|Sun) )(([0-9]+-?)+) =>.*" "$HHS_PUNCH_FILE"))
    fi
    # Edit punches
    if [ "-e" = "$opt" ]; then
      edit "$HHS_PUNCH_FILE"
    # Reset punches (backup as week-N.punch)
    elif [ "-r" = "$opt" ]; then
      mv -f "$HHS_PUNCH_FILE" "$(dirname "$HHS_PUNCH_FILE")/week-$week_stamp.punch"
    else
      pad=$(printf '%0.1s' "."{1..60})
      pad_len=36

      # Display totals of the week when listing - Header
      if [ "-l" = "$opt" ] || [ "-w" = "$opt" ]; then
        echo ''
        echo -e "${YELLOW}Week (${week_stamp}) punches"
        printf '%0.1s' "-"{1..79}
        echo "${NC}"
      fi

      IFS=$'\n'
      for idx in "${!lines[@]}"; do
        line="$(echo "${lines[idx]}" | awk 'BEGIN { OFS=" "}; {$1=$1; print $0}')"
        # List punches
        if [ "-l" = "$opt" ] || [ "-w" = "$opt" ]; then
          echo -en "${line//${date_stamp}/${HHS_HIGHLIGHT_COLOR}${date_stamp}}"
          # Read all timestamps and append them into an array.
          IFS=' ' read -r -a line_totals <<< "$(echo "${line}" | awk -F '=> ' '{ print $2 }')"
          # If we have an even number of timestamps, display the subtotals.
          # shellcheck disable=SC2086
          if [ ${#line_totals[@]} -gt 0 ] && [ "$(echo "${#line_totals[@]} % 2" | bc)" -eq 0 ]; then
            sub_total="$(tcalc.py ${line_totals[5]} - ${line_totals[4]} + ${line_totals[3]} - ${line_totals[2]} + ${line_totals[1]} - ${line_totals[0]})"        # Up to 3 pairs of timestamps.
            sub_total_dec="$(tcalc.py -d ${line_totals[5]} - ${line_totals[4]} + ${line_totals[3]} - ${line_totals[2]} + ${line_totals[1]} - ${line_totals[0]})" # Up to 3 pairs of timestamps.
            sub_total_dec=${sub_total_dec//:/.}
            printf ' %*.*s' 0 $((pad_len - ${#line_totals[@]} * 6)) "${pad}"
            # If the sub total is gerater or equal to 8 hours, color it green, red otherwise.
            if [[ "$sub_total" =~ ^([12][0-9]|0[89]):..:.. ]]; then
              echo -e " : Total = ${GREEN}${sub_total:0:5} -> ${sub_total_dec:0:5} ${NC}"
            else
              echo -e " : Total = ${RED}${sub_total:0:5} -> ${sub_total_dec:0:5} ${NC}"
            fi
            totals+=("$sub_total")
          else
            echo -e "${RED} **:** ${NC}"
          fi
        # Do the punch of the current day
        elif [[ "${line}" =~ $re ]]; then
          ised "s#(${date_stamp}) => (.*)#\1 => \2${time_stamp} #g" "$HHS_PUNCH_FILE"
          success='1'
          break
        fi
      done
      IFS=$"$HHS_RESET_IFS"

      # Display totals of the week when listing - Footer
      # shellcheck disable=SC2086
      if [ "-l" = "$opt" ] || [ "-w" = "$opt" ]; then
        week_total="$(tcalc.py ${totals[0]} + ${totals[1]} + ${totals[2]} + ${totals[3]} + ${totals[4]} + ${totals[5]} + ${totals[6]})"
        week_total_dec="$(tcalc.py -d ${totals[0]} + ${totals[1]} + ${totals[2]} + ${totals[3]} + ${totals[4]} + ${totals[5]} + ${totals[6]})"
        echo -en "${YELLOW}"
        printf '%0.1s' "-"{1..79}
        echo "${WHITE}"
        printf "%79s\n" ">> Total = ${week_total:0:5} -> ${week_total_dec:0:5}"
        echo "${NC}"
      else
        # Create a new time_stamp if it's the first punch for the day
        [ "$success" = '1' ] || echo "$date_stamp => $time_stamp " >> "$HHS_PUNCH_FILE"
        grep "$date_stamp" "$HHS_PUNCH_FILE" | sed "s/$date_stamp/${GREEN}Today${NC}/g"
      fi
    fi
  fi

  return 0
}
