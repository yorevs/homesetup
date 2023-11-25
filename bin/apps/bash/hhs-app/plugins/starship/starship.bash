#!/usr/bin/env bash
# shellcheck disable=2181,2199,2076,2034

#  Script: built-ins.bash
# Purpose: Contains all starship manipulation functions
# Created: Wed 22, 2023
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: homesetup@gmail.com
#    Site: https://github.com/yorevs#homesetup
# License: Please refer to <https://opensource.org/licenses/MIT>
#
# Copyright (c) 2023, HomeSetup team

# Current hhs starship version
VERSION="1.0.1"

# All Starship presets
STARSHIP_PRESETS=(
  'no-nerd-font'
  'bracketed-segments'
  'plain-text-symbols'
  'no-runtime-versions'
  'no-empty-icons'
  'pure-prompt'
)

# Usage message
USAGE="usage: ${APP_NAME} starship <command>

 ____  _                 _     _
/ ___|| |_ __ _ _ __ ___| |__ (_)_ __
\___ \| __/ _\` | '__/ __| '_ \| | '_ \\
 ___) | || (_| | |  \__ \ | | | | |_) |
|____/ \__\__,_|_|  |___/_| |_|_| .__/
                                |_|

  HomeSetup starship integration setup.
  Visit the Starship website at: https://starship.rs/

    commands:
      edit                  : Edit your starship configuration file.
      restore               : Restore HomeSetup defaults.
      preset <preset_name>  : Configure your starship to a preset.

    presets:
      no-nerd-font          : This preset changes the symbols for several modules so that no Nerd Font symbols are used
                              anywhere in the prompt.
      bracketed-segments    : This preset changes the format of all the built-in modules to show their segment in
                              brackets instead of using the default Starship wording ('via', 'on', etc.).
      plain-text-symbols    : This preset changes the symbols for each module into plain text. Great if you don't have
                              access to Unicode.
      no-runtime-versions   : This preset hides the version of language runtimes. If you work in containers or
                              virtualized environments, this one is for you!
      no-empty-icons        : This preset does not show icons if the toolset is not found.
      pure-prompt           : This preset emulates the look and behavior of Pure.
"

[[ -s "${HHS_DIR}/bin/app-commons.bash" ]] && source "${HHS_DIR}/bin/app-commons.bash"

# @purpose: HHS plugin required function
function help() {
  usage 0
}

# @purpose: HHS plugin required function
function version() {
  echo "HomeSetup ${PLUGIN_NAME} plugin v${VERSION}"
  quit 0
}

# @purpose: HHS plugin required function
function cleanup() {
  unset "${UNSETS[@]}"
  echo -n ''
}

# @purpose: HHS plugin required function
function execute() {
  if __hhs_has starship; then
    [[ $# -eq 0 || $1 == "edit" ]] && __hhs_open "${STARSHIP_CONFIG}" && quit 0

    if [[ $1 == "restore" ]]; then
      if \cp "${HHS_HOME}/misc/starship.toml" "${HHS_DIR}/starship.toml" &>/dev/null; then
        echo -e "${GREEN}Your starship prompt changed to HomeSetup defaults${NC}" && quit 0
      fi
    fi

    if [[ $1 == "preset" ]]; then
      preset_val="${2}"
      if [[ -z ${preset_val} ]]; then
        mselect_file=$(mktemp)
        title="Please select one Starship preset (${#STARSHIP_PRESETS[@]})"
        if __hhs_mselect "${mselect_file}" "${title}${NC}" "${STARSHIP_PRESETS[@]}"; then
          preset_val=$(grep . "${mselect_file}")
        fi
      else
        echo -e "${YELLOW}\nPlease choose one valid Starship preset: "
        for f in "${STARSHIP_PRESETS[@]}"; do echo "  |-$f"; done
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
