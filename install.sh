#!/usr/bin/env bash
# shellcheck disable=SC1117

#  Script: install.sh
# Purpose: Install and configure HomeSetup
# Created: Aug 26, 2018
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs/homesetup

{

    # This script name.
    PROC_NAME=$(basename "$0")

    # Help message to be displayed by the script.
    USAGE="
Usage: $PROC_NAME [-a | --all] [-d | --dir <home_setup_dir>]

    *** [all]: Install all scripts into the user HomeSetup folder.
"

    # GitHub repository URL.
    REPO_URL='https://github.com/yorevs/homesetup.git'

    # Purpose: Quit the program and exhibits an exit message if specified.
    # @param $1 [Req] : The exit return code.
    # @param $2 [Opt] : The exit message to be displayed.
    quit() {
        
        # Unset all declared functions
        unset -f quit usage version check_inst_method install_dotfiles clone_repository activate_dotfiles

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

    # Check which installation method should be used.
    check_inst_method() {
        
        clear

        # shellcheck disable=SC1091
        [ -f bash_colors.sh ] && source bash_colors.sh

        # Check if the user passed the help or version parameters.
        test "$1" = '-h' -o "$1" = '--help' && usage
        test "$1" = '-v' -o "$1" = '--version' && version

        # Loop through the command line options.
        # Short opts: -w, Long opts: --Word
        while test -n "$1"; do
            case "$1" in
            -a | --all)
                OPT="all"
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
            "bashrc"
            "bash_profile"
            "bash_aliases"
            "bash_prompt"
            "bash_env"
            "bash_colors"
            "bash_functions"
        )

        test -z "$INSTALL_DIR" && INSTALL_DIR=$HOME

        # Define the HomeSetup folder.
        HOME_SETUP=${HOME_SETUP:-$INSTALL_DIR/HomeSetup/}
        if [ -d "$INSTALL_DIR" ]; then
            touch "$INSTALL_DIR/tmpfile"
            test "$?" -eq 0 || quit 2 "Unable to access the installation directory: ${INSTALL_DIR}"
            rm -f "$INSTALL_DIR/tmpfile"
        else
            quit 2 "Installation directory is not valid: ${INSTALL_DIR}"
        fi

        # Create the $HOME/.hhs folder
        HHS_DIR="${HHS_DIR:-$HOME/.hhs}"
        if [ ! -d "$HHS_DIR" ]; then
            mkdir -p "$HHS_DIR"
            test -d "$HHS_DIR" || quit 2 "Unable to create directory $HOME/.hhs"
        else
            touch "$HHS_DIR/tmpfile"
            test "$?" -eq 0 || quit 2 "Unable to access the $HOME/.hhs directory: ${HHS_DIR}"
            rm -f "$HHS_DIR/tmpfile"
        fi
        
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
        
        if [ "${METHOD}" = 'repair' ]; then
            install_dotfiles
        elif [ "${METHOD}" = 'local' ] ; then
            install_dotfiles
            activate_dotfiles
        elif [ "${METHOD}" = 'remote' ] ; then
            clone_repository
            install_dotfiles
            activate_dotfiles
        else
            quit 2 "Installation method is not valid: ${METHOD}"
        fi
    }
    
    # Install all dotfiles.
    install_dotfiles() {
        
        printf "%s\n" "${BLUE}"
        echo '#'
        echo '# Install settings:'
        echo "# - HOME_SETUP: $HOME_SETUP"
        echo "# - OPTTIONS: $OPT"
        echo "# - METHOD: $METHOD"
        echo "# - FILES: ${ALL_DOTFILES[*]}"
        printf "%s\n" "#${NC}"

        if [ "${METHOD}" = 'repair' ] || [ "${METHOD}" = 'local' ]; then
            printf "%s\n" "${RED}"
            read -r -n 1 -p "Your current .dotfiles will be replaced and your old files backed up. Continue y/[n] ?" ANS
            printf "%s\n" "${NC}"
            if [ "$ANS" = "y" ] || [ "$ANS" = "Y" ]; then
                test -n "$ANS" && echo ''
                printf "%s\n" "${NC}Copying dotfiles into place ..."
                # Moving old hhs files into the proper folder
                test -f "$HOME/.cmd_file" && mv -f "$HOME/.cmd_file" "$HHS_DIR/.cmd_file"
                test -f "$HOME/.saved_dir" && mv -f "$HOME/.saved_dir" "$HHS_DIR/.saved_dirs"
                test -f "$HOME/.punchs" && mv -f "$HOME/.punchs" "$HHS_DIR/.punchs"
                test -f "$HOME/.firebase" && mv -f "$HOME/.firebase" "$HHS_DIR/.firebase"
            else
                test -n "$ANS" && echo ''
                quit 1 "Installation cancelled!"
            fi
        else
            OPT='all'
        fi

        # If all option is used, copy all files
        if test "$OPT" = 'all' -o "$OPT" = 'ALL'; then
            # Bin folder
            if ! test -d "$HOME/bin"; then
                echo -n "Linking: "
                ln -sfv "$HOME_SETUP/bin" "$HOME"
                if [ -d "$HOME/bin" ]; then
                    echo '[  OK  ]'
                else
                    quit 2 "Unable to link bin folder into $HOME !"
                fi
            else
                cp -nf "$HOME_SETUP"/bin/* "$HOME/bin" &>/dev/null
                test -f "$HOME/bin/dotfiles.sh" || quit 2 "Unable to copy scripts into $HOME/bin directory!"
            fi

            # Copy all dotfiles
            for next in ${ALL_DOTFILES[*]}; do
                dotfile=$HOME/.${next}
                # Backup existing dofile into $HOME/.hhs
                [ -f "$dotfile" ] && mv "$dotfile" "$HHS_DIR/$(basename "${dotfile}".orig)"
                echo -n "Linking: " && ln -sfv "$HOME_SETUP/${next}.sh" "$dotfile"
                test -f "$dotfile" && printf "%s\n" "${GREEN}[   OK   ]${NC}"
                test -f "$dotfile" || printf "%s\n" "${RED}[ FAILED ]${NC}"
            done
        else
            # Bin folder
            if ! test -d "$HOME/bin"; then
                echo ''
                read -r -n 1 -sp "Link  $HOME/bin folder (y/[n])? " ANS
                if [ "$ANS" = 'y' ] || [ "$ANS" = 'Y' ]; then
                    echo -en "$ANS \nLinking: "
                    ln -sfv "$HOME_SETUP/bin" "$HOME" 
                    if [ -d "$HOME/bin" ]; then
                        echo '[  OK  ]'
                    else
                        quit 2 "Unable to link bin folder into $HOME !"
                    fi
                fi
            else
                cp -nf "$HOME_SETUP"/bin/* "$HOME/bin" &>/dev/null
                test -f "$HOME/bin/dotfiles.sh" || quit 2 "Unable to copy scripts into $HOME/bin directory!"
            fi

            # Copy all dotfiles
            for next in ${ALL_DOTFILES[*]}; do
                dotfile=$HOME/.${next}
                echo ''
                read -r -n 1 -sp "Link $dotfile (y/[n])? " ANS
                test "$ANS" != 'y' -a "$ANS" != 'Y' && continue
                echo ''
                # Backup existing dofile into $HOME/.hhs
                [ -f "$dotfile" ] && mv "$dotfile" "$HHS_DIR/$(basename "${dotfile}".orig)"
                echo -n "Linking: " && ln -sfv "$HOME_SETUP/${next}.sh" "$dotfile"
                test -f "$dotfile" && printf "%s\n" "${GREEN}[   OK   ]${NC}"
                test -f "$dotfile" || printf "%s\n" "${RED}[ FAILED ]${NC}"
            done
        fi

        echo ''
    }
    
    # Clone the repository and install dotfiles.
    clone_repository() {
        
        test -z "$(command -v git)" && quit 2 "You need git installed in order to install HomeSetup remotely!"
        test -d "$HOME_SETUP" && quit 2 "Installation directory already exists and can't be overriden: ${HOME_SETUP}!"

        echo ''
        printf "%s\n" "${NC}Cloning HomeSetup from repository ..."
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
        printf "%s\n" "${GREEN}Done installing files. Reloading bash ...${NC}"

        printf "%s\n" "${CYAN}"
        if command -v figlet >/dev/null; 
        then
            figlet -c "Welcome"
        else
            echo 'ww      ww   eEEEEEEEEe   LL           cCCCCCCc    oOOOOOOo    mm      mm   eEEEEEEEEe'
            echo 'WW      WW   EE           LL          Cc          OO      Oo   MM M  M MM   EE        '
            echo 'WW  ww  WW   EEEEEEEE     LL          Cc          OO      OO   MM  mm  MM   EEEEEEEE  '
            echo 'WW W  W WW   EE           LL     ll   Cc          OO      Oo   MM      MM   EE        '
            echo 'ww      ww   eEEEEEEEEe   LLLLLLLll    cCCCCCCc    oOOOOOOo    mm      mm   eEEEEEEEEe'
        fi
        echo ''
        printf "%s\n" "${YELLOW}Dotfiles v$(cat "$HOME_SETUP/.VERSION") installed!"
        printf "%s\n" "${WHITE}"
        printf "%s\n" "? To activate dotfiles type: #> ${GREEN}source $HOME/.bashrc${NC}"
        printf "%s\n" "? To reload settings type: #> ${GREEN}reload${NC}"
        printf "%s\n" "? To check for updates type: #> ${GREEN}dv${NC}"
        echo '? Check README.md for full details about your new HomeSetup'
        printf "%s\n" "${NC}"

        quit 0
    }
    
    check_inst_method "$@"

}
