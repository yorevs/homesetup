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
    return 1
  fi

  suggestions=($(find -L "${dir%/}" -maxdepth 3 -type d -iname "${base}" 2>/dev/null | sed -E 's#\./(.*)/*#\1/#'))
  [ ${#suggestions[@]} -lt 2 ] && return 0
  COMPREPLY=("${suggestions[@]}")

  return 0
}

complete -o default -F __hhs_comp-load-dir load
complete -o default -F __hhs_comp-aliases aa
complete -o default -F __hhs_comp-cmd cmd
complete -o default -F __hhs_comp-godir go
