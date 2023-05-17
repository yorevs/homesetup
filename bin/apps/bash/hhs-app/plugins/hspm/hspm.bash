#!/usr/bin/env bash
# shellcheck disable=SC2034,SC1090

#  Script: hspm.bash
# Purpose: Manage your development tools using installation/uninstallation recipes.
# Created: Jan 06, 2020
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs#homesetup
# License: Please refer to <https://opensource.org/licenses/MIT>

# Current script version.
VERSION=0.9.0

# Current plugin name
PLUGIN_NAME="hspm"

# Usage message
USAGE="
Usage: $PLUGIN_NAME [option] {install,uninstall,list,recover}

 _   _ ____  ____  __  __ 
| | | / ___||  _ \|  \/  |
| |_| \___ \| |_) | |\/| |
|  _  |___) |  __/| |  | |
|_| |_|____/|_|   |_|  |_|

  HomeSetup package manager

    Options:
      -v  |   --version     : Display current program version.
      -h  |      --help     : Display this help message.
    
    Arguments:
      install   <package>   : Install the package using a matching installation recipe.
      uninstall <package>   : Uninstall the package using a matching uninstallation recipe.
      list [-a]             : List all available installation recipes specified by \${HHS_DEV_TOOLS}. If -a is provided,
                              list even packages without any matching recipe.
      recover [-i,-t,-e]    : Install or list all packages previously installed by hspm. If -i is provided, then hspm
                              will attempt to install all packages, otherwise the list is displayed. If -t is provided
                              hspm will check \${HHS_DEV_TOOLS} instead of previously installed packages. If -e is 
                              provided, then the default editor will open the recovery file.

"

UNSETS=(
  help version cleanup execute cleanup_recipes list_recipes install_recipe uninstall_recipe
  add_breadcrumb del_breadcrumb recover_packages
)

[[ -s "$HHS_DIR/bin/app-commons.bash" ]] && source "$HHS_DIR/bin/app-commons.bash"

# Flag to enlist even the missing recipes
LIST_ALL=

# Flag to install all recovered packages
RECOVER_INSTALL=

# Flag to recover HHS_DEV_TOOLS instead of breadcrumbs
RECOVER_TOOLS=

# Hold all hspm recipes
ALL_RECIPES=()

# shellcheck disable=2206
DEV_TOOLS=(${HHS_DEV_TOOLS[@]})

# Directory containing all hspm recipes
RECIPES_DIR="${PLUGINS_DIR}/hspm/recipes"

# File containing all installed/uninstalled packages
BREADCRUMB_FILE="$HHS_DIR/.hspm"

# @purpose: Add a package to the breadcrumb file
function add_breadcrumb() {
  local package="${1}" os="${HHS_MY_OS_RELEASE}"
  grep -qxF "${os}:${package}" "${BREADCRUMB_FILE}" || echo "${os}:${package}" >>"${BREADCRUMB_FILE}"
}

# @purpose: Remove a package to the breadcrumb file
function del_breadcrumb() {
  local package="${1}" os="${HHS_MY_OS_RELEASE}"
  ised -e "/${os}:${package}/d" "${BREADCRUMB_FILE}"
}

# purpose: Unset all declared functions from the recipes
cleanup_recipes() {

  unset -f 'about' 'depends' 'install' 'uninstall'
}

# shellcheck disable=2155,SC2059,SC2183
# purpose: List all available hspm recipes
list_recipes() {

  local index=0 recipe pad_len=20 pad

  pad=$(printf '%0.1s' "."{1..60})

  for app in ${DEV_TOOLS[*]}; do
    recipe="$RECIPES_DIR/$(uname -s)/${app}.recipe"
    if [[ -n "${recipe}" && -f "${recipe}" ]]; then
      ALL_RECIPES+=("$app")
      index=$((index + 1))
      source "${recipe}"
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

  local recipe recipe_name default_recipe

  package="${1}"
  recipe="${RECIPES_DIR}/$(uname -s)/${package}.recipe"

  if command -v "${package}" >/dev/null; then
    add_breadcrumb "${package}"
    quit 1 "${YELLOW}\"${package}\" is already installed on the system !"
  fi
  
  if [[ -f "${recipe}" ]]; then
    source "${recipe}"
    echo -e "${YELLOW}Installing \"${package}\", please wait ... "
    if install; then
      echo -e "${GREEN}Installation successful => $(command -v "${package}") ${NC}"
      add_breadcrumb "${package}"
    else
      quit 1 "${PLUGIN_NAME}: Failed to install app \"${package}\" !"
    fi
  else
    recipe_name=$(basename "${recipe%\.*}")
    echo -e "${ORANGE}Unable to find recipe \"${recipe_name}\" ! Trying to use a default recipe to install it ...${NC}"
    default_recipe="${RECIPES_DIR}/$(uname -s)/default.recipe"
    source "${default_recipe}"
    if depends && install "${package}"; then
      echo -e "${GREEN}Installation successful => $(command -v "${package}") ${NC}"
      add_breadcrumb "${package}"
    else
      quit 1 "${PLUGIN_NAME}: Failed to install \"${package}\" using the default recipe !"
    fi
  fi
}

# purpose: Uninstall the specified app using the uninstallation recipe
uninstall_recipe() {

  local recipe recipe_name

  package="${1}"
  recipe="$RECIPES_DIR/$(uname -s)/${package}.recipe"

  if ! command -v "${package}" >/dev/null; then
    del_breadcrumb "${package}"
    quit 1 "${YELLOW}\"${package}\" is not installed on the system !"
  fi
  
  if [[ -f "${recipe}" ]]; then
    source "${recipe}"
    echo -e "${YELLOW}Uninstalling ${package}, please wait ... "
    if depends && uninstall; then
      echo -e "${GREEN}Uninstallation successful !${NC}"
      del_breadcrumb "${package}"
    else
      quit 1 "${PLUGIN_NAME}: Failed to uninstall app \"${package}\" !"
    fi
  else
    recipe_name=$(basename "${recipe%\.*}")
    echo -e "${ORANGE}Unable to find recipe \"${recipe_name}\" ! Trying to use a default recipe to uninstall it ...${NC}"
    default_recipe="${RECIPES_DIR}/$(uname -s)/default.recipe"
    source "${default_recipe}"
    if uninstall "${package}"; then
      echo -e "${GREEN}Uninstallation successful !${NC}"
      del_breadcrumb "${package}"
    else
      quit 1 "${PLUGIN_NAME}: Failed to uninstallation \"${package}\" using the default recipe !"
    fi
  fi
}

# @purpose: Install or list all packages previously installed by hspm.
function recover_packages() {

  local index=0 package pad_len=30 pkg pad all_packages=() os=${HHS_MY_OS_RELEASE}

  pad=$(printf '%0.1s' "."{1..80})

  if [[ -n "${RECOVER_INSTALL}" ]]; then
    echo -en "\n${ORANGE}Installing "
  else
    echo -en "\n${ORANGE}Listing "
  fi

  if [[ -z "${RECOVER_TOOLS}" ]]; then
    echo -e "recovered [${HHS_MY_OS}/${HHS_MY_OS_RELEASE}] packages ... "
    while IFS='' read -r package; do
      all_packages+=("${package}")
    done < <(grep "^${os}:" "${BREADCRUMB_FILE}")
  else
    echo -e "development tools ... "
    # shellcheck disable=SC2206
    all_packages+=(${HHS_DEV_TOOLS[@]})
  fi
  echo "${NC}"

  if [[ -n "${RECOVER_INSTALL}" ]]; then
    for pkg in "${all_packages[@]}"; do
      package="${pkg#*:}"
      if ! command -v "${package}" &>/dev/null; then
        printf '%3s - %s' "${index}" "${BLUE}Installing package ${package} ${NC}"
        printf '%*.*s' 0 $((pad_len - ${#package})) "${pad}"
        if install_recipe "${package}" &> /dev/null; then
          echo -e " [   ${GREEN}OK${NC}   ]"
        else
          echo -e " [ ${RED}FAILED${NC} ]"
        fi
        index=$((index + 1))
      fi
    done
  else
    for pkg in "${all_packages[@]}"; do
      package="${pkg#*:}"
      printf '%3s - %s' "${index}" "${BLUE}${package} "
      printf '%*.*s' 0 $((pad_len - ${#package})) "${pad}"
      command -v "${package}" &>/dev/null && echo -e "${GREEN} INSTALLED${NC}" || echo -e "${RED} NOT INSTALLED${NC}"
      index=$((index + 1))
    done
  fi
  [[ $index -gt 0 ]] || echo "${YELLOW}No previously installed packages were found ${NC}"
  echo ''
}

# @purpose: HHS plugin required function
function help() {

  usage 0
}

# @purpose: HHS plugin required function
function version() {
  echo "${PLUGIN_NAME} v${VERSION}"
  exit 0
}

# @purpose: HHS plugin required function
function cleanup() {
  unset "${UNSETS[@]}"
  echo -n ''
}

# @purpose: HHS plugin required function
function execute() {

  [[ -z "$1" || "$1" == "-h" || "$1" == "--help" ]] && usage 0
  [[ "$1" == "-v" || "$1" == "--version" ]] && version

  if [[ ${#DEV_TOOLS[@]} -le 0 ]]; then
    quit 1 "\"$$HHS_DEV_TOOLS\" environment variable is undefined or empty !"
  fi

  touch "${BREADCRUMB_FILE}" || quit 1 "Unable to access hspm file: ${BREADCRUMB_FILE}"

  cmd="$1"
  shift
  args=("$@")

  shopt -s nocasematch
  case "$cmd" in
  # Install the app
  install)
    [[ "${#}" -le 0 ]] && usage 1
    for next_recipe in "${@}"; do
      echo ''
      install_recipe "${next_recipe}"
    done
    echo ''
    ;;
  # Uninstall the app
  uninstall)
    [[ "${#}" -le 0 ]] && usage 1
    for next_recipe in "${@}"; do
      echo ''
      uninstall_recipe "${next_recipe}"
    done
    echo ''
    ;;
  # Recover installed apps
  recover)
    [[ "$1" == "-e" || "$2" == "-e" || "$3" == "-e" ]] && __hhs_open "${BREADCRUMB_FILE}" && exit 0
    [[ "$1" == "-i" || "$2" == "-i" ]] && RECOVER_INSTALL=1
    [[ "$1" == "-t" || "$2" == "-t" ]] && RECOVER_TOOLS=1
    recover_packages
    ;;
  # List available apps
  list)
    if [[ "$1" == "-a" ]]; then
      LIST_ALL=1
    fi
    echo -e "\n${BLUE}Listing ${LIST_ALL//1/all }available hspm recipes ... ${NC}\n"
    list_recipes ""
    echo -e "\nFound (${#ALL_RECIPES[*]}) recipes out of (${#DEV_TOOLS[*]}) development tools"
    ;;
  *)
    usage 1 "Invalid ${PLUGIN_NAME} command: \"${cmd}\" !"
    ;;
  esac
  shopt -u nocasematch

  exit 0
}
