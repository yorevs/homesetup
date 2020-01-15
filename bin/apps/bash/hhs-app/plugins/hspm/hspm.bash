#  Script: hspm.bash
# Purpose: Manage your development tools using installation/uninstallation recipes.
# Created: Jan 06, 2020
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs#homesetup
# License: Please refer to <http://unlicense.org/>

# shellcheck disable=SC2034
# Current script version.
VERSION=0.9.0

# Current plugin name
PLUGIN_NAME="hspm"

# shellcheck disable=SC2034
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

UNSETS=('help' 'version' 'cleanup' 'execute' 'cleanup_recipes' 'list_recipes' 'install_recipe' 'uninstall_recipe')

# shellcheck disable=SC1090
[ -s "$HHS_DIR/bin/app-commons.bash" ] && \. "$HHS_DIR/bin/app-commons.bash"

# Flag to enlist even the missing recipes
LIST_ALL=

# Hold all hspm recipes
ALL_RECIPES=()

# shellcheck disable=2206
DEV_TOOLS=(${HHS_DEV_TOOLS[@]})

# Directiry containing all hspm recipes
RECIPES_DIR="${HHS_PLUGINS_DIR}/hspm/recipes"

# Unset all declared functions from the recipes
cleanup_recipes() {

  unset -f 'about' 'depends' 'install' 'uninstall'
}

# shellcheck disable=2155,SC2059,SC2183,SC1090
list_recipes() {

  local index=0 recipe pad_len=20
  local pad=$(printf '%0.1s' "."{1..60})
  for app in ${DEV_TOOLS[*]}; do
    recipe="$RECIPES_DIR/$(uname -s)/${app}.recipe"
    if [ -n "$recipe" ] && [ -f "$recipe" ]; then
      ALL_RECIPES+=("$app")
      index=$((index + 1))
      \. "$recipe"
      if test -z "$1"; then
        printf '%3s - %s' "${index}" "${BLUE}${app} "
        printf '%*.*s' 0 $((pad_len - ${#app})) "$pad"
        echo -e "${GREEN} => ${WHITE}$(about) ${NC}"
      fi
      cleanup_recipes
      [ "$1" = "$app" ] && return 0
    elif [ "${LIST_ALL}" = "1" ]; then
      index=$((index + 1))
      printf '%3s - %s' "${index}" "${ORANGE}${app} "
      printf '%*.*s' 0 $((pad_len - ${#app})) "$pad"
      echo -e "${GREEN} => ${RED}[Recipe not found] ${NC}"
    fi
  done

  [ -n "$1" ] && return 1 || return 0
}

# shellcheck disable=SC1090
# Install the specified app using the installation recipe
install_recipe() {

  local recipe

  recipe="${RECIPES_DIR}/$(uname -s)/$1.recipe"

  if [ -f "$recipe" ]; then
    echo ''
    \. "$recipe"
    if command -v "$1" > /dev/null; then
      quit 1 "${YELLOW}\"$1\" is already installed on the system !${NC}"
    fi
    echo -e "${YELLOW}Installing \"$1\", please wait ... ${NC}"
    if install; then
      echo -e "${GREEN}Installation successful !${NC}"
    else
      quit 2 "Failed to install app \"$1\" !"
    fi
  else
    quit 1 "Unable to find recipe \"$recipe\" !"
  fi
}

# shellcheck disable=SC1090
# Uninstall the specified app using the uninstallation recipe
uninstall_recipe() {

  recipe="$RECIPES_DIR/$(uname -s)/$1.recipe"
  if [ -f "$recipe" ]; then
    echo ''
    \. "$recipe"
    if ! command -v "$1" > /dev/null; then
      quit 2 "${YELLOW}\"$1\" is not installed on the system !${NC}"
    fi
    echo -e "${YELLOW}Uninstalling $1, please wait ... ${NC}"
    if uninstall; then
      echo -e "${GREEN}Uninstallation successful !${NC}"
    else
      quit 2 "Failed to uninstall app \"$1\" !"
    fi
  else
    quit 2 "Unable to find recipe \"$recipe\" !"
  fi
}

function help() {
  usage 0
}

function version() {
  echo "HomeSetup ${PLUGIN_NAME} plugin v${VERSION}"
}

function cleanup() {
  unset "${UNSETS[@]}"
  exit $?
}

function execute() {
  [ -z "$1" ] && usage 1
  if [ ${#DEV_TOOLS[*]} -le 0 ]; then
    quit 1 "\"$$HHS_DEV_TOOLS\" environment variable is undefined or empty !"
  fi

  cmd="$1"
  shift
  args=("$@")

  shopt -s nocasematch
  case "$cmd" in
    # Install the app
    -i | --install)
      [ "$#" -le 0 ] && usage 1
      if list_recipes "$1"; then
        install_recipe "$1"
      else
        quit 1 "Unable to find recipe for \"$1\" !"
      fi
      ;;
    # Uninstall the app
    -u | --uninstall)
      [ "$#" -le 0 ] && usage 1
      if list_recipes "$1"; then
        uninstall_recipe "$1"
      else
        quit 1 "Unable to find recipe for \"$1\" !"
      fi
      ;;
    # List available apps
    -l | --list)
      if [ "$1" = "-a" ] || [ "$1" = "--all" ]; then
        LIST_ALL=1
      fi
      echo -e "\n${YELLOW}Listing ${LIST_ALL//1/all }available hspm recipes ... ${NC}\n"
      list_recipes
      echo -e "\nFound (${#ALL_RECIPES[*]}) recipes out of (${#DEV_TOOLS[*]}) development tools"
      ;;
    *)
      usage 1 "Invalid ${PLUGIN_NAME} command: \"$cmd\" !"
      ;;
  esac
  shopt -u nocasematch
}
