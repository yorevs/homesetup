#!/usr/bin/env bash
# shellcheck disable=2181,2199,2076

#  Script: built-ins.bash
# Purpose: Contains all HHS initialization functions
# Created: Jan 06, 2020
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: homesetup@gmail.com
#    Site: https://github.com/yorevs#homesetup
# License: Please refer to <https://opensource.org/licenses/MIT>
#
# Copyright (c) 2023, HomeSetup team

# @purpose: Configure Starship prompt.
function starship() {

  # Current hhs starship version
  VERSION="1.0.0"

  STARSHIP_PRESETS=(
    'no-nerd-font'
    'bracketed-segments'
    'plain-text-symbols'
    'no-runtime-versions'
    'no-empty-icons'
    'pure-prompt'
  )

  USAGE="Usage: ${APP_NAME} starship <command>

      Commands:
        edit                  : Edit your starship configuration file.
        preset <preset_name>  : Configure your starship to a preset.
        restore               : Restore HomeSetup defaults.

      Presets:
        no-nerd-font          : This preset restricts the use of symbols to those from emoji and powerline sets.
                                This means that even without a Nerd Font installed, you should be able to view all
                                module symbols.
  "

  if __hhs_has starship; then
    [[ $# -eq 0 ]] && echo "${USAGE}" && quit 1
    [[ $1 == "help" ]] && echo "${USAGE}" && quit 0
    [[ $1 == "version" ]] && echo "${VERSION}" && quit 0
    [[ $1 == "edit" ]] && __hhs_open "${STARSHIP_CONFIG}" && quit 0
    [[ $1 == "restore" ]] && \cp "${HHS_HOME}/misc/starship.toml" "${HHS_DIR}/starship.toml" &>/dev/null && quit 0

    if [[ $1 == "preset" ]]; then
      if [[ "${STARSHIP_PRESETS[@]}" =~ $2 ]]; then
        echo -e "${GREEN}Setting preset: ${2}${NC}"
        bash -c "starship preset ${2} -o ${STARSHIP_CONFIG}" &>/dev/null
        quit 1
      else
        echo -e "${YELLOW}\nPlease choose one valid Starship preset: "
        for f in "${STARSHIP_PRESETS[@]}"; do echo "  |-$f"; done
        quit 1
      fi
    fi

  else
    echo -e "${ORANGE}Starship is not installed. You can install it by:"
    echo -e "$ curl -sS https://starship.rs/install.sh${NC}"
  fi
}
