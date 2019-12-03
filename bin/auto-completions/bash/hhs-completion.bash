__hhs_comp-load-dir() {

  if [ "${#COMP_WORDS[@]}" != "2" ]; then
    return
  fi

  local allDirs=()
  IFS=$'\n' read -d '' -r -a allDirs IFS="$HHS_RESET_IFS" <"$HHS_SAVED_DIRS"
  local suggestions=($(compgen -W "$(grep . "$HHS_SAVED_DIRS" | awk -F'=' '{print $1}')" -- "${COMP_WORDS[1]}"))

  if [ "${#suggestions[@]}" == "1" ]; then
    local number="${suggestions[0]/%\ */}"
    COMPREPLY=("$number")
  else
    for i in "${!suggestions[@]}"; do
      suggestions[$i]="$(echo "${suggestions[$i]}")"
    done
    COMPREPLY=("${suggestions[@]}")
  fi
}

__hhs_comp-aliases() {

  if [ "${#COMP_WORDS[@]}" != "2" ]; then
    return
  fi

  local aliasFile="$HOME/.aliases"
  local allDirs=()
  IFS=$'\n' read -d '' -r -a allDirs IFS="$HHS_RESET_IFS" <"$aliasFile"
  local suggestions=($(compgen -W "$(grep -v '^#' "$aliasFile" | awk -F'=' '{print $1}')" -- "${COMP_WORDS[1]}"))

  if [ "${#suggestions[@]}" == "1" ]; then
    local number="${suggestions[0]/%\ */}"
    COMPREPLY=("$number")
  else
    for i in "${!suggestions[@]}"; do
      suggestions[$i]="$(echo "${suggestions[$i]}")"
    done
    COMPREPLY=("${suggestions[@]}")
  fi
}

complete -F __hhs_comp-load-dir load
complete -F __hhs_comp-aliases aa
