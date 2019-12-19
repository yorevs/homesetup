# shellcheck disable=SC2206,SC2207

__hhs_complete() {

  [ "${#COMP_WORDS[@]}" != "2" ] && return
  
  local all=(${*/%\ */})
  local suggestions=($(compgen -W "${all[*]}" -- "${COMP_WORDS[1]}"))

  if [ "${#all[@]}" == "1" ]; then
    local reply="${all[0]/%\ */}"
    COMPREPLY=("${reply}")
  else
    COMPREPLY=("${suggestions[@]}")
  fi
}

__hhs_comp-load-dir() {

  local suggestions=($(grep . "$HHS_SAVED_DIRS" | awk -F'=' '{print $1}'))

  __hhs_complete "${suggestions[@]}"
}

__hhs_comp-aliases() {

  local suggestions=($(grep -v '^#' "$HOME/.aliases" | cut -d ' ' -f2- | awk -F'=' '{print $1}'))

  __hhs_complete "${suggestions[@]}"
}

__hhs_comp-cmd() {

  local suggestions=($(sed -E 's/^Command ([A-Z0-9_]*):(.*)?/\1/' "$HHS_CMD_FILE"))

  __hhs_complete "${suggestions[@]}"
}

__hhs_comp-godir() {

  [ "${#COMP_WORDS[@]}" != "2" ] && return

  local dir="${COMP_WORDS[1]}"
  local suggestions=($(find -L . -maxdepth 3 -type d -iname "${dir}" 2>/dev/null | sed 's/\.\///g'))
  COMPREPLY=("${suggestions[@]}")
}

complete -F __hhs_comp-load-dir load
complete -F __hhs_comp-aliases aa
complete -F __hhs_comp-cmd cmd
complete -F __hhs_comp-godir go
