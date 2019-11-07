#!/usr/bin/env bash
# shellcheck disable=SC1117,SC1090

#  Script: install.bash
# Purpose: Install and configure HomeSetup
# Created: Aug 26, 2018
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs/homesetup
# License: Please refer to <http://unlicense.org/>

{

    # This script name.
    PROC_NAME=$(basename "$0")

    # Help message to be displayed by the script.
    USAGE="
Usage: $PROC_NAME [OPTIONS] <args>

  -a | --all           : Install all scripts into the user HomeSetup directory without prompting.
  -q | --quiet         : Do not prompt for questions, use all defaults.
  -d | --dir <hss_dir> : Specify where to install the HomeSetup files.
"

    # HomeSetup GitHub repository URL.
    REPO_URL='https://github.com/yorevs/homesetup.git'

    # Define the user HOME
    HOME=${HOME:-~}

    # ICONS
    APPLE_ICN="\xef\x85\xb9"
    STAR_ICN="\xef\x80\x85"
    NOTE_ICN="\xef\x84\x98"

    # Purpose: Quit the program and exhibits an exit message if specified.
    # @param $1 [Req] : The exit return code.
    # @param $2 [Opt] : The exit message to be displayed.
    quit() {

        # Unset all declared functions
        unset -f \
            quit usage check_inst_method install_dotfiles \
            clone_repository activate_dotfiles

        test "$1" != '0' -a "$1" != '1' && echo -e "${RED}"
        test -n "$2" -a "$2" != "" && echo -e "${2}"
        test "$1" != '0' -a "$1" != '1' && echo -e "${NC}"
        echo ''
        exit "$1"
    }

    # Usage message.
    usage() {
        quit 2 "$USAGE"
    }

    # shellcheck disable=SC1091
    # Check which installation method should be used.
    check_inst_method() {

        # Check for previous custom installation dir
        [ -z "$INSTALL_DIR" ] && INSTALL_DIR="$HOME/HomeSetup"

        # Define the HomeSetup directory.
        HHS_HOME=${HHS_HOME:-$INSTALL_DIR}

        # Enable install script to use colors
        [ -f 'dotfiles/hhs_colors.bash' ] && \. 'dotfiles/hhs_colors.bash'
        [ -f "$HHS_HOME/.VERSION" ] && echo -e "${GREEN}HomeSetup© ${YELLOW}v$(grep . "$HHS_HOME/.VERSION") installation ${NC}"

        # Check if the user passed the help or version parameters.
        [ "$1" = '-h' ] || [ "$1" = '--help' ] && quit 0 "$USAGE"
        [ "$1" = '-v' ] || [ "$1" = '--version' ] && version

        # Loop through the command line options.
        # Short opts: -w, Long opts: --Word
        while test -n "$1"; do
            case "$1" in
            -a | --all)
                OPT="all"
                ;;
            -q | --quiet)
                OPT="all"
                ANS="Y"
                QUIET=1
                ;;
            -d | --dir)
                shift
                INSTALL_DIR="${1:-$(pwd)}"
                ;;
            *)
                quit 2 "Invalid option: \"$1\""
                ;;
            esac
            shift
        done

        # Dotfiles used by HomeSetup
        ALL_DOTFILES=(
            "hhs_aliasdef"
            "hhs_aliases"
            "hhs_colors"
            "hhs_env"
            "hhs_functions"
            "hhs_profile"
            "hhs_prompt"
            "hhsrc"
        )

        # Create HomeSetup directory
        if [ ! -d "$HHS_HOME" ]; then
            echo -e "\nCreating 'HomeSetup' directory: "
            echo -en "$(mkdir -p "$HHS_HOME")"
            [ -d "$HHS_HOME" ] || quit 2 "Unable to create directory $HHS_HOME"
            echo -e " ... [   ${GREEN}OK${NC}   ]"
        else
            touch "$HHS_HOME/tmpfile" &>/dev/null || quit 2 "Installation directory is not valid: ${HHS_HOME}"
            command rm -f "$HHS_HOME/tmpfile" &>/dev/null
        fi

        # Create/Define the $HOME/.hhs directory
        HHS_DIR="${HHS_DIR:-$HOME/.hhs}"
        if [ ! -d "$HHS_DIR" ]; then
            echo -en "\nCreating '.hhs' directory: "
            echo -en "$(mkdir -p "$HHS_DIR")"
            [ -d "$HHS_DIR" ] || quit 2 "Unable to create directory $HHS_DIR"
            echo -e " ... [   ${GREEN}OK${NC}   ]"
        else
            touch "$HHS_DIR/tmpfile" &>/dev/null || quit 2 "Unable to access the HomeSetup directory: ${HHS_DIR}"
            command rm -f "$HHS_DIR/tmpfile" &>/dev/null
        fi

        # Create/Define the $HHS_DIR/bin directory
        BIN_DIR="$HHS_DIR/bin"
        # Create or directory ~/bin if it does not exist
        if ! [ -L "$BIN_DIR" ] && ! [ -d "$BIN_DIR" ]; then
            echo -e "\nCreating 'bin' directory: "
            echo -en "$(mkdir "$BIN_DIR")"
            if [ -L "$BIN_DIR" ] || [ -d "$BIN_DIR" ]; then
                echo -e " ... [   ${GREEN}OK${NC}   ]"
            else
                quit 2 "Unable to create bin directory: $BIN_DIR"
            fi
        fi

        # Create all user custom files.
        [ -f "$HOME/.path" ] || touch "$HOME/.path"
        [ -f "$HOME/.aliases" ] || touch "$HOME/.aliases"
        [ -f "$HOME/.colors" ] || touch "$HOME/.colors"
        [ -f "$HOME/.env" ] || touch "$HOME/.env"
        [ -f "$HOME/.functions" ] || touch "$HOME/.functions"
        [ -f "$HOME/.profile" ] || touch "$HOME/.profile"
        [ -f "$HOME/.prompt" ] || touch "$HOME/.prompt"

        # Check the installation method.
        if [ -n "$HHS_VERSION" ] && [ -f "$HHS_HOME/.VERSION" ]; then
            METHOD='repair'
        elif [ -z "$HHS_VERSION" ] && [ -f "$HHS_HOME/.VERSION" ]; then
            METHOD='local'
        else
            METHOD='remote'
        fi

        case "$METHOD" in
        remote)
            clone_repository
            install_dotfiles
            activate_dotfiles
            ;;
        local | repair)
            install_dotfiles
            activate_dotfiles
            ;;
        *)
            quit 2 "Installation method is not valid: ${METHOD}"
            ;;
        esac
    }

    # Install all dotfiles.
    install_dotfiles() {

        echo -e ''
        echo -e '### Installation Settings ###'
        echo -e "${BLUE}"
        echo -e "    Home Setup: $HHS_HOME"
        echo -e "       Scripts: $BIN_DIR"
        echo -e "  Install Type: $METHOD"
        echo -e "       Options: ${OPT:-prompt}"
        echo -e "      Dotfiles: ${ALL_DOTFILES[*]}"
        echo -e "${NC}"

        if [ "${METHOD}" = 'repair' ] || [ "${METHOD}" = 'local' ]; then
            echo -e "${ORANGE}"
            [ -z ${QUIET} ] && read -r -n 1 -p "Your current .dotfiles will be replaced and your old files backed up. Continue y/[n] ?" ANS
            echo -e "${NC}"
            if [ "$ANS" = "y" ] || [ "$ANS" = "Y" ]; then
                [ -n "$ANS" ] && echo ''
                echo -e "${NC}Copying dotfiles into place ..."
                # Moving old hhs files into the proper directory
                [ -f "$HOME/.cmd_file" ] && mv -f "$HOME/.cmd_file" "$HHS_DIR/.cmd_file"
                [ -f "$HOME/.saved_dir" ] && mv -f "$HOME/.saved_dir" "$HHS_DIR/.saved_dirs"
                [ -f "$HOME/.punches" ] && mv -f "$HOME/.punches" "$HHS_DIR/.punches"
                [ -f "$HOME/.firebase" ] && mv -f "$HOME/.firebase" "$HHS_DIR/.firebase"
                # Removing the old $HOME/bin folder
                [ -L "$HOME/bin" ] || [ -d "$HOME/bin" ] && command rm -f "$HOME/bin"
            else
                [ -n "$ANS" ] && echo ''
                quit 1 "Installation cancelled!"
            fi
        else
            OPT='all'
        fi

        pushd "dotfiles" &>/dev/null || quit 1 "Unable to enter dotfiles directory => $(pwd)"

        # If `all' option is used, copy all files
        if [ "$OPT" = 'all' ]; then
            # Copy all dotfiles
            for next in ${ALL_DOTFILES[*]}; do
                dotfile="$HOME/.${next}"
                dotfile="${dotfile//hhs/bash}"
                # Backup existing dofile into $HOME/.hhs
                [ -f "$dotfile" ] && mv "$dotfile" "$HHS_DIR/$(basename "${dotfile}".orig)"
                echo -en "\n${WHITE}Linking: ${BLUE}"
                echo -en "$(ln -sfv "$HHS_HOME/dotfiles/${next}.bash" "$dotfile")"
                echo -en "${NC}"
                [ -f "$dotfile" ] && echo -e " ... [   ${GREEN}OK${NC}   ]"
                [ -f "$dotfile" ] || echo -e " ... [ ${GREEN}FAILED${NC} ]"
            done
        # If `all' option is NOT used, prompt for confirmation
        else
            # Copy all dotfiles
            for next in ${ALL_DOTFILES[*]}; do
                dotfile="$HOME/.${next}"
                dotfile="${dotfile//hhs/bash}"
                echo ''
                [ -z ${QUIET} ] && read -r -n 1 -sp "Link $dotfile (y/[n])? " ANS
                [ "$ANS" != 'y' ] && [ "$ANS" != 'Y' ] && continue
                echo ''
                # Backup existing dofile into $HOME/.hhs
                [ -f "$dotfile" ] && mv "$dotfile" "$HHS_DIR/$(basename "${dotfile}".orig)"
                echo -en "${WHITE}Linking: ${BLUE}"
                echo -en "$(ln -sfv "$HHS_HOME/dotfiles/${next}.bash" "$dotfile")"
                echo -en "${NC}"
                [ -f "$dotfile" ] && echo -e " ... [   ${GREEN}OK${NC}   ]"
                [ -f "$dotfile" ] || echo -e " ... [ ${GREEN}FAILED${NC} ]"
            done
        fi

        # Copy bin scripts into place
        command find "$HHS_HOME/bin/scripts" -type f \( -iname "**.bash" -o -iname "**.py" \) \
            -exec command ln -sfv {} "$BIN_DIR" \; \
            -exec command chmod 755 {} \; \
            &>/dev/null
        [ -L "$BIN_DIR/dotfiles.bash" ] || quit 2 "Unable to copy scripts into $BIN_DIR directory"

        # Install HomeSetup fonts
        [ -d "$HOME/Library/Fonts" ] && command cp "$HHS_HOME/misc/fonts"/*.otf "$HOME/Library/Fonts"

        popd &>/dev/null || quit 1 "Unable to leave dotfiles directory => $(pwd)"
    }

    # Clone the repository and install dotfiles.
    clone_repository() {

        [ -z "$(command -v git)" ] && quit 2 "You need git installed in order to install HomeSetup remotely"
        [ ! -d "$HHS_HOME" ] && quit 2 "Installation directory was not created: ${HHS_HOME}!"

        echo ''
        echo -e 'Cloning HomeSetup from repository ...'
        sleep 1
        command git clone "$REPO_URL" "$HHS_HOME"

        if [ -f "$HHS_HOME/dotfiles/hhs_colors.bash" ]; then
            \. "$HHS_HOME/dotfiles/hhs_colors.bash"
        else
            quit 2 "Unable to properly clone the repository!"
        fi
    }

    # Reload the bash and apply the dotfiles.
    activate_dotfiles() {

        sleep 2
        echo ''
        echo -e "${GREEN}Done installing HomeSetup files. Reloading bash ...${NC}"
        echo -e "${BLUE}"

        if command -v figlet >/dev/null; then
            figlet -f colossal -ck "Welcome"
        else
            echo 'ww      ww   eEEEEEEEEe   LL           cCCCCCCc    oOOOOOOo    mm      mm   eEEEEEEEEe'
            echo 'WW      WW   EE           LL          Cc          OO      Oo   MM M  M MM   EE        '
            echo 'WW  ww  WW   EEEEEEEE     LL          Cc          OO      OO   MM  mm  MM   EEEEEEEE  '
            echo 'WW W  W WW   EE           LL     ll   Cc          OO      Oo   MM      MM   EE        '
            echo 'ww      ww   eEEEEEEEEe   LLLLLLLll    cCCCCCCc    oOOOOOOo    mm      mm   eEEEEEEEEe'
            echo ''
        fi
        echo -e "${GREEN}${APPLE_ICN} Dotfiles v$(cat "$HHS_HOME/.VERSION") installed!"
        echo ''
        echo -e "${YELLOW}${STAR_ICN} To activate dotfiles type: #> ${GREEN}\. $HOME/.bashrc"
        echo -e "${YELLOW}${STAR_ICN} To check for updates type: #> ${GREEN}hhu"
        echo -e "${YELLOW}${STAR_ICN} To reload HomeSetup© type: #> ${GREEN}reload"
        echo -e "${YELLOW}${STAR_ICN} To customize your aliases definitions change the file: ${GREEN}$HOME/.aliasdef"
        echo ''
        echo -e "${YELLOW}${NOTE_ICN} Check ${BLUE}README.md${WHITE} for full details about your new Terminal"
        echo -e "${NC}"
        quit 0
    }

    clear
    check_inst_method "$@"

}
