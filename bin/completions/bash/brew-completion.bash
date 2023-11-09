if type brew &>/dev/null
then
  BREW_PREFIX="$(brew --prefix)"
  if [[ -r "${BREW_PREFIX}/etc/profile.d/bash_completion.sh" ]]
  then
    __hhs_source "${BREW_PREFIX}/etc/profile.d/bash_completion.sh"
  else
    for BREW_COMPLETION in "${BREW_PREFIX}/etc/bash_completion.d/"*
    do
      # shellcheck disable=SC1090
      if [[ -r "${BREW_COMPLETION}" ]]; then
        __hhs_source "${BREW_COMPLETION}"
      fi
    done
  fi
fi
