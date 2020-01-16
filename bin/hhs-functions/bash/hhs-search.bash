#!/usr/bin/env bash

#  Script: hhs-search.bash
# Created: Oct 5, 2019
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <http://unlicense.org/>
# !NOTICE: Do not change this file. To customize your functions edit the file ~/.functions

if __hhs_has "python"; then

  # @function: Search for files and links to files recursively.
  # @param $1 [Req] : The base search path.
  # @param $2 [Req] : The GLOB expressions of the file search.
  function __hhs_search-file() {

    local inames expr

    if [ "$1" = "-h" ] || [ "$1" = "--help" ] || [ "$#" -ne 2 ]; then
      echo "Usage: ${FUNCNAME[0]} <search_path> <file_globs...>"
      echo ''
      echo '  Notes: '
      echo '    ** <file_globs...>: Comma separated globs. E.g: "*.txt,*.md,*.rtf"'
      return 1
    else
      expr="e=\"$2\"; a=e.split(','); print(' -o '.join(['-iname \"{}\"'.format(s) for s in a]))"
      inames=$(python -c "$expr")
      echo "${YELLOW}Searching for files matching: \"$2\" in \"$1\" ${NC}"
      eval "find -L $1 -type f \( $inames \) 2> /dev/null | __hhs_highlight \"(${2//\*/.*}|$)\""
      return $?
    fi
  }

  # @function: Search for directories and links to directories recursively.
  # @param $1 [Req] : The base search path.
  # @param $2 [Req] : The GLOB expressions of the directory search.
  function __hhs_search-dir() {

    local inames expr dir="${1}" filter="${2}"

    if [ "$1" = "-h" ] || [ "$1" = "--help" ] || [ "$#" -ne 2 ]; then
      echo "Usage: ${FUNCNAME[0]} <search_path> <dir_names...>"
      echo ''
      echo '  Notes: '
      echo '  ** <dir_names...>: Comma separated directories. E.g:. "dir1,dir2,dir2"'
      return 1
    else
      expr="e=\"${filter}\"; a=e.split(','); print(' -o '.join(['-iname \"{}\"'.format(s) for s in a]))"
      inames=$(python -c "$expr")
      echo "${YELLOW}Searching for folders matching: [${filter}] in \"${dir}\" ${NC}"
      eval "find -L ${dir} -type d \( $inames \) 2> /dev/null | __hhs_highlight \"(${filter//\*/.*}|$)\""
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

    local gflags extra_str replace inames filter_type='regex' gflags="-HnEI"
    local names_expr search_str="${2}" base_cmd full_cmd dir="${1}"

    if [ "$1" = "-h" ] || [ "$1" = "--help" ] || [ "$#" -lt 3 ]; then
      echo ''
      echo "Usage: ${FUNCNAME[0]} [options] <search_path> <regex/string> <file_globs>"
      echo ''
      echo '    Options: '
      echo '      -i | --ignore-case            : Makes the search case INSENSITIVE.'
      echo '      -w | --words                  : Makes the search to use the STRING words instead of a REGEX.'
      echo '      -r | --replace <replacement>  : Makes the search to REPLACE all occurrences by the replacement string.'
      echo '      -b | --binary                 : Includes BINARY files in the search.'
      echo ''
      echo '  Notes: '
      echo '    ** <file_globs...>: Comma separated globs. E.g: "*.txt,*.md,*.rtf"'
      return 1
    else
      while [ -n "$1" ]; do
        case "$1" in
          -w | --words)
            gflags="${gflags//E/Fw}"
            filter_type='string'
            ;;
          -i | --ignore-case)
            gflags="${gflags}i"
            filter_type="${filter_type}-ignore-case"
            ;;
          -b | --binary)
            gflags="${gflags//I/}"
            filter_type="${filter_type}+binary"
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

      names_expr="e=\"${3}\"; a=e.split(','); print(' -o '.join(['-iname \"{}\"'.format(s) for s in a]))"
      inames=$(python -c "$names_expr")
      base_cmd="find -L ${dir} -type f \( $inames \) -exec grep $gflags \"$search_str\" {}"
      
      echo "${YELLOW}Searching for \"${filter_type}\" matching: \"$search_str\" in \"${dir}\" , filenames = [$3] ${extra_str} ${NC}"

      if [ -n "$replace" ]; then
        if [ "$filter_type" = 'string' ]; then
          echo "${RED}Can't search and replace non-Regex expressions!${NC}"
          return 1
        fi
        [ "Linux" = "${HHS_MY_OS}" ] && full_cmd="${base_cmd} \; -exec sed -i \"s/$search_str/$repl_str/g\" {} + | sed \"s/$search_str/$repl_str/g\" 2> /dev/null | __hhs_highlight $repl_str"
        [ "Darwin" = "${HHS_MY_OS}" ] && full_cmd="${base_cmd} \; -exec sed -i '' \"s/$search_str/$repl_str/g\" {} + | sed \"s/$search_str/$repl_str/g\" 2> /dev/null | __hhs_highlight $repl_str"
      else
        full_cmd="${base_cmd} + 2> /dev/null | __hhs_highlight $search_str"
      fi
      eval "${full_cmd}"
      return $?
    fi

    return 1
  }

fi
