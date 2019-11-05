#!/usr/bin/env bash

#  Script: hhs-mselect.sh
# Created: Oct 5, 2019
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <http://unlicense.org/>
# !NOTICE: Do not change this file. To customize your functions edit the file ~/.functions

# @function: Select an option from a list using a navigable menu.
# @param $1 [Req] : The response file.
# @param $2 [Req] : The array of options.
function __hhs_mselect() {
    
    if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
        echo 'Usage: mselect <output_file> <option1 option2 ...>'
        echo ''
        echo 'Notes: '
        echo '  - If only one option is available, mselect will select it and return.'
        echo '  - A temporary file is suggested to used with this function: [mktemp].'
        echo '  - The outfile must not exist or be empty.'

        return 1
    fi

    test -d "$1" -o -s "$1" && echo -e "${RED}\"$1\" is a directory or an existing non-empty file!${NC}" && return 1

    MSELECT_MAX_ROWS=${MSELECT_MAX_ROWS:=10}

    local len
    local allOptions=()
    local selIndex=0
    local showFrom=0
    local showTo=$((MSELECT_MAX_ROWS-1))
    local diffIndex=$((showTo-showFrom))
    local index=''
    local outfile=$1
    local columns
    local optStr

    shift
    # shellcheck disable=SC2206
    allOptions=( $* )
    len=${#allOptions[*]}

    # When only one option is provided, select the index 0
    [ "$len" -eq 1 ] && echo "0" > "$outfile" && return 0
    save-cursor-pos
    disable-line-wrap

    while :
    do
        columns="$(($(tput cols)-7))"
        hide-cursor

        echo "${WHITE}"
        for i in $(seq "$showFrom" "$showTo"); do
            optStr="${allOptions[i]:0:$columns}"
            # Erase current line before repaint
            echo -ne "\033[2K\r"
            [ "$i" -ge "$len" ] && break
            if [ "$i" -ne $selIndex ]; then 
                printf " %.${#len}d  %0.4s %s" "$((i+1))" ' ' "$optStr"
            else
                printf "${HIGHLIGHT_COLOR} %.${#len}d  %0.4s %s" "$((i+1))" '>' "$optStr"
            fi
            [ "${#optStr}" -ge "$columns" ] && echo -e "\033[4D\033[K...${NC}" || echo -e "${NC}"
        done
        
        echo "${YELLOW}"
        read -rs -n 1 -p "[Enter] to Select, [Up-Down] to Navigate, [Q] to Quit: " ANS

        case "$ANS" in
            'q' | 'Q') 
                # Exit
                echo "${NC}"
                show-cursor
                enable-line-wrap
                return 1
            ;;
            [1-9]) # When a number is typed, try to scroll to index
                show-cursor
                index="$ANS"
                echo -n "$ANS"
                while [ "${#index}" -lt "${#len}" ]
                do
                    read -rs -n 1 ANS2
                    [ -z "$ANS2" ] && break
                    echo -n "$ANS2"
                    index="${index}${ANS2}"
                done
                hide-cursor
                # Erase the index typed
                echo -ne "\033[$((${#index}+1))D\033[K"
                if [[ "$index" =~ ^[0-9]*$ ]] && [ "$index" -ge 1 ] && [ "$index" -le "$len" ]; then
                    showTo=$((index-1))
                    [ "$showTo" -le "$diffIndex" ] && showTo=$diffIndex
                    showFrom=$((showTo-diffIndex))
                    selIndex=$((index-1))
                fi
            ;;
            $'\033') # Handle escape '\e[nX' codes
                read -rsn2 ANS
                case "$ANS" in
                [A) # Up-arrow
                    # Previous
                    if [ "$selIndex" -eq "$showFrom" ] && [ "$showFrom" -gt 0 ]; then
                        showFrom=$((showFrom-1))
                        showTo=$((showTo-1))
                    fi
                    [ $((selIndex-1)) -ge 0 ] && selIndex=$((selIndex-1))
                ;;
                [B) # Down-arrow
                    # Next
                    if [ "$selIndex" -eq "$showTo" ] && [ "$((showTo+1))" -lt "$len" ]; then
                        showFrom=$((showFrom+1))
                        showTo=$((showTo+1))
                    fi
                    [ $((selIndex+1)) -lt "$len" ] && selIndex=$((selIndex+1))
                ;;
                esac
            ;;
            '') # Enter
                # Select
                echo ''
                break
            ;;
        esac
        
        # Erase current line and restore the cursor to the home position
        restore-cursor-pos

    done
    IFS="$RESET_IFS"
    
    show-cursor
    enable-line-wrap
    echo "$selIndex" > "$outfile"
    echo -ne "${NC}"
    
    return 0
}