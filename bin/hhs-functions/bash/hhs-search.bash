#!/usr/bin/env bash

#  Script: hhs-search.bash
# Created: Oct 5, 2019
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: homesetup@gmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <https://opensource.org/licenses/MIT>
#
# Copyright (c) 2023, HomeSetup team

# !NOTICE: Do not change this file. To customize your functions edit the file ~/.functions

if __hhs_has "python3"; then

  # @function: Search for files and links to files recursively.
  # @param $1 [Req] : The base search path.
  # @param $2 [Req] : The search glob expressions.
  function __hhs_search_file() {

    local inames expr filter dir

    if [[ "$#" -ne 2 || "$1" == "-h" || "$1" == "--help" ]]; then
      echo "Usage: ${FUNCNAME[0]} <search_path> <globs...>"
      echo ''
      echo '  Notes: '
      echo '    ** <globs...>: Comma separated globs. E.g: "*.txt,*.md,*.rtf"'
      return 1
    else
      dir="${1}"
      filter="${2}"
      expr="e=\"$filter\"; a=e.split(','); print(' -o '.join(['-iname \"{}\"'.format(s) for s in a]))"
      inames=$(python -c "$expr")
      echo "${YELLOW}Searching for files matching: \"$filter\" in \"$dir\" ${NC}"
      eval "find -L $dir -type f \( ${inames} \) 2> /dev/null | __hhs_highlight \"(${filter//\*/.*}|$)\""

      return $?
    fi
  }

  # @function: Search for directories and links to directories recursively.
  # @param $1 [Req] : The base search path.
  # @param $2 [Req] : The search glob expressions.
  function __hhs_search_dir() {

    local inames expr dir filter

    if [[ "$#" -ne 2 || "$1" == "-h" || "$1" == "--help" ]]; then
      echo "Usage: ${FUNCNAME[0]} <search_path> <dir_names...>"
      echo ''
      echo '  Notes: '
      echo '  ** <dir_names...>: Comma separated directories. E.g:. "dir1,dir2,dir2"'
      return 1
    else
      dir="${1}"
      filter="${2}"
      expr="e=\"${filter}\"; a=e.split(','); print(' -o '.join(['-iname \"{}\"'.format(s) for s in a]))"
      inames=$(python -c "$expr")
      echo "${YELLOW}Searching for folders matching: [${filter}] in \"${dir}\" ${NC}"
      eval "find -L ${dir} -type d \( ${inames} \) 2> /dev/null | __hhs_highlight \"(${filter//\*/.*}|$)\""

      return $?
    fi
  }

  # @function: Search in files for strings matching the specified criteria recursively.
  # @param $1 [Req] : Search options.
  # @param $2 [Req] : The base search path.
  # @param $3 [Req] : The searching string.
  # @param $4 [Req] : The GLOB expression of the file search.
  # @param $5 [Opt] : Whether to replace the findings.
  # @param $6 [Con] : Required if $4 is provided. This is the replacement string.
  function __hhs_search_string() {

    local gflags extra_str replace inames filter_type='regex' gflags="-HnEI"
    local names_expr search_str base_cmd full_cmd dir

    if [[ "$#" -lt 3 || "$1" == "-h" || "$1" == "--help" ]]; then
      echo "Usage: ${FUNCNAME[0]} [options] <search_path> <regex/string> <globs>"
      echo ''
      echo '    Options: '
      echo '      -i | --ignore-case            : Makes the search case INSENSITIVE.'
      echo '      -w | --words                  : Makes the search to use the STRING words instead of a REGEX.'
      echo '      -r | --replace <replacement>  : Makes the search to REPLACE all occurrences by the replacement string.'
      echo '      -b | --binary                 : Includes BINARY files in the search.'
      echo ''
      echo '  Notes: '
      echo '    ** <globs...>: Comma separated globs. E.g: "*.txt,*.md,*.rtf"'
      return 1
    else
      while [[ -n "$1" ]]; do
        case "$1" in
        -w | --words)
          gflags="${gflags//E/Fw}"
          filter_type=${filter_type//regex/string}
          ;;
        -i | --ignore-case)
          gflags="${gflags}i"
          filter_type="${filter_type}+ignore-case"
          ;;
        -b | --binary)
          gflags="${gflags//I/}"
          filter_type="${filter_type}+binary"
          ;;
        -r | --replace)
          replace=1
          shift
          [[ -z "$1" ]] && __hhs_errcho "${FUNCNAME[0]}: Missing replacement string !" && return 1
          repl_str="$1"
          extra_str=", replacement: \"${repl_str}\""
          ;;
        *)
          [[ ! "$1" =~ ^-[wibr] && ! "$1" =~ ^--(words|ignore-case|binary|replace) ]] && break
          ;;
        esac
        shift
      done

      dir="${1}"
      search_str="${2}"
      names_expr="e=\"${3}\"; a=e.split(','); print(' -o '.join(['-iname \"{}\"'.format(s) for s in a]))"
      inames=$(python -c "${names_expr}")
      base_cmd="find -L ${dir} -type f \( ${inames} \) -exec grep $gflags \"${search_str}\" {}"

      echo "${YELLOW}Searching for \"${filter_type}\" matching: \"${search_str}\" in \"${dir}\" , file_globs = [${3}] ${extra_str} ${NC}"

      if [[ -n "$replace" ]]; then
        if [[ "$filter_type" = 'string' ]]; then
          __hhs_errcho "${FUNCNAME[0]}: Can't search and replace non-Regex expressions !"
          return 1
        fi
        [[ "${HHS_MY_OS}" == "Darwin" ]] && ised="sed -i '' -E"
        [[ "${HHS_MY_OS}" == "Linux" ]] && ised="sed -i'' -r"
        full_cmd="${base_cmd} \; -exec $ised \"s/${search_str}/${repl_str}/g\" {} + | sed \"s/${search_str}/${repl_str}/g\"  | __hhs_highlight \"${repl_str}\""
      else
        full_cmd="${base_cmd} + 2> /dev/null | __hhs_highlight \"${search_str}\""
      fi
      eval "${full_cmd}"
      return $?
    fi

    return 1
  }

fi
