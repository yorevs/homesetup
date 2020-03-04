#!/usr/bin/env bash
# shellcheck disable=SC2034,SC1090

#  Script: hspm.bash
# Purpose: Manage your development tools using installation/uninstallation recipes.
# Created: Jan 06, 2020
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs#homesetup
# License: Please refer to <http://unlicense.org/>

# Current script version.
VERSION=0.9.0

# Current plugin name
PLUGIN_NAME="hspm"

# Usage message
USAGE="
Usage: $PLUGIN_NAME <option> [arguments]

    Manage your development tools using installation/uninstallation recipes.

    Options:
      -v  |   --version                 : Display current program version.
      -h  |      --help                 : Display this help message.
      -i  |   --install   <recipe>      : Install the app using the tool recipe.
      -u  | --uninstall   <recipe>      : Uninstall the app using the tool recipe.
      -l  |      --list   [{-a|--all}]  : List all available tool recipes based on HomeSetup development tools.
    
    Arguments:
      recipe    : The recipe name to be installed/uninstalled.
      all       : If this option is used, displays even tools without recipes.
"

UNSETS=(
  help version cleanup execute cleanup_recipes list_recipes install_recipe uninstall_recipe
)

[[ -s "$HHS_DIR/bin/app-commons.bash" ]] && \. "$HHS_DIR/bin/app-commons.bash"

# Flag to enlist even the missing recipes
LIST_ALL=

# Hold all hspm recipes
ALL_RECIPES=()

# shellcheck disable=2206
DEV_TOOLS=(${HHS_DEV_TOOLS[@]})

# Directory containing all hspm recipes
RECIPES_DIR="${PLUGINS_DIR}/hspm/recipes"

# purpose: Unset all declared functions from the recipes
cleanup_recipes() {

  unset -f 'about' 'depends' 'install' 'uninstall'
}

# purpose: shellcheck disable=2155,SC2059,SC2183
list_recipes() {

  local index=0 recipe pad_len=20
  local pad=$(printf '%0.1s' "."{1..60})

  for app in ${DEV_TOOLS[*]}; do
    recipe="$RECIPES_DIR/$(uname -s)/${app}.recipe"
    if [[ -n "${recipe}" && -f "${recipe}" ]]; then
      ALL_RECIPES+=("$app")
      index=$((index + 1))
      \. "${recipe}"
      if test -z "$1"; then
        printf '%3s - %s' "${index}" "${BLUE}${app} "
        printf '%*.*s' 0 $((pad_len - ${#app})) "${pad}"
        echo -e "${GREEN} => ${WHITE}$(about) ${NC}"
      fi
      cleanup_recipes
      [[ "$1" == "$app" ]] && return 0
    elif [[ "${LIST_ALL}" == "1" ]]; then
      index=$((index + 1))
      printf '%3s - %s' "${index}" "${ORANGE}${app} "
      printf '%*.*s' 0 $((pad_len - ${#app})) "${pad}"
      echo -e "${GREEN} => ${RED}[Recipe not found] ${NC}"
    fi
  done

  [[ -n "$1" ]] && return 1

  return 0
}

# purpose: Install the specified app using the installation recipe
install_recipe() {

  local recipe recipe_name

  recipe="${RECIPES_DIR}/$(uname -s)/$1.recipe"

  if [[ -f "${recipe}" ]]; then
    \. "${recipe}"
    if command -v "$1" > /dev/null; then
      echo -e "${YELLOW}\"$1\" is already installed on the system !${NC}" && return 1
    fi
    echo -e "${YELLOW}Installing \"$1\", please wait ... "
    if install; then
      echo -e "${GREEN}Installation successful !${NC}"
    else
      quit 1 "${PLUGIN_NAME}: Failed to install app \"$1\" !"
    fi
  else
    recipe_name=$(basename "${recipe%\.*}")
    echo -e "${ORANGE}Unable to find recipe \"${recipe_name}\" ! Trying to use brew to install it ...${NC}"
    if ! brew install "${recipe_name}"; then
      quit 1 "Unable to install \"${recipe_name}\" !"
    fi
  fi
}

# purpose: Uninstall the specified app using the uninstallation recipe
uninstall_recipe() {

  local recipe recipe_name

  recipe="$RECIPES_DIR/$(uname -s)/$1.recipe"

  if [[ -f "${recipe}" ]]; then
    \. "${recipe}"
    if ! command -v "$1" > /dev/null; then
      echo -e "${YELLOW}\"$1\" is not installed on the system !${NC}" && return 1
    fi
    echo -e "${YELLOW}Uninstalling $1, please wait ... "
    if uninstall && brew deps asciinema | xargs brew remove --ignore-dependencies; then
      echo -e "${GREEN}Uninstallation successful !${NC}"
    else
      quit 1 "${PLUGIN_NAME}: Failed to uninstall app \"$1\" !"
    fi
  else
    recipe_name=$(basename "${recipe%\.*}")
    echo -e "${ORANGE}Unable to find recipe \"${recipe_name}\" ! Trying to use brew to uninstall it ...${NC}"
    if ! brew uninstall "${recipe_name}"; then
      quit 1 "Unable to uninstall \"${recipe_name}\" !"
    fi
  fi
}

# @purpose: HHS plugin required function
function help() {

  usage 0
}

# @purpose: HHS plugin required function
function version() {
  echo "HomeSetup ${PLUGIN_NAME} plugin v${VERSION}"
  exit 0
}

# @purpose: HHS plugin required function
function cleanup() {
  unset "${UNSETS[@]}"
}

# @purpose: HHS plugin required function
function execute() {

  [[ -z "$1" ]] && usage 1
  if [[ ${#DEV_TOOLS[*]} -le 0 ]]; then
    quit 1 "\"$$HHS_DEV_TOOLS\" environment variable is undefined or empty !"
  fi

  cmd="$1"
  shift
  args=("$@")

  shopt -s nocasematch
  case "$cmd" in
    # Install the app
    -i | --install)
      [[ "$#" -le 0 ]] && usage 1
      for next_recipe in "${@}"; do
        echo ''
        install_recipe "$next_recipe"
      done
      echo ''
      ;;
    # Uninstall the app
    -u | --uninstall)
      [[ "$#" -le 0 ]] && usage 1
      for next_recipe in "${@}"; do
        echo ''
        uninstall_recipe "$next_recipe"
      done
      echo ''
      ;;
    # List available apps
    -l | --list)
      if [[ "$1" == "-a" || "$1" == "--all" ]]; then
        LIST_ALL=1
      fi
      echo -e "\n${YELLOW}Listing ${LIST_ALL//1/all }available hspm recipes ... ${NC}\n"
      list_recipes ""
      echo -e "\nFound (${#ALL_RECIPES[*]}) recipes out of (${#DEV_TOOLS[*]}) development tools"
      ;;
    *)
      usage 1 "Invalid ${PLUGIN_NAME} command: \"$cmd\" !"
      ;;
  esac
  shopt -u nocasematch

  exit 0
}
