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

  # This script name.
  APP_NAME="${0##*/}"

  # Help message to be displayed by the script.
  USAGE="
Usage: $APP_NAME [OPTIONS] <args>

  -i | --interactive        : Install all scripts into the user HomeSetup directory interactively.
  -q | --quiet              : Do not prompt for questions, use all defaults.
"

  # HomeSetup GitHub repository URL.
  REPO_URL='https://github.com/yorevs/homesetup.git'

  # Define the user HOME.
  HOME=${HOME:-~}

  # Option to allow install to be interactive.
  OPT='all'

  # Shell type.
  SHELL_TYPE="${SHELL##*/}"

  # .dotfiles we will handle.
  ALL_DOTFILES=()

  # Supported shell types. For now, only bash is supported.
  SUPP_SHELL_TYPES=('bash')

  # Timestamp used to backup files.
  TIMESTAMP=$(\date "+%s%S")

  # User's operating system.
  MY_OS=$(uname -s)

  # HomeSetup required tools.
  REQUIRED_TOOLS=('git' 'curl' 'gpg')
  
  # Darwing required tools
  if [[ "${MY_OS}" == "Darwin" ]]; then
    REQUIRED_TOOLS+=('brew' 'xcode-select' 'python' 'pip')
  elif [[ "${MY_OS}" == "Linux" ]]; then
    # Debian required tools
    command -v 'apt-get' &>/dev/null && REQUIRED_TOOLS+=('python2' 'python-pip')
    # RedHat required tools
    command -v 'yum'  &>/dev/null && REQUIRED_TOOLS+=('python2' 'python-pip2')
  fi

  # Missing HomeSetup required tools.
  MISSING_TOOLS=()

  # ICONS
  APPLE_ICN="\xef\x85\xb9"
  STAR_ICN="\xef\x80\x85"
  NOTE_ICN="\xef\x84\x98"
  HAND_PEACE_ICN="\xef\x89\x9b"

  # Functions to be unset after quit.
  UNSETS=(
    quit usage has check_current_shell check_inst_method install_dotfiles clone_repository check_installed_tools
    activate_dotfiles compatibility_check install_missing_tools configure_python install_hhslib
  )

  # Purpose: Quit the program and exhibits an exit message if specified.
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

  # Usage message.
  usage() {
    quit 2 "$USAGE"
  }

  # @function: Check if a command exists.
  # @param $1 [Req] : The command to check.
  has() {
    type "$1" >/dev/null 2>&1
  }

  # shellcheck disable=SC2199,SC2076
  # Check current active User shell type.
  check_current_shell() {

    if [[ ! " ${SUPP_SHELL_TYPES[@]} " =~ " ${SHELL##*/} " ]]; then
      quit 2 "Your current shell type is not supported: \"${SHELL}\""
    fi
  }

  # shellcheck disable=SC1091
  # Check which installation method should be used.
  check_inst_method() {

    # Define the HomeSetup location.
    HHS_HOME=${HHS_HOME:-${HOME}/HomeSetup}

    # Dotfiles source location.
    DOTFILES_DIR="${HHS_HOME}/dotfiles/${SHELL_TYPE}"

    # HHS applications location.
    APPS_DIR="${HHS_HOME}/bin/apps"

    # Auto-completions location.
    COMPLETIONS_DIR="${HHS_HOME}/bin/completions"

    # Enable install script to use colors.
    [[ -f "${DOTFILES_DIR}/${SHELL_TYPE}_colors.${SHELL_TYPE}" ]] && \. "${DOTFILES_DIR}/${SHELL_TYPE}_colors.${SHELL_TYPE}"
    [[ -f "${HHS_HOME}/.VERSION" ]] && echo -e "${GREEN}HomeSetup© ${YELLOW}v$(grep . "${HHS_HOME}/.VERSION") installation ${NC}"

    # Check if the user passed the help or version parameters.
    [[ "$1" == '-h' || "$1" == '--help' ]] && quit 0 "$USAGE"
    [[ "$1" == '-v' || "$1" == '--version' ]] && version

    # Loop through the command line options.
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

    # Create HomeSetup directory
    if [[ ! -d "${HHS_HOME}" ]]; then
      echo -en "\nCreating ${HHS_HOME} directory: "
      \mkdir -p "${HHS_HOME}" || quit 2 "Unable to create directory ${HHS_HOME}"
      echo -e " ... [   ${GREEN}OK${NC}   ]"
    else
      \touch "${HHS_HOME}/tmpfile" &>/dev/null || quit 2 "Installation directory is not valid: ${HHS_HOME}"
      \rm -f "${HHS_HOME:?}/tmpfile" &>/dev/null
    fi

    # Create/Define the ${HOME}/.hhs directory
    HHS_DIR="${HHS_DIR:-${HOME}/.hhs}"
    if [[ ! -d "${HHS_DIR}" ]]; then
      echo -en "\nCreating ${HHS_DIR} directory: "
      mkdir -p "${HHS_DIR}" || quit 2 "Unable to create directory ${HHS_DIR}"
      echo -e " ... [   ${GREEN}OK${NC}   ]"
    else
      # Trying to write at the HomeSetup directory to check the permissions
      \touch "${HHS_DIR}/tmpfile" &>/dev/null || quit 2 "Not enough permissions to access the HomeSetup directory: ${HHS_DIR}"
      \rm -f "${HHS_DIR:?}/tmpfile" &>/dev/null
    fi

    # Create/Define the ${HHS_DIR}/bin directory
    BIN_DIR="${HHS_DIR}/bin"
    if [[ ! -L "${BIN_DIR}" && ! -d "${BIN_DIR}" ]]; then
      echo -en "\nCreating ${BIN_DIR} directory: "
      \mkdir -p "${BIN_DIR}" || quit 2 "Unable to create directory ${HHS_DIR}"
      echo -e " ... [   ${GREEN}OK${NC}   ]"
    else
      # Cleaning up old dotfiles links
      [[ -d "${BIN_DIR}" ]] && rm -f "${BIN_DIR:?}/*.*"
    fi

    # Create fonts directory if it does not exist
    if [[ "Darwin" == "${MY_OS}" ]]; then
      FONTS_DIR="${HOME}/Library/Fonts"
    elif [[ "Linux" == "${MY_OS}" ]]; then
      FONTS_DIR="${HOME}/.local/share/fonts"
    fi
    if [[ ! -L "${FONTS_DIR}" && ! -d "${FONTS_DIR}" ]]; then
      echo -en "\nCreating ${FONTS_DIR} directory: "
      \mkdir -p "${FONTS_DIR}" || quit 2 "Unable to create directory ${FONTS_DIR}"
      echo -e " ... [   ${GREEN}OK${NC}   ]"
    fi

    # Check the installation method.
    if [[ -n "${HHS_VERSION}" && -f "${HHS_HOME}/.VERSION" ]]; then
      METHOD='repair'
    elif [[ -z "${HHS_VERSION}" && -f "${HHS_HOME}/.VERSION" ]]; then
      METHOD='local'
    else
      METHOD='remote'
    fi

    case "$METHOD" in
    remote)
      check_installed_tools
      install_missing_tools
      clone_repository
      install_dotfiles
      configure_python
      compatibility_check
      activate_dotfiles
      ;;
    local | repair)
      check_installed_tools
      install_missing_tools
      install_dotfiles
      configure_python
      compatibility_check
      activate_dotfiles
      ;;
    *)
      quit 2 "Installation method is not valid: ${METHOD}"
      ;;
    esac
  }

  # Check installed tools.
  check_installed_tools() {

    local os_type pad pad_len

    has sudo &>/dev/null && SUDO='sudo'

    if has 'apt-get'; then
      os_type='Debian'
    elif has 'yum'; then
      os_type='RedHat'
    elif has 'brew'; then
      os_type='MacOs'
    else
      quit 1 "Unable to find package manager for $(uname -s)"
    fi

    echo ''
    echo -e "${WHITE}Checking required tools [${os_type}] ...${NC}"
    echo ''

    pad=$(printf '%0.1s' "."{1..60})
    pad_len=20

    for tool_name in "${REQUIRED_TOOLS[@]}"; do
      echo -en "${WHITE}Checking: ${YELLOW}${tool_name}${NC} ..."
      printf '%*.*s' 0 $((pad_len - ${#tool_name})) "${pad}"
      if has "${tool_name}"; then
        echo -e " [   ${GREEN}INSTALLED${NC}   ] \n"
      else
        echo -e " [ ${RED}NOT INSTALLED${NC} ] \n"
        MISSING_TOOLS+=("${tool_name}")
      fi
    done
  }

  # shellcheck disable=SC2086
  # Install missing tools
  install_missing_tools() {

    if [[ ${#MISSING_TOOLS[@]} -ne 0 ]]; then
      [[ -n "${SUDO}" ]] && echo -e "\nUsing 'sudo' to install apps"
      echo ''
      echo -en "${WHITE}Installing HomeSetup required packages [${MISSING_TOOLS[*]}] (${MY_OS}) "
      if [[ "Darwin" == "${MY_OS}" ]]; then
        ${SUDO} brew install ${MISSING_TOOLS[*]} &> /dev/null || quit 2 "Failed to install: ${MISSING_TOOLS[*]}"
      else
        if has "apt-get"; then
          ${SUDO} apt-get -y install ${MISSING_TOOLS[*]} &> /dev/null || quit 2 "Failed to install: ${MISSING_TOOLS[*]}"
        elif has "yum"; then
          ${SUDO} yum -y install ${MISSING_TOOLS[*]} &> /dev/null || quit 2 "Failed to install: ${MISSING_TOOLS[*]}"
        fi
      fi
      echo -e " ... [   ${GREEN}OK${NC}   ]"
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

    # Create all user custom files.
    [[ -f "${HOME}/.aliasdef" ]] || \cp "${HHS_HOME}/dotfiles/aliasdef" "${HOME}/.aliasdef"
    [[ -f "${HOME}/.inputrc" ]] || \cp "${HHS_HOME}/dotfiles/inputrc" "${HOME}/.inputrc"
    [[ -f "${HOME}/.aliases" ]] || \touch "${HOME}/.aliases"
    [[ -f "${HOME}/.colors" ]] || \touch "${HOME}/.colors"
    [[ -f "${HOME}/.env" ]] || \touch "${HOME}/.env"
    [[ -f "${HOME}/.functions" ]] || \touch "${HOME}/.functions"
    [[ -f "${HOME}/.profile" ]] || \touch "${HOME}/.profile"
    [[ -f "${HOME}/.prompt" ]] || \touch "${HOME}/.prompt"
    [[ -f "${HHS_DIR}/.path" ]] || \touch "${HHS_DIR}/.path"

    # Find all dotfiles used by HomeSetup according to the current shell type
    while IFS='' read -r dotfile; do
      ALL_DOTFILES+=("${dotfile}")
    done < <(find "${DOTFILES_DIR}" -maxdepth 1 -name "*.${SHELL_TYPE}" -exec basename {} \;)

    echo -e ''
    echo -e "${WHITE}### Installation Settings ###"
    echo -e "${BLUE}"
    echo -e "  Install Type: ${METHOD}"
    echo -e "            OS: ${MY_OS}"
    echo -e "         Shell: ${SHELL_TYPE}"
    echo -e "   Install Dir: ${HHS_HOME}"
    echo -e "     Fonts Dir: ${FONTS_DIR}"
    echo -e "  Dotfiles Dir: ${DOTFILES_DIR}"
    echo -e "      Dotfiles: ${ALL_DOTFILES[*]}"
    echo -e "${NC}"

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

    pushd "${DOTFILES_DIR}" &>/dev/null || quit 1 "Unable to enter dotfiles directory \"${DOTFILES_DIR}\" !"
    echo -e "\n${WHITE}Installing dotfiles ...${NC}"

    # If `all' option is used, copy all files
    if [[ "$OPT" == 'all' ]]; then
      # Copy all dotfiles
      for next in ${ALL_DOTFILES[*]}; do
        dotfile="${HOME}/.${next//\.${SHELL_TYPE}/}"
        # Backup existing dotfile into ${HOME}/.hhs
        [[ -s "${dotfile}" ]] && \mv "${dotfile}" "${HHS_DIR}/$(basename "${dotfile}".orig)"
        echo -en "\n${WHITE}Linking: ${BLUE}"
        echo -en "$(\ln -sfv "${DOTFILES_DIR}/${next}" "${dotfile}")"
        echo -en "${NC}"
        [[ -L "${dotfile}" ]] && echo -e "${WHITE} ... [   ${GREEN}OK${NC}   ]"
        [[ -L "${dotfile}" ]] || echo -e "${WHITE} ... [ ${RED}FAILED${NC} ]"
      done
    # If `all' option is NOT used, prompt for confirmation
    else
      # Copy all dotfiles
      for next in ${ALL_DOTFILES[*]}; do
        dotfile="${HOME}/.${next//\.${SHELL_TYPE}/}"
        echo ''
        [[ -z ${QUIET} ]] && read -rn 1 -sp "Link ${dotfile} (y/[n])? " ANS
        [[ "$ANS" != 'y' && "$ANS" != 'Y' ]] && continue
        echo ''
        # Backup existing dotfile into ${DOTFILES_DIR}
        [[ -s "${dotfile}" ]] && \mv "${dotfile}" "${HHS_DIR}/$(basename "${dotfile}".orig)"
        echo -en "${WHITE}Linking: ${BLUE}"
        echo -en "$(\ln -sfv "${DOTFILES_DIR}/${next}" "${dotfile}")"
        echo -en "${NC}"
        [[ -L "${dotfile}" ]] && echo -e "${WHITE} ... [   ${GREEN}OK${NC}   ]"
        [[ -L "${dotfile}" ]] || echo -e "${WHITE} ... [ ${RED}FAILED${NC} ]"
      done
    fi

    # Remove old apps
    echo -en "\n${WHITE}Removing old apps ${BLUE}"
    if find "${BIN_DIR}" -maxdepth 1 -type l -delete -print &>/dev/null; then
      echo -e "${WHITE} ... [   ${GREEN}OK${NC}   ]"
    else
      quit 2 "Unable to remove old app links from \"${BIN_DIR}\" directory !"
    fi

    # Link apps into place
    echo -en "\n${WHITE}Linking apps from ${APPS_DIR} to ${BIN_DIR} ${BLUE}"
    if find "${APPS_DIR}" -maxdepth 2 -type f \
      \( -iname "**.${SHELL_TYPE}" -o -iname "**.py" \) \
      -exec ln -sfv {} "${BIN_DIR}" \; \
      -exec chmod 755 {} \; 1>/dev/null; then
      echo -e "${WHITE} ... [   ${GREEN}OK${NC}   ]"
    else
      quit 2 "Unable to link apps into \"${BIN_DIR}\" directory !"
    fi

    # Link auto-completes into place
    echo -en "\n${WHITE}Linking auto-completes from ${COMPLETIONS_DIR} to ${BIN_DIR} ${BLUE}"
    if find "${COMPLETIONS_DIR}/${SHELL_TYPE}" -maxdepth 2 -type f \
      \( -iname "**.${SHELL_TYPE}" \) \
      -exec ln -sfv {} "${BIN_DIR}" \; \
      -exec chmod 755 {} \; 1>/dev/null; then
      echo -e "${WHITE} ... [   ${GREEN}OK${NC}   ]"
    else
      quit 2 "Unable to link completions into bin (${BIN_DIR}) directory !"
    fi

    # Copy HomeSetup fonts into place
    echo -en "\n${WHITE}Copying HomeSetup into ${FONTS_DIR} ${BLUE}"
    [[ -d "${FONTS_DIR}" ]] || quit 2 "Unable to locate fonts (${FONTS_DIR}) directory !"
    if find "${HHS_HOME}"/misc/fonts -maxdepth 1 -type f \
      \( -iname "**.otf" -o -iname "**.ttf" \) \
      -exec cp -f {} "${FONTS_DIR}" \; 1>/dev/null; then
      echo -e "${WHITE} ... [   ${GREEN}OK${NC}   ]"
    else
      quit 2 "Unable to copy HHS fonts into fonts (${FONTS_DIR}) directory !"
    fi

    \popd &>/dev/null || quit 1 "Unable to leave dotfiles directory !"

    # Linking HomeSetup git hooks into place
    echo -en "\n${WHITE}Linking git hooks into place"
    \rm -f "${HHS_HOME}"/.git/hooks/* &>/dev/null
    if find "${HHS_HOME}"/templates/git/hooks -maxdepth 1 -type f -name "*" \
      -exec ln -sfv {} "${HHS_HOME}"/.git/hooks/ \; 1>/dev/null; then
      echo -e "${WHITE} ... [   ${GREEN}OK${NC}   ]"
    else
      quit 2 "Unable to link Git hooks into repository (.git/hooks/) !"
    fi
  }

  # Configure python and HHS python library
  configure_python() {
    # Detecting system python and pip versions.
    PYTHON=$(command -v python 2>/dev/null)
    if [[ -n "${PYTHON}" ]]; then
      install_hhslib "${PYTHON}"
    else
      if has python2; then 
        prefix=$(dirname "$(command -v python2 2> /dev/null)")
        [[ -f "${prefix}/python" ]] || ${SUDO} ln -sfv "${prefix}/python2" "${prefix}/python"
        PYTHON=$(command -v python2 2>/dev/null)
        [[ -z "${PYTHON}" ]] && quit 2 "Unable to find a valid python(${PYTHON}) installation."
        install_hhslib "${PYTHON}"
      fi
    fi
  }

  # Install HomeSetup python libraries
  install_hhslib() {
    PYTHON="${1}";
    echo -en "\n${WHITE}Installing HomeSetup python library using ${PYTHON} ..."
    \pushd "${HHS_HOME}/bin/apps/py/lib" &>/dev/null || quit 1 "Unable to enter hhslib directory !"
    if ${PYTHON} -m pip install --user . &>/dev/null; then
      if ${PYTHON} -c "from hhslib.colors import cprint"; then
        echo -e "${WHITE} [   ${GREEN}OK${NC}   ]"
      else
        echo -e "${WHITE} [   ${RED}FAIL${NC}   ]"
        quit 2 "Unable to install HomeSetup python library !"
      fi
    else
      quit 2 "Unable to install HomeSetup python library !"
    fi
    \popd &>/dev/null || quit 1 "Unable to leave hhslib directory !"
  }

  # Check for backward HHS compatibility.
  compatibility_check() {

    echo -e "\n${WHITE}Checking HHS compatibility ...${BLUE}"
    # Removing the old .profile if exists
    if [[ -f "${HOME}/.profile" ]]; then
      \mv -f "${HOME}/.profile" "${HHS_DIR}/profile-${TIMESTAMP}.orig"
      \touch "${HOME}/.profile"
      echo -e "\n${ORANGE}Your old .profile had to be replaced by a new version. Your old file it located at ${HHS_DIR}/profile-${TIMESTAMP}.bak ${NC}"
    fi

    # Moving old hhs files into the proper directory
    [[ -f "${HOME}/.cmd_file" ]] && \mv -f "${HOME}/.cmd_file" "${HHS_DIR}/.cmd_file"
    [[ -f "${HOME}/.saved_dir" ]] && \mv -f "${HOME}/.saved_dir" "${HHS_DIR}/.saved_dirs"
    [[ -f "${HOME}/.punches" ]] && \mv -f "${HOME}/.punches" "${HHS_DIR}/.punches"
    [[ -f "${HOME}/.firebase" ]] && \mv -f "${HOME}/.firebase" "${HHS_DIR}/.firebase"

    # Removing the old ${HOME}/bin folder
    if [[ -L "${HOME}/bin" ]]; then
      \rm -f "${HOME:?}/bin"
      echo -e "\n${ORANGE}Your old ${HOME}/bin link had to be removed. ${NC}"
    fi

    # .bash_aliasdef was renamed to .aliasdef and it is only copied if it does not exist. #9c592e0
    if [[ -L "${HOME}/.bash_aliasdef" ]]; then
      \rm -f "${HOME}/.bash_aliasdef"
      echo -e "\n${ORANGE}Your old ${HOME}/.bash_aliasdef link had to be removed. ${NC}"
    fi

    # .aliasdef Needs to be updated, so, we need to replace it
    if [[ -f "${HOME}/.aliasdef" ]]; then
      \cp -f "${HOME}/.aliasdef" "${HHS_DIR}/aliasdef-${TIMESTAMP}.bak"
      \cp -f "${HHS_HOME}/dotfiles/aliasdef" "${HOME}/.aliasdef"
      echo -e "\n${ORANGE}Your old .aliasdef had to be replaced by a new version. Your old file it located at ${HHS_DIR}/aliasdef-${TIMESTAMP}.bak ${NC}"
    fi

    # .inputrc Needs to be updated, so, we need to replace it
    if [[ -f "${HOME}/.inputrc" ]]; then
      \cp -f "${HOME}/.inputrc" "${HHS_DIR}/inputrc.bak"
      \cp -f "${HHS_HOME}/dotfiles/inputrc" "${HOME}/.inputrc"
      echo -e "\n${ORANGE}Your old .inputrc had to be replaced by a new version. Your old file it located at ${HHS_DIR}/inputrc-${TIMESTAMP}.bak ${NC}"
    fi

    # Moving .path file to .hhs
    if [[ -f "${HOME}/.path" ]]; then
      \mv -f "${HOME}/.path" "${HHS_DIR}/.path"
      echo -e "\n${ORANGE}Moved file ${HOME}/.path into ${HHS_DIR}/.path"
    fi

    # .bash_completions was renamed to .bash_completion. #e6ce231
    if [[ -L "${HOME}/.bash_completions" ]]; then
      rm -f "${HOME}/.bash_completions"
      echo -e "\n${ORANGE}Your old ${HOME}/.bash_completions link had to be removed. ${NC}"
    fi

    # Removing the old python lib directories and links
    [[ -d "${HHS_HOME}/bin/apps/bash/hhs-app/lib" ]] &&
      \rm -rf "${HHS_HOME}/bin/apps/bash/hhs-app/lib"
    [[ -L "${HHS_HOME}/bin/apps/bash/hhs-app/plugins/firebase/lib" ]] &&
      \rm -rf "${HHS_HOME}/bin/apps/bash/hhs-app/plugins/firebase/lib"
    [[ -L "${HHS_HOME}/bin/apps/bash/hhs-app/plugins/vault/lib" ]] &&
      \rm -rf "${HHS_HOME}/bin/apps/bash/hhs-app/plugins/vault/lib"
  }

  # Reload the terminal and apply installed files.
  activate_dotfiles() {

    echo ''
    echo -e "${GREEN}Done installing HomeSetup files. Reloading terminal ...${NC}"
    echo -e "${BLUE}"

    echo -e "${BLUE}"
    if has figlet &>/dev/null; then
      figlet -f colossal -ck "Welcome" 2>/dev/null || figlet "Welcome"
    else
      echo 'ww      ww   eEEEEEEEEe   LL           cCCCCCCc    oOOOOOOo    mm      mm   eEEEEEEEEe'
      echo 'WW      WW   EE           LL          Cc          OO      Oo   MM M  M MM   EE        '
      echo 'WW  ww  WW   EEEEEEEE     LL          Cc          OO      OO   MM  mm  MM   EEEEEEEE  '
      echo 'WW W  W WW   EE           LL     ll   Cc          OO      Oo   MM      MM   EE        '
      echo 'ww      ww   eEEEEEEEEe   LLLLLLLll    cCCCCCCc    oOOOOOOo    mm      mm   eEEEEEEEEe'
      echo ''
    fi
    echo -e "${HAND_PEACE_ICN} Your shell, good as hell... not just dotfiles !"
    echo ''
    echo -e "${GREEN}${APPLE_ICN} Dotfiles v$(cat "${HHS_HOME}/.VERSION") has been installed !"
    echo ''
    echo -e "${YELLOW}${STAR_ICN} To activate your dotfiles ${GREEN}type: #> exec bash"
    echo -e "${YELLOW}${STAR_ICN} To reload HomeSetup type: ${GREEN}#> __hhs_reload"
    echo -e "${YELLOW}${STAR_ICN} To check for updates type: ${GREEN}#> hhu"
    echo ''
    echo -e "${YELLOW}${NOTE_ICN} Open ${BLUE}README.md${WHITE} for full details about your new Terminal"
    echo -e "${NC}"

    if [[ "Darwin" == "${MY_OS}" ]]; then
      \date -v+7d '+%s%S' >"${HHS_DIR}/.last_update"
    else
      \date -d '+7 days' '+%s%S' >"${HHS_DIR}/.last_update"
    fi
  }

  check_current_shell
  check_inst_method "$@"
}
