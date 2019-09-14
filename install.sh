#!/usr/bin/env bash
# shellcheck disable=SC1117

#  Script: install.sh
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
        test -n "$2" -a "$2" != "" && printf "%s\n" "${2}"
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
        
        # Import bash colors
        [ -f bash_colors.sh ] && source bash_colors.sh
        printf "%s\n" "${GREEN}HomeSetup© ${YELLOW}v$(grep . "$HOME_SETUP"/.VERSION) installation ${NC}"

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
                    INSTALL_DIR="$1"
                ;;
                *)
                    quit 2 "Invalid option: \"$1\""
                ;;
            esac
            shift
        done

        # Dotfiles used by HomeSetup
        ALL_DOTFILES=(
            "bash_aliases"
            "bash_colors"
            "bash_env"
            "bash_functions"
            "bash_profile"
            "bash_prompt"
            "bashrc"
        )

        # Check for previous custom installation dir
        [ -z "$INSTALL_DIR" ] && INSTALL_DIR="$HOME/HomeSetup"

        # Create/Define the HomeSetup directory.
        HOME_SETUP=${HOME_SETUP:-$INSTALL_DIR}
        if [ ! -d "$HOME_SETUP" ]; then
            printf "\n%s" "Creating 'HomeSetup' directory: " && mkdir -p "$HOME_SETUP"
            [ -d "$HOME_SETUP" ] || quit 2 "Unable to create directory $HOME_SETUP"
        else
            touch "$HOME_SETUP/tmpfile" &>/dev/null || quit 2 "Installation directory is not valid: ${HOME_SETUP}"
            command rm -f "$HOME_SETUP/tmpfile" &>/dev/null
        fi

        # Create/Define the $HOME/.hhs directory
        HHS_DIR="${HHS_DIR:-$HOME/.hhs}"
        if [ ! -d "$HHS_DIR" ]; then
            printf "\n%s" "Creating '.hhs' directory: " && mkdir -p "$HHS_DIR"
            [ -d "$HHS_DIR" ] || quit 2 "Unable to create directory $HHS_DIR"
        else
            touch "$HHS_DIR/tmpfile" &>/dev/null || quit 2 "Unable to access the HomeSetup directory: ${HHS_DIR}"
            command rm -f "$HHS_DIR/tmpfile" &>/dev/null
        fi

        # Create/Define the $HOME/bin directory
        BIN_DIR="$HOME/bin"
        # Create or directory ~/bin if it does not exist
        if ! [ -L "$BIN_DIR" ] && ! [ -d "$BIN_DIR" ]; then
            printf "\n%s" "Creating 'bin' directory: " && mkdir "$BIN_DIR"
            if [ -L "$BIN_DIR" ] || [ -d "$BIN_DIR" ]; then
                printf "%s\n" "[   ${GREEN}OK${NC}   ]"
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
        if [ -n "$DOTFILES_VERSION" ] && [ -f "$HOME_SETUP/.VERSION" ]; then
            METHOD='repair'
        elif [ -z "$DOTFILES_VERSION" ] && [ -f "$HOME_SETUP/.VERSION" ]; then
            METHOD='local'
        elif [ -z "$DOTFILES_VERSION" ] && [ ! -f "$HOME_SETUP/.VERSION" ]; then
            METHOD='remote'
        else
            quit 2 "Unable to find an installation method!"
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
        printf "%s\n" "${BLUE}"
        echo -e "    Home Setup: $HOME_SETUP"
        echo -e "       Scripts: $BIN_DIR"
        echo -e "  Install Type: $METHOD"
        echo -e "       Options: ${OPT:-prompt}"
        echo -e "      Dotfiles: ${ALL_DOTFILES[*]}"
        printf "%s\n" "${NC}"

        if [ "${METHOD}" = 'repair' ] || [ "${METHOD}" = 'local' ]; then
            printf "%s\n" "${ORANGE}"
            [ -z ${QUIET} ] && read -r -n 1 -p "Your current .dotfiles will be replaced and your old files backed up. Continue y/[n] ?" ANS
            printf "%s\n" "${NC}"
            if [ "$ANS" = "y" ] || [ "$ANS" = "Y" ]; then
                [ -n "$ANS" ] && echo ''
                printf "%s\n" "${NC}Copying dotfiles into place ..."
                # Moving old hhs files into the proper directory
                [ -f "$HOME/.cmd_file" ] && mv -f "$HOME/.cmd_file" "$HHS_DIR/.cmd_file"
                [ -f "$HOME/.saved_dir" ] && mv -f "$HOME/.saved_dir" "$HHS_DIR/.saved_dirs"
                [ -f "$HOME/.punches" ] && mv -f "$HOME/.punches" "$HHS_DIR/.punches"
                [ -f "$HOME/.firebase" ] && mv -f "$HOME/.firebase" "$HHS_DIR/.firebase"
            else
                [ -n "$ANS" ] && echo ''
                quit 1 "Installation cancelled!"
            fi
        else
            OPT='all'
        fi

        # If `all' option is used, copy all files
        if [ "$OPT" = 'all' ]; then
            # Copy all dotfiles
            for next in ${ALL_DOTFILES[*]}; do
                dotfile=$HOME/.${next}
                # Backup existing dofile into $HOME/.hhs
                [ -f "$dotfile" ] && mv "$dotfile" "$HHS_DIR/$(basename "${dotfile}".orig)"
                printf "\n%s" "Linking: " && ln -sfv "$HOME_SETUP/${next}.sh" "$dotfile"
                [ -f "$dotfile" ] && printf "%s\n" "[   ${GREEN}OK${NC}   ]"
                [ -f "$dotfile" ] || printf "%s\n" "[ ${GREEN}FAILED${NC} ]"
            done
        # If `all' option is NOT used, prompt for confirmation
        else
            # Copy all dotfiles
            for next in ${ALL_DOTFILES[*]}; do
                dotfile=$HOME/.${next}
                echo ''
                [ -z ${QUIET} ] && read -r -n 1 -sp "Link $dotfile (y/[n])? " ANS
                [ "$ANS" != 'y' ] && [ "$ANS" != 'Y' ] && continue
                echo ''
                # Backup existing dofile into $HOME/.hhs
                [ -f "$dotfile" ] && mv "$dotfile" "$HHS_DIR/$(basename "${dotfile}".orig)"
                printf "%s" "Linking: " && ln -sfv "$HOME_SETUP/${next}.sh" "$dotfile"
                [ -f "$dotfile" ] && printf "%s\n" "[   ${GREEN}OK${NC}   ]"
                [ -f "$dotfile" ] || printf "%s\n" "[ ${GREEN}FAILED${NC} ]"
            done
        fi

        # Copy bin scripts into place
        command find "$HOME_SETUP/bin/scripts" -type f \( -iname "**.sh" -o -iname "**.py" \) \
            -exec command ln -sfv {} "$BIN_DIR" \; \
            -exec command chmod 755 {} \; \
            &>/dev/null
        [ -L "$BIN_DIR/dotfiles.sh" ] || quit 2 "Unable to copy scripts into $BIN_DIR directory"

        # Install HomeSetup fonts
        [ -d "$HOME/Library/Fonts" ] && command cp "$HOME_SETUP/misc/fonts"/*.otf "$HOME/Library/Fonts"
    }
    
    # Clone the repository and install dotfiles.
    clone_repository() {
        
        [ -z "$(command -v git)" ] && quit 2 "You need git installed in order to install HomeSetup remotely"
        [ ! -d "$HOME_SETUP" ] && quit 2 "Installation directory was not created: ${HOME_SETUP}!"

        echo ''
        printf "%s\n" 'Cloning HomeSetup from repository ...'
        sleep 1
        command git clone "$REPO_URL" "$HOME_SETUP"

        if [ -f "$HOME_SETUP/bash_colors.sh" ]; 
        then
            # shellcheck disable=SC1090
            source "$HOME_SETUP/bash_colors.sh"
        else
            quit 2 "Unable to properly clone the repository!"
        fi
    }

    # Reload the bash and apply the dotfiles.
    activate_dotfiles() {
        
        sleep 1
        echo ''
        printf "%s\n" "${GREEN}Done installing HomeSetup files. Reloading bash ...${NC}"
        printf "%s\n" "${BLUE}"

        if command -v figlet >/dev/null; 
        then
            figlet -f colossal -ck "Welcome"
        else
            echo 'ww      ww   eEEEEEEEEe   LL           cCCCCCCc    oOOOOOOo    mm      mm   eEEEEEEEEe'
            echo 'WW      WW   EE           LL          Cc          OO      Oo   MM M  M MM   EE        '
            echo 'WW  ww  WW   EEEEEEEE     LL          Cc          OO      OO   MM  mm  MM   EEEEEEEE  '
            echo 'WW W  W WW   EE           LL     ll   Cc          OO      Oo   MM      MM   EE        '
            echo 'ww      ww   eEEEEEEEEe   LLLLLLLll    cCCCCCCc    oOOOOOOo    mm      mm   eEEEEEEEEe'
            echo ''
        fi
        echo -e "${GREEN}${APPLE_ICN} Dotfiles v$(cat "$HOME_SETUP/.VERSION") installed!"
        echo ''
        echo -e "${YELLOW}${STAR_ICN} To activate dotfiles type: #> ${GREEN}source $HOME/.bashrc"
        echo -e "${YELLOW}${STAR_ICN} To check for updates type: #> ${GREEN}dv"
        echo -e "${YELLOW}${STAR_ICN} To reload HomeSetup© type: #> ${GREEN}reload"
        echo -e "${YELLOW}${NOTE_ICN} Check ${BLUE}README.md${WHITE} for full details about your new Terminal"
        echo -e "${NC}"
        quit 0
    }
    
    clear
    check_inst_method "$@"

}
