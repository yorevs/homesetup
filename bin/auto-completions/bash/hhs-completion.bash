# shellcheck disable=SC2206,SC2207

__hhs_complete() {

  local all suggestions=()

  [ "${#COMP_WORDS[@]}" != "2" ] && return 0

  all=(${*/%\ */})
  suggestions=($(compgen -W "${all[*]}" -- "${COMP_WORDS[1]}"))

  if [ "${#all[@]}" == "1" ]; then
    local reply="${all[0]/%\ */}"
    COMPREPLY=("${reply}")
  else
    COMPREPLY=("${suggestions[@]}")
  fi

  return 0
}

__hhs_comp-load-dir() {

  local suggestions=($(grep . "$HHS_SAVED_DIRS" | awk -F'=' '{print $1}'))

  __hhs_complete "${suggestions[@]}"

  return $?
}

__hhs_comp-aliases() {

  local suggestions=($(grep -v '^#' "$HOME/.aliases" | cut -d ' ' -f2- | awk -F'=' '{print $1}'))

  __hhs_complete "${suggestions[@]}"

  return $?
}

__hhs_comp-cmd() {

  local suggestions=($(sed -E 's/^Command ([A-Z0-9_]*):(.*)?/\1/' "$HHS_CMD_FILE"))

  __hhs_complete "${suggestions[@]}"

  return $?
}

__hhs_comp-punch() {

  if [ "${#COMP_WORDS[@]}" == "2" ]; then
    COMPREPLY=($(compgen -W "-w -e -l" -- "${COMP_WORDS[1]}"))
    return 0
  elif [ "${COMP_WORDS[1]}" != "-w" ]; then
    return 0
  elif [ "${#COMP_WORDS[@]}" != "3" ]; then
    return 0
  fi

  local dir puch_weeks suggestions=()

  dir="$(dirname "$HHS_PUNCH_FILE")"
  IFS=$'\n'
  puch_weeks="week-*.punch"
  read -d '' -r -a suggestions <<<"$(find -L "${dir}" -maxdepth 1 -type f -iname "${puch_weeks}" 2>/dev/null)"
  for i in "${!suggestions[@]}"; do
    suggestions[$i]="${suggestions[$i]//${dir}\//}"
    suggestions[$i]=${suggestions[$i]//week-/}
    suggestions[$i]=${suggestions[$i]//\.punch/}
  done
  IFS=$"${HHS_RESET_IFS}"
  suggestions=($(compgen -W "${suggestions[*]}" -- "${COMP_WORDS[2]}"))
  COMPREPLY=("${suggestions[@]}")

  return $?
}

__hhs_comp-envs() {

  local suggestions=() filter
  echo -e " (Searching, please wait...)\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\c"
  filter=$(echo "${COMP_WORDS[1]}" | tr '[:lower:]' '[:upper:]')
  suggestions=($(envs "${filter}" | cut -d ' ' -f1 | cse))
  echo -e "                            \b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\c"
  COMP_WORDS[1]=$filter

  __hhs_complete "${suggestions[@]}"

  return $?
}

__hhs_comp-paths() {

  local suggestions=()

  if [ "${#COMP_WORDS[@]}" == "2" ]; then
    COMPREPLY=($(compgen -W "-a -r -e -c" -- "${COMP_WORDS[1]}"))
    return 0
  elif [ "${COMP_WORDS[1]}" != "-r" ]; then
    return 0
  elif [ "${#COMP_WORDS[@]}" != "3" ]; then
    return 0
  fi

  local dir puch_weeks suggestions=()
  IFS=$'\n'
  read -d '' -r -a suggestions <<<"$(grep . "${HHS_PATHS_FILE}")"
  IFS=$"${HHS_RESET_IFS}"
  suggestions=($(compgen -W "${suggestions[*]}" -- "${COMP_WORDS[2]}"))
  COMPREPLY=("${suggestions[@]}")

  return 0
}

__hhs_comp-godir() {

  local dir base suggestions=()

  [ "${#COMP_WORDS[@]}" != "2" ] && return 0
  [ -d "${COMP_WORDS[1]}" ] && return 1

  dir="$(dirname "${COMP_WORDS[1]:-.}")"
  base="$(basename "${COMP_WORDS[1]:-*}")"

  if [ -d "${dir}" ] && [ -d "${base}" ]; then
    dir="${dir%/}/${base}"
    base="*"
  elif [ -d "${dir}" ] && [ ! -d "${base}" ]; then
    base="${base}*"
  else
    # Execute the default complete (pathname)
    return 1
  fi
  # Let the user know about the search
  echo -e " (Searching, please wait...)\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\c"
  IFS=$'\n'
  read -d '' -r -a suggestions <<<"$(find -L "${dir%/}" -maxdepth "${HHS_MAX_DEPTH}" -type d -iname "${base}" 2>/dev/null | sed -E 's#\./(.*)/*#\1/#')"
  IFS=$"${HHS_RESET_IFS}"
  # Erase the searching text after search is done
  echo -e "                            \b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\c"
  # If there's only one option, avoid to complete it as usual since it's a search
  [ ${#suggestions[@]} -lt 2 ] && return 0
  COMPREPLY=("${suggestions[@]}")

  return 0
}

complete -o default -F __hhs_comp-godir godir
complete -F __hhs_comp-load-dir load
complete -F __hhs_comp-aliases aa
complete -F __hhs_comp-cmd cmd
complete -F __hhs_comp-punch punch
complete -F __hhs_comp-paths paths
complete -F __hhs_comp-envs envs
