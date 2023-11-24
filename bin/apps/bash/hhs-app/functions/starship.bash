#!/usr/bin/env bash
# shellcheck disable=2181,2199,2076

#  Script: built-ins.bash
# Purpose: Contains all starship manipulation functions
# Created: Wed 22, 2023
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: homesetup@gmail.com
#    Site: https://github.com/yorevs#homesetup
# License: Please refer to <https://opensource.org/licenses/MIT>
#
# Copyright (c) 2023, HomeSetup team

# @purpose: Configure Starship prompt.
function starship() {

  local version starship_presets usage mselect_file title preset_val

  # Current hhs starship version
  version="1.0.1"

  starship_presets=(
    'no-nerd-font'
    'bracketed-segments'
    'plain-text-symbols'
    'no-runtime-versions'
    'no-empty-icons'
    'pure-prompt'
  )

  usage="Usage: ${APP_NAME} starship <command>

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
    [[ $# -eq 0 ]] && echo "${usage}" && quit 1
    [[ $1 == "help" ]] && echo "${usage}" && quit 0
    [[ $1 == "version" ]] && echo "${version}" && quit 0
    [[ $1 == "edit" ]] && __hhs_open "${STARSHIP_CONFIG}" && quit 0

    if [[ $1 == "restore" ]]; then
      if \cp "${HHS_HOME}/misc/starship.toml" "${HHS_DIR}/starship.toml" &>/dev/null; then
        echo -e "${GREEN}Your starship prompt changed to HomeSetup defaults${NC}" && quit 0
      fi
    fi

    if [[ $1 == "preset" ]]; then
      preset_val="${2}"
      if [[ -z ${preset_val} ]]; then
        mselect_file=$(mktemp)
        title="Please select one Starship preset (${#starship_presets[@]})"
        if __hhs_mselect "${mselect_file}" "${title}${NC}" "${starship_presets[@]}"; then
          preset_val=$(grep . "${mselect_file}")
        fi
      else
        echo -e "${YELLOW}\nPlease choose one valid Starship preset: "
        for f in "${starship_presets[@]}"; do echo "  |-$f"; done
        quit 1
      fi
      if [[ -n "${preset_val}" ]]; then
        echo -e "${GREEN}Setting preset: ${preset_val}${NC}"
        if bash -c "starship preset ${preset_val} -o ${STARSHIP_CONFIG}" &>/dev/null; then
          echo -e "${GREEN}Your starship prompt changed to preset: ${preset_val}${NC}" && quit 0
        else
          echo -e "${GREEN}FAILED${NC}" && quit 1
        fi
      fi
    fi

  else
    echo -e "${ORANGE}Starship is not installed. You can install it by:"
    echo -e "$ curl -sS https://starship.rs/install.sh${NC}"
  fi
}
