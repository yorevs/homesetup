#!/usr/bin/env bash
# shellcheck disable=SC2086,SC2207

#  Script: hhs-punch.bash
# Created: Oct 5, 2019
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <https://opensource.org/licenses/MIT>
# !NOTICE: Do not change this file. To customize your functions edit the file ~/.functions

# @function: PUNCH-THE-CLOCK. This is a helper tool to aid with the timesheets.
# @param $1 [Con] : The week list punches from.
function __hhs_punch() {

  local line_totals=() totals=() date_stamp time_stamp week_stamp opt lines=() balance
  local re pad pad_len daily_total daily_total_dec weekly_total weekly_total_dec success

  HHS_PUNCH_FILE=${HHS_PUNCH_FILE:-$HHS_DIR/.punches}

  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: ${FUNCNAME[0]} [options] <args>"
    echo ''
    echo '    Options: '
    echo '      -l        : List all registered punches.'
    echo '      -e        : Edit current punch file.'
    echo '      -r        : Reset punches for the current week and save the previous one.'
    echo '      -w <week> : Report (list) all punches of specified week using the pattern: week-N.punch.'
    echo ''
    echo '  Notes: '
    echo '    When no arguments are provided it will !!PUNCH THE CLOCK!!.'
    return 1
  else
    opt="${1}"
    date_stamp="$(date +'%a %d-%m-%Y')"
    time_stamp="$(date +'%H:%M')"
    week_stamp="$(date +%V)"
    re="($date_stamp).*"

    # Create the punch file if it does not exist
    if [[ ! -f "${HHS_PUNCH_FILE}" ]]; then
      echo "$date_stamp => " > "${HHS_PUNCH_FILE}"
    fi
  
    IFS=$'\n' 
    if [[ "-w" == "$opt" ]]; then
      shift
      week_stamp="${1:-${week_stamp}}"
      week_stamp=$(printf "%02d" "${week_stamp}")
      WEEK_PUNCH_FILE="$(dirname "${HHS_PUNCH_FILE}")/week-${week_stamp}.punch"
      if [[ -f "$WEEK_PUNCH_FILE" ]]; then
        lines=($(grep -E "^((Mon|Tue|Wed|Thu|Fri|Sat|Sun) )(([0-9]+-?)+) =>.*" "$WEEK_PUNCH_FILE"))
      else
        echo "${YELLOW}Week ${week_stamp} punch file ($WEEK_PUNCH_FILE) not found !"
        return 1
      fi
    else
      lines=($(grep -E "^((Mon|Tue|Wed|Thu|Fri|Sat|Sun) )(([0-9]+-?)+) =>.*" "${HHS_PUNCH_FILE}"))
    fi
    IFS="${RESET_IFS}"

    # Edit punches
    if [[ "-e" == "$opt" ]]; then
      __hhs_edit "${HHS_PUNCH_FILE}"
    # Reset punches (backup as week-N.punch)
    elif [[ "-r" == "$opt" ]]; then
      mv -f "${HHS_PUNCH_FILE}" "$(dirname "${HHS_PUNCH_FILE}")/week-${week_stamp}.punch"
    else
      pad=$(printf '%0.1s' "."{1..60})
      pad_len=36
      # Display the Header of totals when listing
      if [[ "-l" == "$opt" || "-w" == "$opt" ]]; then
        echo -e "\n${YELLOW}Week-${week_stamp} punches"
        printf '%0.1s' "-"{1..82}
        echo "${NC}"
      fi
      # Loop through all of the timestamps
      for idx in "${!lines[@]}"; do
        line="$(echo "${lines[idx]}" | awk 'BEGIN { OFS=" "}; {$1=$1; print $0}')"
        if [[ -z "$opt" && "${line}" =~ $re ]]; then
          # Do the punch of the current day
          ised "s#(${date_stamp}) => (.*)#\1 => \2${time_stamp} #g" "${HHS_PUNCH_FILE}"
          success='1'
          break
        # List week or current punches
        elif [[ "-l" == "$opt" || "-w" == "$opt" ]]; then
          echo -en "${line//${date_stamp}/${HHS_HIGHLIGHT_COLOR}${date_stamp}}"
          # Read all timestamps and append them into an array.
          IFS=' ' read -r -a line_totals <<< "$(echo "${line}" | awk -F '=> ' '{ print $2 }')"
          # If we have an even number of timestamps, display subtotals; **:** otherwise
          if [[ ${#line_totals[@]} -gt 0 && "$(echo "${#line_totals[@]} % 2" | bc)" -eq 0 ]]; then
            daily_total="$(tcalc.py ${line_totals[5]} - ${line_totals[4]} + ${line_totals[3]} - ${line_totals[2]} + ${line_totals[1]} - ${line_totals[0]})"        # Up to 3 pairs of timestamps.
            daily_total_dec="$(tcalc.py -d ${line_totals[5]} - ${line_totals[4]} + ${line_totals[3]} - ${line_totals[2]} + ${line_totals[1]} - ${line_totals[0]})" # Up to 3 pairs of timestamps.
            printf ' %*.*s' 0 $((pad_len - ${#line_totals[@]} * 6)) "${pad}"
            # If the daily subtotal is greater or equal to the nominal 8 hours, color it green; red otherwise.
            if [[ "$daily_total" =~ ^([12][0-9]|0[89]):..:.. ]]; then
              echo -e " : Subtotal = ${GREEN}${daily_total:0:5} -> ${daily_total_dec:0:5} ${NC}"
            else
              echo -e " : Subtotal = ${RED}${daily_total:0:5} -> ${daily_total_dec:0:5} ${NC}"
            fi
            totals+=("$daily_total")
          else
            echo -e "${RED} --:-- ${NC}"
          fi
        fi
      done

      # Display totals of the week when listing - Footer
      if [[ "-l" == "$opt" || "-w" == "$opt" ]]; then
        weekly_total="$(tcalc.py ${totals[0]} + ${totals[1]} + ${totals[2]} + ${totals[3]} + ${totals[4]} + ${totals[5]} + ${totals[6]})"
        weekly_total_dec="$(tcalc.py -d ${totals[0]} + ${totals[1]} + ${totals[2]} + ${totals[3]} + ${totals[4]} + ${totals[5]} + ${totals[6]})"
        printf "${YELLOW}%0.1s" "-"{1..82}
        # If the weekly subtotal is greater or equal to the nominal 40 hours, color it green; red otherwise.
        if [[ "$weekly_total" =~ ^([4-9][0-9]):..:.. ]]; then
          balance=$(tcalc.py ${weekly_total} - 40:00)
          printf "${WHITE}\nTotal = ${GREEN}%s\n\n${NC}" "${weekly_total:0:5} -> ${weekly_total_dec:0:5}  (+${balance:0:5})"
        else
          balance=$(tcalc.py 40:00 - ${weekly_total})
          printf "${WHITE}\nTotal = ${RED}%s\n\n${NC}" "${weekly_total:0:5} -> ${weekly_total_dec:0:5}  (-${balance:0:5})"
        fi
      else
        # Create a new time_stamp if it's the first punch for the day
        [[ "$success" = '1' ]] || echo "$date_stamp => $time_stamp " >> "${HHS_PUNCH_FILE}"
        grep "$date_stamp" "${HHS_PUNCH_FILE}" | sed "s/$date_stamp/${GREEN}Today${NC}/g"
      fi
    fi
  fi

  return 0
}
