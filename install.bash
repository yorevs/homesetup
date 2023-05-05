#!/usr/bin/env bash
# shellcheck disable=SC1117,SC1090

#  Script: install.bash
# Purpose: Install and configure HomeSetup
# Created: Aug 26, 2018
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <https://opensource.org/licenses/MIT>

{

  # This script name
  APP_NAME="${0##*/}"

  # Help message to be displayed by the script
  USAGE="
Usage: $APP_NAME [OPTIONS] <args>

  -i | --interactive        : Install all scripts into the user HomeSetup directory interactively.
  -q | --quiet              : Do not prompt for questions, use all defaults.
"

  # HomeSetup GitHub repository URL
  REPO_URL='https://github.com/yorevs/homesetup.git'

  # Define the user HOME
  HOME=${HOME:-~}

  # Option to allow install to be interactive or not
  OPT='all'

  # Shell type.
  SHELL_TYPE="${SHELL##*/}"

  # .dotfiles we will handle.
  ALL_DOTFILES=()

  # Supported shell types. For now, only bash is supported
  SUPP_SHELL_TYPES=('bash')

  # Timestamp used to backup files
  TIMESTAMP=$(\date "+%s%S")

  # User's operating system
  MY_OS=$(uname -s)

  # HomeSetup required tools
  REQUIRED_TOOLS=('git' 'curl')

  # OS Application manager
  OS_APP_MAN=

  # Darwin required tools
  if [[ "${MY_OS}" == "Darwin" ]]; then
    MY_OS_RELEASE=$(sw_vers -productName)
    REQUIRED_TOOLS+=('brew' 'xcode-select' 'python3' 'pip3')
  elif [[ "${MY_OS}" == "Linux" ]]; then
    MY_OS_RELEASE="$(grep '^ID=' '/etc/os-release' 2>/dev/null)"
    MY_OS_RELEASE="${MY_OS_RELEASE#*=}"
    REQUIRED_TOOLS+=('python3' 'pip3')
  fi

  # Missing HomeSetup required tools
  MISSING_TOOLS=()

  # ICONS
  STAR_ICN="\xef\x80\x85"
  NOTE_ICN="\xef\x84\x98"
  HAND_PEACE_ICN="\xef\x89\x9b"

  # VT-100 Terminal colors
  NC=${NC:-'\033[0;0;0m'}
  GREEN=${GREEN:-'\033[0;32m'}
  YELLOW=${YELLOW:-'\033[0;93m'}
  RED=${RED:-'\033[0;31m'}
  BLUE=${BLUE:-'\033[0;34m'}
  WHITE=${WHITE:-'\033[0;97m'}

  # Functions to be unset after quit
  UNSETS=(
    quit usage has check_current_shell check_inst_method install_dotfiles clone_repository check_required_tools
    activate_dotfiles compatibility_check install_missing_tools configure_python install_hhslib install_brew 
    copy_file create_directory
  )

  # Purpose: Quit the program and exhibits an exit message if specified
  # @param $1 [Req] : The exit return code. 0 = SUCCESS, 1 = FAILURE, * = ERROR ${RED}.
  # @param $2 [Opt] : The exit message to be displayed.
  quit() {

    # Unset all declared functions
    unset -f "${UNSETS[*]}"

    test "$1" != '0' -a "$1" != '1' && echo -e "${RED}" 1>&2
    test -n "$2" -a "$2" != "" && echo -e "${2}" 1>&2
    test "$1" != '0' -a "$1" != '1' && echo -e "${NC}" 1>&2
    echo ''
    exit "$1"
  }

  # Usage message
  usage() {
    quit 2 "$USAGE"
  }

  # @function: Check if a command exists
  # @param $1 [Req] : The command to check
  has() {
    type "$1" >/dev/null 2>&1
  }
  
  # @function: Create a directory and check for write permissions
  # @Param $1 [Req] : The directory name
  create_directory() {
      dir="$1"
      if [[ ! -d "${dir}" && ! -L "${dir}" ]]; then
      echo -en "\nCreating ${dir} directory: "
      mkdir -p "${dir}" || quit 2 "Unable to create directory ${dir}"
      echo -e " [   ${GREEN}OK${NC}   ]"
    else
      # Trying to write at the created directory to validate write permissions.
      \touch "${dir}/tmpfile" &>/dev/null || quit 2 "Not enough permissions to write to \"${dir}\" directory!"
      \rm -f "${dir:?}/tmpfile" &>/dev/null
    fi
  }
  
  # @function: Copy file from source into proper destination
  # @Param $1 [Req] : The source file.
  # @Param $2 [Req] : The destination file.
  copy_file() {
    
    local src_file dest_file
    
    src_file="${1}"
    dest_file="${2}"
    
    echo ''
    if [[ -f "${dest_file}" ]]; then
      echo -e "Skipping: ${YELLOW}${dest_file} file was not copied because it already exists. ${NC}"
    else
      echo -en "Copying: ${BLUE} ${src_file} -> ${dest_file} ${NC} ..."
      \cp "${src_file}" "${dest_file}"
      [[ -f "${dest_file}" ]] && echo -e "${WHITE} [   ${GREEN}OK${NC}   ]"
      [[ -f "${dest_file}" ]] || echo -e "${WHITE} [ ${RED}FAILED${NC} ]"
    fi
  }

  # shellcheck disable=SC2199,SC2076
  # Check current active User shell type
  check_current_shell() {

    if [[ ! " ${SUPP_SHELL_TYPES[@]} " =~ " ${SHELL##*/} " ]]; then
      quit 2 "Your current shell type is not supported: \"${SHELL}\""
    fi
  }

  # shellcheck disable=SC1091
  # Check which installation method should be used
  check_inst_method() {

    # Define the HomeSetup location
    HHS_HOME="${HHS_HOME:-${HOME}/HomeSetup}"
    
    # Define the HomeSetup .hhs location
    HHS_DIR="${HHS_DIR:-${HOME}/.hhs}"

    # Dotfiles source location
    DOTFILES_DIR="${HHS_HOME}/dotfiles/${SHELL_TYPE}"

    # HHS applications location
    APPS_DIR="${HHS_HOME}/bin/apps"

    # Auto-completions location
    COMPLETIONS_DIR="${HHS_HOME}/bin/completions"

    # Enable install script to use colors
    [[ -s "${DOTFILES_DIR}/${SHELL_TYPE}_colors.${SHELL_TYPE}" ]] \
      && \. "${DOTFILES_DIR}/${SHELL_TYPE}_colors.${SHELL_TYPE}"
    [[ -s "${HHS_HOME}/.VERSION" ]] \
      && echo -e "\n${GREEN}HomeSetup© ${YELLOW}v$(grep . "${HHS_HOME}/.VERSION") ${GREEN}setup ${NC}"

    # Check if the user passed the help or version parameters
    [[ "$1" == '-h' || "$1" == '--help' ]] && quit 0 "$USAGE"
    [[ "$1" == '-v' || "$1" == '--version' ]] && version

    # Loop through the command line options
    # Short opts: -w, Long opts: --Word
    while test -n "$1"; do
      case "$1" in
      -i | --interactively)
        OPT=''
        ;;
      -q | --quiet)
        OPT='all'
        ANS='Y'
        QUIET=1
        ;;
      *)
        quit 2 "Invalid option: \"$1\""
        ;;
      esac
      shift
    done

    # Create HomeSetup home directory
    create_directory "${HHS_HOME}"

    # Create HomeSetup .hhs directory
    create_directory "${HHS_DIR}"
    
    # Define and create the HomeSetup backup directory
    HHS_BACKUP_DIR="${HHS_DIR}/backup"
    create_directory "${HHS_BACKUP_DIR}"

    # Define and create the HomeSetup bin directory
    BIN_DIR="${HHS_DIR}/bin"
    create_directory "${BIN_DIR}"

    # Define the fonts directory
    if [[ "Darwin" == "${MY_OS}" ]]; then
      FONTS_DIR="${HOME}/Library/Fonts"
    elif [[ "Linux" == "${MY_OS}" ]]; then
      FONTS_DIR="${HOME}/.local/share/fonts"
    fi
    
    # Create fonts directory
    create_directory "${FONTS_DIR}"

    # Check the installation method
    if [[ -n "${HHS_VERSION}" && -f "${HHS_HOME}/.VERSION" ]]; then
      METHOD='repair'
    elif [[ -z "${HHS_VERSION}" && -f "${HHS_HOME}/.VERSION" ]]; then
      METHOD='local'
    else
      METHOD='remote'
    fi

    # Select the installation method and call the underlying functions
    case "$METHOD" in
    remote)
      check_required_tools
      clone_repository
      install_dotfiles
      configure_python
      compatibility_check
      activate_dotfiles
      ;;
    local)
      check_required_tools
      install_dotfiles
      configure_python
      compatibility_check
      activate_dotfiles
      ;;
    repair)
      install_dotfiles
      activate_dotfiles
      ;;
    *)
      quit 2 "Installation method is not valid: ${METHOD}"
      ;;
    esac
  }

  # Check HomeSetup required tools
  check_required_tools() {

    local os_type pad pad_len

    has sudo &>/dev/null && SUDO='sudo'

    if has 'apt-get' || has 'apt'; then
      os_type='Debian'
      OS_APP_MAN=apt
    elif has 'yum'; then
      os_type='RedHat'
      OS_APP_MAN=yum
    elif has 'dnf'; then
      os_type='RedHat'
      OS_APP_MAN=yum
    elif has 'brew'; then
      os_type='macOS'
      OS_APP_MAN=brew
    else
      quit 1 "Unable to find package manager for $(uname -s)"
    fi
    
    if [[ 'macOS' == "${os_type}" ]]; then
      install_brew
    fi

    echo ''
    echo "Using ${OS_APP_MAN} application manager"

    echo ''
    echo -e "${WHITE}Checking required tools [${os_type}] ...${NC}"
    echo ''

    pad=$(printf '%0.1s' "."{1..60})
    pad_len=20

    for tool_name in "${REQUIRED_TOOLS[@]}"; do
      echo -en "${WHITE}Checking: ${YELLOW}${tool_name}${NC} ..."
      printf '%*.*s' 0 $((pad_len - ${#tool_name})) "${pad}"
      if has "${tool_name}"; then
        echo -e " [   ${GREEN}INSTALLED${NC}   ] "
      else
        echo -e " [ ${RED}NOT INSTALLED${NC} ] "
        MISSING_TOOLS+=("${tool_name}")
      fi
    done

    install_missing_tools "${os_type}"
  }

  # Install brew for Darwin based system
  install_brew() {
    echo -n 'Darwin detected. Attempting to install HomeBrew... '
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" &>/dev/null ||
      quit 2 "# FAILED! Unable to install HomeBrew !"
    echo -e "${GREEN}SUCCESS${NC} !"
  }

  # shellcheck disable=SC2086
  # Install missing tools
  install_missing_tools() {

    local os_type="$1"

    if [[ ${#MISSING_TOOLS[@]} -ne 0 ]]; then
      [[ -n "${SUDO}" ]] && echo -e "\nUsing 'sudo' to install apps. You may be prompted for the password."
      echo ''
      echo -en "${WHITE}Installing required packages [${MISSING_TOOLS[*]}] (${os_type}) with ${OS_APP_MAN} ... "
      if ${SUDO} ${OS_APP_MAN} install "${MISSING_TOOLS[@]}" &>/dev/null; then
         echo -e "[   ${GREEN}OK${NC}   ]"
      else
        quit 2 "Failed to install: ${MISSING_TOOLS[*]}. Please manually install the missing tools and try again."
      fi
    fi
  }

  # Clone the repository and install dotfiles.
  clone_repository() {

    has git || quit 2 "You need git installed in order to install HomeSetup remotely !"
    [[ ! -d "${HHS_HOME}" ]] && quit 2 "Installation directory was not created: \"${HHS_HOME}\" !"

    echo ''
    echo -e "${WHITE}Cloning HomeSetup from repository ..."

    if git clone "$REPO_URL" "${HHS_HOME}"; then
      \. "${DOTFILES_DIR}/${SHELL_TYPE}_colors.${SHELL_TYPE}"
    else
      quit 2 "Unable to properly clone the repository !"
    fi

    [[ ! -d "${DOTFILES_DIR}" ]] && quit 2 "Unable to find dotfiles directory \"${DOTFILES_DIR}\" !"
  }
  
  # Install all dotfiles.
  install_dotfiles() {

    local dotfile

    # Find all dotfiles used by HomeSetup according to the current shell type
    while IFS='' read -r dotfile; do
      ALL_DOTFILES+=("${dotfile}")
    done < <(find "${DOTFILES_DIR}" -maxdepth 1 -type f -name "*.${SHELL_TYPE}" -exec basename {} \;)

    echo ''
    echo -e "${WHITE}### Installation Settings ###"
    echo ''
    echo -e "${BLUE}  Install Type: ${METHOD}${NC}"
    echo -e "${BLUE}         Shell: ${MY_OS}-${MY_OS_RELEASE}/${SHELL_TYPE}${NC}"
    echo -e "${BLUE}Install Prefix: ${HHS_HOME}${NC}"
    echo -e "${BLUE}   Preferences: ${HHS_DIR}${NC}"

    if [[ "${METHOD}" == 'repair' || "${METHOD}" == 'local' ]]; then
      echo -e "${ORANGE}"
      [[ -z ${QUIET} ]] && read -rn 1 -p 'Your current .dotfiles will be replaced and your old files backed up. Continue y/[n] ? ' ANS
      echo -e "${NC}"
      [[ -n "$ANS" ]] && echo ''
      if [[ ! "$ANS" == "y" && ! "$ANS" == 'Y' ]]; then
        quit 1 "Installation cancelled !"
      fi
    else
      read -rn 1 -p "Press any key to continue with the installation ..."
    fi
    
    echo -e "${GREEN}Installing HomeSetup ...${NC}"
    
    # Create all user custom files.
    [[ -s "${HHS_DIR}/.aliases" ]] || \touch "${HHS_DIR}/.aliases"
    [[ -s "${HHS_DIR}/.colors" ]] || \touch "${HHS_DIR}/.colors"
    [[ -s "${HHS_DIR}/.env" ]] || \touch "${HHS_DIR}/.env"
    [[ -s "${HHS_DIR}/.functions" ]] || \touch "${HHS_DIR}/.functions"
    [[ -s "${HHS_DIR}/.profile" ]] || \touch "${HHS_DIR}/.profile"
    [[ -s "${HHS_DIR}/.prompt" ]] || \touch "${HHS_DIR}/.prompt"
    [[ -s "${HHS_DIR}/.path" ]] || \touch "${HHS_DIR}/.path"
    
    # Create alias and input definitions
    copy_file "${HHS_HOME}/dotfiles/inputrc" "${HOME}/.inputrc"
    copy_file "${HHS_HOME}/dotfiles/aliasdef" "${HHS_DIR}/.aliasdef"

    pushd "${DOTFILES_DIR}" &>/dev/null || quit 1 "Unable to enter dotfiles directory \"${DOTFILES_DIR}\" !"

    # If `all' option is used, copy all files
    if [[ "$OPT" == 'all' ]]; then
      # Copy all dotfiles
      # shellcheck disable=2048
      for next in ${ALL_DOTFILES[*]}; do
        dotfile="${HOME}/.${next//\.${SHELL_TYPE}/}"
        # Backup existing dotfile into ${HHS_BACKUP_DIR}
        [[ -s "${dotfile}" && ! -L "${dotfile}" ]] && \mv "${dotfile}" "${HHS_BACKUP_DIR}/$(basename "${dotfile}".orig)"
        echo -en "\n${WHITE}Linking: ${BLUE}"
        echo -en "$(\ln -sfv "${DOTFILES_DIR}/${next}" "${dotfile}")"
        echo -en "...${NC}"
        [[ -L "${dotfile}" ]] && echo -e "${WHITE} [   ${GREEN}OK${NC}   ]"
        [[ -L "${dotfile}" ]] || echo -e "${WHITE} [ ${RED}FAILED${NC} ]"
      done
    # If `all' option is NOT used, prompt for confirmation
    else
      # Copy all dotfiles
      # shellcheck disable=2048
      for next in ${ALL_DOTFILES[*]}; do
        dotfile="${HOME}/.${next//\.${SHELL_TYPE}/}"
        echo ''
        [[ -z ${QUIET} ]] && read -rn 1 -sp "Link ${dotfile} (y/[n])? " ANS
        [[ "$ANS" != 'y' && "$ANS" != 'Y' ]] && continue
        echo ''
        # Backup existing dotfile into ${HHS_BACKUP_DIR}
        [[ -s "${dotfile}" && ! -L "${dotfile}" ]] && \mv "${dotfile}" "${HHS_BACKUP_DIR}/$(basename "${dotfile}".orig)"
        echo -en "${WHITE}Linking: ${BLUE}"
        echo -en "$(\ln -sfv "${DOTFILES_DIR}/${next}" "${dotfile}")"
        echo -en "...${NC}"
        [[ -L "${dotfile}" ]] && echo -e "${WHITE} [   ${GREEN}OK${NC}   ]"
        [[ -L "${dotfile}" ]] || echo -e "${WHITE} [ ${RED}FAILED${NC} ]"
      done
    fi

    # Remove old apps
    echo -en "\n${WHITE}Removing old apps ...${BLUE}"
    if find "${BIN_DIR}" -maxdepth 1 -type l -delete -print &>/dev/null; then
      echo -e "${WHITE} [   ${GREEN}OK${NC}   ]"
    else
      quit 2 "Unable to remove old app links from \"${BIN_DIR}\" directory !"
    fi

    # Link apps into place
    echo -en "\n${WHITE}Linking apps from ${BLUE}${APPS_DIR} to ${BIN_DIR} ..."
    if find "${APPS_DIR}" -maxdepth 2 -type f \
      \( -iname "**.${SHELL_TYPE}" -o -iname "**.py" \) \
      -exec ln -sfv {} "${BIN_DIR}" \; \
      -exec chmod 755 {} \; 1>/dev/null; then
      echo -e "${WHITE} [   ${GREEN}OK${NC}   ]"
    else
      quit 2 "Unable to link apps into \"${BIN_DIR}\" directory !"
    fi

    # Link auto-completes into place
    echo -en "\n${WHITE}Linking auto-completes from ${BLUE}${COMPLETIONS_DIR} to ${BIN_DIR} ..."
    if find "${COMPLETIONS_DIR}/${SHELL_TYPE}" -maxdepth 2 -type f \
      \( -iname "**.${SHELL_TYPE}" \) \
      -exec ln -sfv {} "${BIN_DIR}" \; \
      -exec chmod 755 {} \; 1>/dev/null; then
      echo -e "${WHITE} [   ${GREEN}OK${NC}   ]"
    else
      quit 2 "Unable to link completions into bin (${BIN_DIR}) directory !"
    fi

    # Copy HomeSetup fonts into place
    echo -en "\n${WHITE}Copying HomeSetup fonts into ${BLUE}${FONTS_DIR} ..."
    [[ -d "${FONTS_DIR}" ]] || quit 2 "Unable to locate fonts (${FONTS_DIR}) directory !"
    if find "${HHS_HOME}"/misc/fonts -maxdepth 1 -type f \
      \( -iname "**.otf" -o -iname "**.ttf" \) \
      -exec cp -f {} "${FONTS_DIR}" \; 1>/dev/null; then
      echo -e "${WHITE} [   ${GREEN}OK${NC}   ]"
    else
      quit 2 "Unable to copy HHS fonts into fonts (${FONTS_DIR}) directory !"
    fi

    \popd &>/dev/null || quit 1 "Unable to leave dotfiles directory !"

    # Linking HomeSetup git hooks into place
    echo -en "\n${WHITE}Linking git hooks into place ..."
    \rm -f "${HHS_HOME}"/.git/hooks/* &>/dev/null
    if find "${HHS_HOME}"/templates/git/hooks -maxdepth 1 -type f -name "*" \
      -exec ln -sfv {} "${HHS_HOME}"/.git/hooks/ \; 1>/dev/null; then
      echo -e "${WHITE} [   ${GREEN}OK${NC}   ]"
    else
      quit 2 "Unable to link Git hooks into repository (.git/hooks/) !"
    fi
  }

  # Configure python and HHS python library
  configure_python() {
    echo ''
    echo -n 'Detecting local python environment ... '
    # Detecting system python and pip versions.
    PYTHON=$(command -v python3 2>/dev/null)
    PIP=$(command -v pip3 2>/dev/null)
    [[ -z "${PYTHON}" || -z "${PIP}" ]] && quit 2 "Python3 is required by HomeSetup and was not found!"
    echo -e "${WHITE}[   ${GREEN}OK${NC}   ]"
    echo "Found installed Python version $(python3 -V) at ${PYTHON}"
    install_hhslib "${PYTHON}" "${PIP}"
  }

  # Install HomeSetup python libraries
  install_hhslib() {
    PYTHON="${1:-python3}"
    PIP="${2:-pip3}"

    # HsPyLib-Vault installation
    echo -en "\n${WHITE}Installing HsPyLib-Vault using ${PYTHON} ..."
    ${PYTHON} -m pip install --upgrade hspylib-vault 1>/dev/null ||
      quit 2 "Unable to install HomeSetup Vault !"
    echo -e "${WHITE}[   ${GREEN}OK${NC}   ]"

    # HsPyLib-Firebase installation
    echo -en "\n${WHITE}Installing HsPyLib-Firebase using ${PYTHON} ..."
    ${PYTHON} -m pip install --upgrade hspylib-firebase 1>/dev/null ||
      quit 2 "Unable to install HomeSetup Firebase !"
    echo -e "${WHITE}[   ${GREEN}OK${NC}   ]"
    
    # HsPyLib-Clitt installation
    echo -en "\n${WHITE}Installing HsPyLib-Clitt using ${PYTHON} ..."
    ${PYTHON} -m pip install --upgrade hspylib-clitt 1>/dev/null ||
      quit 2 "Unable to install HomeSetup Clitt !"
    echo -e "${WHITE}[   ${GREEN}OK${NC}   ]"
  }

  # Check for backward HHS compatibility.
  compatibility_check() {

    echo -e "\n${WHITE}Checking HHS compatibility ...${BLUE}"
    
    # Cleaning up old dotfiles links
    [[ -d "${BIN_DIR}" ]] && rm -f "${BIN_DIR:?}/*.*"
    
    # .profile Needs to be renamed, so, we guarantee that no dead lock occurs.
    if [[ -f "${HOME}/.profile" ]]; then
      \mv -f "${HOME}/.profile" "${HHS_BACKUP_DIR}/profile.orig"
      echo ''
      echo -e "\n${YELLOW}Your old ${HOME}/.profile had to be renamed to ${HHS_BACKUP_DIR}/profile.orig "
      echo -e "This is to avoid invoking dotfiles multiple times. If you are sure that your .profile don't source either"
      echo -e ".bash_profile or .bashrc, then, you can rename it back to .profile: "
      echo -e "$ mv ${HHS_BACKUP_DIR}/profile.orig ${HOME}/.profile"
      echo ''
      read -rn 1 -p "Press any key to continue...${NC}"
    fi

    # Moving old hhs files into the proper directory.
    [[ -f "${HOME}/.cmd_file" ]] && \mv -f "${HOME}/.cmd_file" "${HHS_DIR}/.cmd_file"
    [[ -f "${HOME}/.saved_dir" ]] && \mv -f "${HOME}/.saved_dir" "${HHS_DIR}/.saved_dirs"
    [[ -f "${HOME}/.punches" ]] && \mv -f "${HOME}/.punches" "${HHS_DIR}/.punches"
    [[ -f "${HOME}/.firebase" ]] && \mv -f "${HOME}/.firebase" "${HHS_DIR}/.firebase"

    # From hspylib integration on
    [[ -f "${HOME}/.aliases" ]] && \mv -f "${HOME}/.aliases" "${HHS_DIR}/.aliases"
    [[ -f "${HOME}/.aliasdef" ]] && \mv -f "${HOME}/.aliasdef" "${HHS_DIR}/.aliasdef"
    [[ -f "${HOME}/.colors" ]] && \mv -f "${HOME}/.colors" "${HHS_DIR}/.colors"
    [[ -f "${HOME}/.env" ]] && \mv -f "${HOME}/.env" "${HHS_DIR}/.env"
    [[ -f "${HOME}/.functions" ]] && \mv -f "${HOME}/.functions" "${HHS_DIR}/.functions"
    [[ -f "${HOME}/.profile" ]] && \mv -f "${HOME}/.profile" "${HHS_DIR}/.profile"
    [[ -f "${HOME}/.prompt" ]] && \mv -f "${HOME}/.prompt" "${HHS_DIR}/.prompt"

    # Removing the old ${HOME}/bin folder.
    if [[ -L "${HOME}/bin" ]]; then
      \rm -f "${HOME:?}/bin"
      echo -e "\n${ORANGE}Your old ${HOME}/bin link had to be removed. ${NC}"
    fi

    # .bash_aliasdef was renamed to .aliasdef and it is only copied if it does not exist. #9c592e0 .
    if [[ -L "${HOME}/.bash_aliasdef" ]]; then
      \rm -f "${HOME}/.bash_aliasdef"
      echo -e "\n${ORANGE}Your old ${HOME}/.bash_aliasdef link had to be removed. ${NC}"
    fi

    # .inputrc Needs to be updated, so, we need to replace it.
    if [[ -f "${HOME}/.inputrc" ]]; then
      \mv -f "${HOME}/.inputrc" "${HHS_BACKUP_DIR}/inputrc-${TIMESTAMP}.bak"
      \cp -f "${HHS_HOME}/dotfiles/inputrc" "${HOME}/.inputrc"
      echo -e "\n${ORANGE}Your old ${HOME}/.inputrc had to be replaced by a new version. Your old file it located at ${HHS_BACKUP_DIR}/inputrc-${TIMESTAMP}.bak ${NC}"
    fi

    # .aliasdef Needs to be updated, so, we need to replace it.
    if [[ -f "${HOME}/.aliasdef" || -f "${HHS_HOME}/dotfiles/aliasdef" ]]; then
      [[ -f "${HOME}/.aliasdef" ]] && \cp -f "${HOME}/.aliasdef" "${HHS_BACKUP_DIR}/aliasdef-${TIMESTAMP}.bak"
      [[ -f "${HHS_HOME}/dotfiles/aliasdef" ]] && \cp -f "${HHS_HOME}/dotfiles/aliasdef" "${HHS_BACKUP_DIR}/aliasdef-${TIMESTAMP}.bak"
      echo -e "\n${ORANGE}Your old .aliasdef had to be replaced by a new version. Your old file it located at ${HHS_BACKUP_DIR}/aliasdef-${TIMESTAMP}.bak ${NC}"
    fi

    # Moving .path file to .hhs .
    if [[ -f "${HOME}/.path" ]]; then
      \mv -f "${HOME}/.path" "${HHS_DIR}/.path"
      echo -e "\n${ORANGE}Moved file ${HOME}/.path into ${HHS_DIR}/.path"
    fi

    # .bash_completions was renamed to .bash_completion. #e6ce231 .
    if [[ -L "${HOME}/.bash_completions" ]]; then
      rm -f "${HOME}/.bash_completions"
      echo -e "\n${ORANGE}Your old ${HOME}/.bash_completions link had to be removed. ${NC}"
    fi

    # Removing the old python lib directories and links.
    [[ -d "${HHS_HOME}/bin/apps/bash/hhs-app/lib" ]] &&
      \rm -rf "${HHS_HOME}/bin/apps/bash/hhs-app/lib"
    [[ -L "${HHS_HOME}/bin/apps/bash/hhs-app/plugins/firebase/lib" ]] &&
      \rm -rf "${HHS_HOME}/bin/apps/bash/hhs-app/plugins/firebase/lib"
    [[ -L "${HHS_HOME}/bin/apps/bash/hhs-app/plugins/vault/lib" ]] &&
      \rm -rf "${HHS_HOME}/bin/apps/bash/hhs-app/plugins/vault/lib"
      
    # Moving orig and bak files to backup folder.
    
  }

  # Reload the terminal and apply installed files.
  activate_dotfiles() {

    echo ''
    echo -e "${GREEN}Done installing HomeSetup files. Reloading terminal ...${NC}"
    echo -e "${BLUE}"

    echo -e "${BLUE}"
    echo '888       888          888                                          '
    echo '888   o   888          888                                          '
    echo '888  d8b  888          888                                          '
    echo '888 d888b 888  .d88b.  888  .d8888b  .d88b.  88888b.d88b.   .d88b.  '
    echo '888d88888b888 d8P  Y8b 888 d88P"    d88""88b 888 "888 "88b d8P  Y8b '
    echo '88888P Y88888 88888888 888 888      888  888 888  888  888 88888888 '
    echo '8888P   Y8888 Y8b.     888 Y88b.    Y88..88P 888  888  888 Y8b.     '
    echo '888P     Y888  "Y8888  888  "Y8888P  "Y88P"  888  888  888  "Y8888  '
    echo ''
    echo -e "${HAND_PEACE_ICN} Your shell, good as hell... not just dotfiles !"
    echo ''
    echo -e "${GREEN}${STAR_ICN} Dotfiles v$(cat "${HHS_HOME}/.VERSION") has been installed !"
    echo -e "${YELLOW}${STAR_ICN} To activate your dotfiles close and re-open the terminal"
    echo -e "${YELLOW}${STAR_ICN} To check for updates type: ${GREEN}#> hhu --update"
    echo ''
    echo -e "${YELLOW}${NOTE_ICN} Open ${BLUE}${HHS_HOME}/README.md${WHITE} for details about your new Terminal${NC}"
    echo ''

    if [[ "Darwin" == "${MY_OS}" ]]; then
      \date -v+7d '+%s%S' >"${HHS_DIR}/.last_update"
    else
      \date -d '+7 days' '+%s%S' >"${HHS_DIR}/.last_update"
    fi
  }

  check_current_shell
  check_inst_method "$@"
}
