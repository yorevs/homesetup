#!/usr/bin/env bash

#  Script: hhs-punch.sh
# Created: Oct 5, 2019
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <http://unlicense.org/>
# !NOTICE: Do not change this file. To customize your functions edit the file ~/.functions

# @function: Punch the Clock. Add/Remove/Edit/List clock punches.
# @param $1 [Opt] : Punch options
function __hhs_punch() {

    PUNCH_FILE=${PUNCH_FILE:-$HHS_DIR/.punches}

    local dateStamp
    local timeStamp
    local weekStamp
    local opt
    local lines
    local re

    if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
        echo "Usage: ${FUNCNAME[0]} [options] <args>"
        echo 'Options: '
        echo "              : !!PUNCH THE CLOCK!! (When no option is provided)."
        echo "    -l        : List all registered punches."
        echo "    -e        : Edit current punch file."
        echo "    -r        : Reset punches for the current week."
        echo "    -w <week> : Report (list) all punches of specified week using the pattern: week-N.punch."
        return 1
    else
        opt="$1"
        dateStamp="$(date +'%a %d-%m-%Y')"
        timeStamp="$(date +'%H:%M')"
        weekStamp="$(date +%V)"
        re="($dateStamp).*"
        # Create the punch file if it does not exist
        if [ ! -f "$PUNCH_FILE" ]; then 
            echo "$dateStamp => " >"$PUNCH_FILE"
        fi
        if [ "-w" = "$opt" ]; then
            shift
            weekStamp="${1:-$weekStamp}"
            WEEK_PUNCH_FILE="$(dirname "$PUNCH_FILE")/week-$weekStamp.punch"
            if [ -f "$WEEK_PUNCH_FILE" ]; then
                lines=$(grep -E "^((Mon|Tue|Wed|Thu|Fri|Sat|Sun) )(([0-9]+-?)+) =>.*" "$WEEK_PUNCH_FILE")
            else
                echo "${YELLOW}Week $weekStamp punch file ($WEEK_PUNCH_FILE) not found!"
                return 1
            fi
        else
            lines=$(grep -E "^((Mon|Tue|Wed|Thu|Fri|Sat|Sun) )(([0-9]+-?)+) =>.*" "$PUNCH_FILE")
        fi
        # Edit punches
        if [ "-e" = "$opt" ]; then
            vi "$PUNCH_FILE"
        # Reset punches (backup as week-N.punch)
        elif [ "-r" = "$opt" ]; then
            mv -f "$PUNCH_FILE" "$(dirname "$PUNCH_FILE")/week-$weekStamp.punch"
        else
            (
                local lineTotals=()
                local totals=()
                local pad
                local pad_len
                local subTotal
                local weekTotal
                local success
                pad=$(printf '%0.1s' "."{1..60})
                pad_len=36

                # Display totals of the week when listing - Header
                if [ "-l" = "$opt" ] || [ "-w" = "$opt" ]; then
                    echo ''
                    echo -e "${YELLOW}Week ($weekStamp) punches:"
                    echo "---------------------------------------------------------------------------${NC}"
                fi
                
                if [ -n "$lines" ]; then
                    IFS=$'\n'
                    for line in $lines; do
                        # List punches
                        if [ "-l" = "$opt" ] || [ "-w" = "$opt" ]; then
                            echo -n "${line//${dateStamp}/${HIGHLIGHT_COLOR}${dateStamp}}"
                            # Read all timestamps and append them into an array.
                            IFS=' ' read -r -a lineTotals <<< "$(echo "$line" | awk -F '=> ' '{ print $2 }')"
                            # If we have an even number of timestamps, display the subtotals.
                            if [ ${#lineTotals[@]} -gt 0 ] && [ "$(echo "${#lineTotals[@]} % 2" | bc)" -eq 0 ]; then
                                # shellcheck disable=SC2086
                                subTotal="$(tcalc.py ${lineTotals[5]} - ${lineTotals[4]} + ${lineTotals[3]} - ${lineTotals[2]} + ${lineTotals[1]} - ${lineTotals[0]})" # Up to 3 pairs of timestamps.
                                printf '%*.*s' 0 $((pad_len - ${#lineTotals[@]} * 6)) "$pad"
                                # If the sub total is gerater or equal to 8 hours, color it green, red otherwise.
                                [[ "$subTotal" =~ ^([12][0-9]|0[89]):..:.. ]] && echo -e " : Total = ${GREEN}${subTotal}${NC}" || echo -e " : Total = ${RED}${subTotal}${NC}"
                                totals+=("$subTotal")
                            else
                                echo "${RED}**:**${NC}"
                            fi
                        # Do the punch to the current day
                        elif [[ "$line" =~ $re ]]; then
                            ised -e "s#($dateStamp) => (.*)#\1 => \2$timeStamp #g" "$PUNCH_FILE"
                            success='1'
                            break
                        fi
                    done
                    IFS="$RESET_IFS"
                fi

                # Display totals of the week when listing - Footer
                if [ "-l" = "$opt" ] || [ "-w" = "$opt" ]; then
                    # shellcheck disable=SC2086
                    weekTotal="$(tcalc.py ${totals[0]} + ${totals[1]} + ${totals[2]} + ${totals[3]} + ${totals[4]} + ${totals[5]} + ${totals[6]} )"
                    echo -e "${YELLOW}---------------------------------------------------------------------------"
                    echo -e "Week ($weekStamp) Total: ${weekTotal}${NC}"
                    echo ''
                else
                    # Create a new timestamp if it's the first punch for the day
                    [ "$success" = '1' ] || echo "$dateStamp => $timeStamp " >>"$PUNCH_FILE"
                    grep "$dateStamp" "$PUNCH_FILE" | sed "s/$dateStamp/${GREEN}Today${NC}/g"
                fi
            )
        fi
    fi

    return 0
}