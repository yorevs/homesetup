# shellcheck disable=SC2206,SC2207

__hhs_comp() {
  
  local all=($*) suggestions=()

  if [ "${#COMP_WORDS[@]}" != "2" ] || [ "${#all[@]}" == "0" ]; then
    return
  fi

  if [ "${#all[@]}" == "1" ]; then
    local reply="${all[0]/%\ */}"
    COMPREPLY=("$reply")
    suggestions+=($reply)
  else
    for i in "${!all[@]}"; do
      suggestions[$i]="$(${all[$i]})"
    done
    COMPREPLY=("${all[@]}")
  fi

  compgen -W "${suggestions[@]}" -- "${COMP_WORDS[1]}"
}

__hhs_comp-load-dir() {

  local suggestions=($(grep . "$HHS_SAVED_DIRS" | awk -F'=' '{print $1}'))
  
  __hhs_comp "${suggestions[@]}"
}

__hhs_comp-aliases() {

  local aliasFile="$HOME/.aliases"
  local suggestions=($(grep -v '^#' "$aliasFile" | awk -F'=' '{print $1}'))

  __hhs_comp "${suggestions[@]}"
}

__hhs_comp-cmd() {

  local suggestions=($(sed -E 's/^Command ([A-Z0-9_]*):(.*)?/\1/' "$HHS_CMD_FILE"))

  __hhs_comp "${suggestions[@]}"
}

complete -F __hhs_comp-load-dir load
complete -F __hhs_comp-aliases aa
complete -F __hhs_comp-cmd cmd