#!/bin/bash
# shellcheck disable=2206,2035,2086

#  Script: hhs-completion.bash
# Purpose: Bash completion for HomeSetup
# Created: Dec 19, 2019
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: homesetup@gmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <https://opensource.org/licenses/MIT>
#
# Copyright (c) 2024, HomeSetup team

# Complete command helper
__hhs_complete() {

  local all cur=$1 depth suggestions=()

  [[ ${#COMP_WORDS[@]} -gt $cur ]] && return

  depth=$((cur - 1))
  all=(${*})
  all=("${all[*]:1}")

  read -r -d '' -a suggestions < <(compgen -W "${all[@]}" -- "${COMP_WORDS[$depth]}")

  if [[ ${#COMP_WORDS[@]} -eq $cur ]]; then
    COMPREPLY=("${suggestions[@]}")
  fi
}

# Bash-Complete the function for: __hhs_load_dir
__hhs_comp_load_dir() {

  local suggestions

  read -r -d '' -a suggestions < <(grep . "$HHS_SAVED_DIRS_FILE" | awk -F'=' '{print $1}')

  __hhs_complete 2 "${suggestions[@]}"
}

# Bash-Complete the function for: __hhs_aliases
__hhs_comp_aliases() {

  local suggestions

  read -r -d '' -a suggestions < <(grep -v '^#' "${HOME}/.aliases" | cut -d ' ' -f2- | awk -F'=' '{print $1}')

  __hhs_complete 2 "${suggestions[@]}"
}

# Bash-Complete the function for: __hhs_command
__hhs_comp_cmd() {

  local suggestions

  read -r -d '' -a suggestions < <(esed 's/^Command ([A-Z0-9_]*):(.*)?/\1/' "$HHS_CMD_FILE")

  __hhs_complete 2 "${suggestions[@]}"
}

# Bash-Complete the function for: __hhs_envs
__hhs_comp_envs() {

  local suggestions=() filter
  filter=$(echo "${COMP_WORDS[1]}" | tr '[:lower:]' '[:upper:]')
  read -r -d '' -a suggestions < <(envs "${filter}" | cut -d ' ' -f1 | cse)
  COMP_WORDS[1]=$filter

  __hhs_complete 2 "${suggestions[@]}"
}

# Bash-Complete the function for: __hhs_paths
__hhs_comp_paths() {

  local suggestions=()

  if [[ ${#COMP_WORDS[@]} -le 2 ]]; then
    __hhs_complete 2 '-a' '-r' '-e' '-c'
  elif [[ "${COMP_WORDS[1]}" == "-r" ]]; then
    read -r -d '' -a suggestions < <(grep . "${HHS_PATHS_FILE}")
    __hhs_complete 3 "${suggestions[@]}"
  elif [[ "${COMP_WORDS[1]}" == '-a' ]]; then
    read -r -d '' -a suggestions < <(ls --color=never)
    __hhs_complete 3 "${suggestions[@]}"
  fi
}

# Bash-Complete the function for: __hhs_punch
__hhs_comp_punch() {

  local dir suggestions=()

  if [[ ${#COMP_WORDS[@]} -le 2 ]]; then
    __hhs_complete 2 '-w' '-e' '-l'
  elif [[ "${COMP_WORDS[1]}" == "-w" ]]; then
    dir="$(dirname "${HHS_PUNCH_FILE}")"
    read -r -d '' -a suggestions < <(find -L "${dir}" -maxdepth 1 -type f -iname "week-*.punch" 2>/dev/null)
    for i in "${!suggestions[@]}"; do
      suggestions[$i]=${suggestions[$i]//${dir}\//}
      suggestions[$i]=${suggestions[$i]//week-/}
      suggestions[$i]=${suggestions[$i]//\.punch/}
    done
    __hhs_complete 3 "${suggestions[@]}"
  fi
}

# Bash-Complete the function for: __hhs_godir
__hhs_comp_godir() {

  local dir name depth suggestions=()

  if [[ ${#COMP_WORDS[@]} -lt 2 ]]; then
    read -r -d '' -a suggestions < <(find -L * -maxdepth 0 -type d 2>/dev/null)
    __hhs_complete 2 "${suggestions[@]}"
    return
  fi

  dir="${COMP_WORDS[1]%/*}"
  name="${COMP_WORDS[1]##*/}"
  [[ -d "${dir}" ]] || dir="*"
  [[ 0 -gt $depth ]] && depth=0

  echo -e ' .....\b\b\b\b\b\b\c'
  read -r -d '' -a suggestions < <(find -L ${dir} -type d -iname "${name}*" 2>/dev/null)
  echo -e '      \b\b\b\b\b\b\c'

  __hhs_complete 2 "${suggestions[@]}"
}

# Complete the app hhs
__hhs_comp_hhs() {

  local suggestions=()

  [[ "${#COMP_WORDS[@]}" -gt 3 ]] && return 0

  IFS=$' '
  if [[ ${#COMP_WORDS[@]} -eq 2 ]]; then
    read -r -d '' -a suggestions < <(__hhs list -flat)
    __hhs_complete 2 "${suggestions[@]}"
  elif [[ ${#COMP_WORDS[@]} -eq 3 ]]; then
    suggestions=('help' 'version' 'execute')
    __hhs_complete 3 "${suggestions[@]}"
  fi
  IFS="${OLDIFS}"
}

complete -F __hhs_comp_godir godir
complete -F __hhs_comp_paths paths
complete -F __hhs_comp_load_dir load
complete -F __hhs_comp_aliases aa
complete -F __hhs_comp_cmd cmd
complete -F __hhs_comp_punch punch
complete -F __hhs_comp_envs envs
complete -F __hhs_comp_hhs hhs
