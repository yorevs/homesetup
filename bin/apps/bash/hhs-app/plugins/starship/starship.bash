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
# Copyright (c) 2024, HomeSetup team

# Current plugin name
PLUGIN_NAME="starship"

UNSETS=(
  help version cleanup execute add_hhs_preset
)

# Current hhs starship version
VERSION="1.0.1"

# All Starship presets
STARSHIP_PRESETS=(
  'no-nerd-font'
  'bracketed-segments'
  'plain-text-symbols'
  'no-runtime-versions'
  'no-empty-icons'
  'pure-preset'
  'tokyo-night'
  'pastel-powerline'
  'nerd-font-symbols'
)

# Usage message
USAGE="usage: ${APP_NAME} ${PLUGIN_NAME} [command]

 ____  _                 _     _
/ ___|| |_ __ _ _ __ ___| |__ (_)_ __
\___ \| __/ _\` | '__/ __| '_ \| | '_ \\
 ___) | || (_| | |  \__ \ | | | | |_) |
|____/ \__\__,_|_|  |___/_| |_|_| .__/
                                |_|

  HomeSetup starship integration setup.
  Visit the Starship website at: https://starship.rs/

    commands:
      edit                  : Edit your starship configuration file (default command).
      restore               : Restore HomeSetup defaults.
      preset <preset_name>  : Configure your starship to a preset.

    presets:
      no-runtime-versions   : This preset hides the version of language runtimes. If you work in containers or
                              virtualized environments, this one is for you!
      bracketed-segments    : This preset changes the format of all the built-in modules to show their segment in
                              brackets instead of using the default Starship wording ('via', 'on', etc.).
      plain-text-symbols    : This preset changes the symbols for each module into plain text. Great if you don't have
                              access to Unicode.
      no-empty-icons        : This preset does not show icons if the toolset is not found.
      tokyo-night           : This preset is inspired by tokyo-night-vscode-theme.
      no-nerd-font          : This preset changes the symbols for several modules so that no Nerd Font symbols are used
                              anywhere in the prompt.
      pastel-powerline      : This preset is inspired by M365Princess (opens new window). It also shows how path
                              substitution works in starship.
      pure-preset           : This preset emulates the look and behavior of Pure.
      nerd-font-symbols     : This preset changes the symbols for each module to use Nerd Font symbols.

    note:
      - If no command is passed, the default editor will open the starship configuration file.
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
  unset -f "${UNSETS[@]}"
  echo -n ''
}

# @purpose: Opens the Starship configuration page
function configs() {
  local page_url="https://starship.rs/config/"

  echo -e "${BLUE}${GLOBE_ICN} Opening Starship config page from: ${page_url}${ELLIPSIS_ICN}${NC}"
  __hhs_open "${page_url}" && sleep 2 && quit 0

  quit 1 "Failed to open url: \"${page_url}\" !"
}


# @purpose: Add HomeSetup presets.
function add_hhs_presets() {

  local hhs_presets

  IFS=$'\n' read -r -d '' -a hhs_presets < <(find "${HHS_STARSHIP_PRESETS_DIR}" -type f -name "hhs-*.toml" -exec basename {} \;)
  IFS="${OLDIFS}"
  STARSHIP_PRESETS+=("${hhs_presets[@]}")
}

# @purpose: HHS plugin required function
function execute() {

  local preset_val mselect_file title preset

  if __hhs_has starship; then

    [[ $# -eq 0 ]] || { list_contains "$@" "edit" && __hhs_open "${STARSHIP_CONFIG}" && quit 0; }
    [[ $# -eq 0 ]] || { list_contains "$@" "configs" && configs; }
    list_contains "${*}" "help" && usage 0
    list_contains "${*}" "version" && version

    if list_contains "${*}" "restore"; then
      echo -e "${GREEN}Restoring HomeSetup starship configuration...${NC}"
      if \cp "${HHS_STARSHIP_PRESETS_DIR}/hhs-starship.toml" "${STARSHIP_CONFIG}" &> /dev/null; then
        echo -e "${GREEN}Your starship prompt changed to HomeSetup defaults!${NC}" && quit 0
      else
        echo -e "${RED}Unable to restore HomeSetup starship preset${NC}" && quit 1
      fi
    elif list_contains "${*}" "preset"; then
      add_hhs_presets
      preset_val="${2}"
      if [[ -z ${preset_val} ]]; then
        mselect_file=$(mktemp)
        title="Please select one Starship preset (${#STARSHIP_PRESETS[@]})"
        if __hhs_mselect "${mselect_file}" "${title}${NC}" "${STARSHIP_PRESETS[@]}"; then
          preset_val=$(grep . "${mselect_file}")
        fi
      fi
      if [[ -n "${preset_val}" ]] && ! list_contains "${STARSHIP_PRESETS[*]}" "${preset_val}"; then
        echo -e "${YELLOW}\nPlease choose one valid Starship preset: "
        for preset in "${STARSHIP_PRESETS[@]}"; do echo "  |-${preset}"; done
        quit 1
      fi
      if [[ -n "${preset_val}" ]]; then
        echo -e "${GREEN}Setting starship preset \"${preset_val}\"...${NC}"
        if [[ "${preset_val}" == *'hhs-'* ]] && \cp "${HHS_STARSHIP_PRESETS_DIR}/${preset_val}" "${STARSHIP_CONFIG}"; then
          echo -e "${GREEN}Your starship prompt changed to HomeSetup preset: ${preset_val} !${NC}" && quit 0
        elif bash -c "starship preset \"${preset_val}\" -o ${STARSHIP_CONFIG}" &> /dev/null; then
          echo -e "${GREEN}Your starship prompt changed to preset: ${preset_val} !${NC}" && quit 0
        else
          echo -e "${RED}Unable to set starship preset: ${preset_val} ${NC}" && quit 1
        fi
      fi
    else
      echo -e "${RED}Command not found: ${*} ${NC}" && quit 1
    fi

  else
    echo -e "${ORANGE}Starship is not installed. You can install it by:"
    echo -e "$ curl -sS https://starship.rs/install.sh${NC}"
  fi
}
