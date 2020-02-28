# shellcheck disable=SC1090

# inspiRED by: https://github.com/Bash-it/bash-it/blob/master/completion/available/brew.completion.bash

BREW_PREFIX=$(brew --prefix)
if [[ -f "$BREW_PREFIX"/etc/bash_completion.d/brew ]]; then
  \. "$BREW_PREFIX"/etc/bash_completion.d/brew
elif [[ -f "$BREW_PREFIX"/Library/Contributions/brew_bash_completion.sh ]]; then
  \. "$BREW_PREFIX"/Library/Contributions/brew_bash_completion.sh
elif [[ -f "$BREW_PREFIX"/completions/bash/brew ]]; then
  # For the git-clone based installation, see here for more info:
  # https://github.com/Bash-it/bash-it/issues/1458
  # https://docs.brew.sh/Shell-Completion
  \. "$BREW_PREFIX"/completions/bash/brew
fi
