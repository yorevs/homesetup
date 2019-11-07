#!/usr/bin/env bash

#  Script: hhs-search.bash
# Created: Oct 5, 2019
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <http://unlicense.org/>
# !NOTICE: Do not change this file. To customize your functions edit the file ~/.functions

# @function: Search for files and links to files recursively.
# @param $1 [Req] : The base search path.
# @param $2 [Req] : The GLOB expressions of the file search.
function __hhs_search-file() {

    local inames
    local gflags="-E"

    if [ "$1" = "-h" ] || [ "$1" = "--help" ] || [ "$#" -ne 2 ]; then
        echo ''
        echo "Usage: ${FUNCNAME[0]} <search_path> <comma_separated_globs>"
        echo '  ** Globs listed like: "*.txt,*.md,*.rtf"'
        echo ''
        return 1
    else
        local expr="e=\"$2\"; a=e.split(','); print(' -o '.join(['-iname \"{}\"'.format(s) for s in a]))"
        inames=$(python -c "$expr")
        echo "Searching for files or linked files matching: \"$2\" in \"$1\""
        eval "find -L $1 -type f \( $inames \) | __hhs_highlight \"(${2//\*/.*}|\$)\""
        return $?
    fi
}

# @function: Search for directories and links to directories recursively.
# @param $1 [Req] : The base search path.
# @param $2 [Req] : The GLOB expressions of the directory search.
function __hhs_search-dir() {
    
    local inames
    local gflags="-E"
    
    if [ "$1" = "-h" ] || [ "$1" = "--help" ] || [ "$#" -ne 2 ]; then
        echo ''
        echo "Usage: ${FUNCNAME[0]} <search_path> <comma_separated_dirs>"
        echo '  ** Dirs listed like: "dir1,dir2,dir2"'
        echo ''
        return 1
    else
        local expr="e=\"$2\"; a=e.split(','); print(' -o '.join(['-iname \"{}\"'.format(s) for s in a]))"
        inames=$(python -c "$expr")
        echo "Searching for folders or linked folders matching: [$2] in \"$1\""
        eval "find -L $1 -type d \( $inames \) | __hhs_highlight \"(${2//\*/.*}|\$)\""
        return $?
    fi
}

# @function: Search for strings matching the specified criteria in files recursively.
# @param $1 [Req] : Search options.
# @param $2 [Req] : The base search path.
# @param $3 [Req] : The searching string.
# @param $4 [Req] : The GLOB expression of the file search.
# @param $5 [Opt] : Whether to replace the findings.
# @param $6 [Con] : Required if $4 is provided. This is the replacement string.
function __hhs_search-string() {

    local gflags extra_str replace inames
    local strType='regex'
    local gflags="-HnEI"

    if [ "$1" = "-h" ] || [ "$1" = "--help" ] || [ "$#" -lt 3 ]; then
        echo ''
        echo "Usage: ${FUNCNAME[0]} [options] <search_path> <regex/string> <comma_separated_globs>"
        echo ''
        echo 'Options: '
        echo '    -i | --ignore-case              : Makes the search case INSENSITIVE.'
        echo '    -w | --words                    : Makes the search to use the STRING words instead of a REGEX.'
        echo '    -r | --replace <replacement>    : Makes the search to REPLACE all occurrences by the replacement string.'
        echo '    -b | --binary                   : Includes BINARY files in the search.'
        echo ''
        return 1
    else
        while [ -n "$1" ]
        do
            case "$1" in
                -w | --words)
                    gflags="${gflags//E/Fw}"
                    strType='string'
                ;;
                -i | --ignore-case)
                    gflags="${gflags}i"
                    strType="${strType}-ignore-case"
                ;;
                -b | --binary)
                    gflags="${gflags//I/}"
                    strType="${strType}+binary"
                ;;
                -r | --replace)
                    replace=1
                    shift
                    repl_str="$1"
                    extra_str=", replacement: \"$repl_str\""
                ;;
                *)
                    [[ ! "$1" =~ ^-[wir] ]] && break
                ;;
            esac
            shift
        done
        
        local expr="e=\"$3\"; a=e.split(','); print(' -o '.join(['-iname \"{}\"'.format(s) for s in a]))"
        local search_str="$2"
        
        inames=$(python -c "$expr")
        echo "${YELLOW}Searching for \"${strType}\" matching: \"$search_str\" in \"$1\" , filenames = [$3] $extra_str ${NC}"
        
        if [ -n "$replace" ]; then
            if [ "$strType" = 'string' ]; then
                echo "${RED}Can't replace non-Regex expressions in search!${NC}"
                return 1
            fi
            [ "Linux" = "${HHS_MY_OS}" ] && eval "find -L $1 -type f \( $inames \) -exec grep $gflags \"$search_str\" {} \; -exec sed -i \"s/$search_str/$repl_str/g\" {} + | sed \"s/$search_str/$repl_str/g\" | __hhs_highlight \"($repl_str|\$)\""
            [ "Darwin" = "${HHS_MY_OS}" ] && eval "find -L $1 -type f \( $inames \) -exec grep $gflags \"$search_str\" {} \; -exec sed -i '' \"s/$search_str/$repl_str/g\" {} + | sed \"s/$search_str/$repl_str/g\" | __hhs_highlight \"($repl_str|\$)\""
        else
            eval "find -L $1 -type f \( $inames \) -exec grep $gflags \"$search_str\" {} + | __hhs_highlight \"($search_str|\$)\""
        fi
    fi

    return 0
}
