#!/usr/bin/env bash
# shellcheck disable=SC1117

{ # this ensures the entire script is downloaded #

    #  Script: install.sh
    # Purpose: Install and configure all dofiles
    # Created: Aug 26, 2008
    #  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
    #  Mailto: yorevs@gmail.com
    #    Site: https://github.com/yorevs/homesetup

    # This script name.
    PROC_NAME=$(basename "$0")

    # Help message to be displayed by the script.
    USAGE="
Usage: $PROC_NAME [-a | --all] [-d | --dir <home_setup_dir>]

    *** [all]: Install all scripts into the user HomeSetup folder.
"
    
    # GitHub repository URL.
    REPO_URL='https://github.com/yorevs/homesetup.git'

    # GitHub online install command.
    export INSTALL_CMD='curl -o- https://raw.githubusercontent.com/yorevs/homesetup/master/install.sh | bash'

    # Purpose: Quit the program and exhibits an exit message if specified.
    # @param $1 [Req] : The exit return code.
    # @param $2 [Opt] : The exit message to be displayed.
    quit() {

        unset -f quit usage check_inst_method install_dotfiles clone_repository activate_dotfiles

        test -n "$2" -o "$2" != "" && printf "%s\n" "${2}"
        echo ''
        exit "$1"
    }

    # Usage message.
    usage() {
        quit 1 "$USAGE"
    }

    # Check which installation method should be used.
    check_inst_method() {
        
        clear

        # shellcheck disable=SC1091
        if [ -f bash_colors.sh ]; 
        then 
            source bash_colors.sh
        fi

        # Check if the user passed the help parameters.
        test "$1" = '-h' -o "$1" = '--help' && usage

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
                quit 1 "Invalid option: \"$1\""
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

        test -z "$INSTALL_DIR" && INSTALL_DIR=$(pwd)

        # Define the HomeSetup folder.
        HOME_SETUP=${HOME_SETUP:-${INSTALL_DIR/HomeSetup/}/HomeSetup}
        if [ -d "$INSTALL_DIR" ]; then
            touch tmpfile
            test "$?" -eq 0 || quit 1 "${RED}Unable to access the installation directory: ${INSTALL_DIR}${NC}"
            rm -f tmpfile
        else
            quit 1 "${RED}Installation directory is not valid: ${INSTALL_DIR}${NC}"
        fi
        
        # Check the installation method.
        if [ -n "$DOTFILES_VERSION" ] && [ -f "$HOME_SETUP/VERSION" ]; then
            METHOD='repair'
        elif [ -z "$DOTFILES_VERSION" ] && [ -f "$HOME_SETUP/VERSION" ]; then
            METHOD='local'
        elif [ -z "$DOTFILES_VERSION" ] && [ ! -f "$HOME_SETUP/VERSION" ]; then
            METHOD='remote'
        else
            quit 1 "${RED}Unable to find an installation method!${NC}"
        fi
        
        printf "%s\n" "${BLUE}"
        echo '#'
        echo '# Install settings:'
        echo "# - HOME_SETUP: $HOME_SETUP"
        echo "# - OPTTIONS: $OPT"
        echo "# - METHOD: $METHOD"
        echo "# - FILES: ${ALL_DOTFILES[*]}"
        printf "%s\n" "#${NC}"
        
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
            quit 1 "${RED}Installation method is not valid: ${METHOD}${NC}"
        fi
    }
    
    # Install all dotfiles.
    install_dotfiles() {
        
        if [ "${METHOD}" = 'repair' ] || [ "${METHOD}" = 'local' ]; then
            printf "%s\n" "${RED}"
            read -r -n 1 -p "Your current .dotfiles will be replaced and your old files backed up. Continue y/[n] ?" ANS
            if [ -z "$ANS" ] || [ "$ANS" = "n" ] || [ "$ANS" = "N" ]; then
                echo ''
                test -n "$ANS" && echo ''
                quit 0 "${NC}Installation cancelled!"
            else
                echo ''
                echo ''
                printf "%s\n" "${NC}Copying dotfiles into place ..."
            fi
            printf "%s\n" "${NC}"
        else
            OPT='all'
        fi
        
        # If all option is used, copy all files
        if test "$OPT" = 'all' -o "$OPT" = 'ALL'; then
            # Bin folder
            if ! test -d ~/bin; then
                echo -n "Linking: " && ln -sfv "$HOME_SETUP/bin" ~/
                test -d ~/bin && printf "%s\n" '[   OK   ]'
            else
                cp -n "$HOME_SETUP"/bin/* ~/bin &>/dev/null
            fi

            # Copy all dotfiles
            for next in ${ALL_DOTFILES[*]}; do
                dotfile=~/.${next}
                if test -f "$dotfile"; then test -h "$dotfile" || mv "$dotfile" "${dotfile}.bak"; fi
                echo -n "Linking: " && ln -sfv "$HOME_SETUP/${next}.sh" "$dotfile"
                test -f "$dotfile" && printf "%s\n" "${GREEN}[   OK   ]${NC}"
                test -f "$dotfile" || printf "%s\n" "${RED}[ FAILED ]${NC}"
            done
        else
            # Bin folder
            if ! test -d ~/bin; then
                echo ''
                read -r -n 1 -sp 'Link  ~/bin folder (y/[n])? ' ANS
                test "$ANS" = 'y' -o "$ANS" = 'Y' && echo -en "$ANS \nLinking: " && ln -sfv "$HOME_SETUP/bin" ~/ && test -d ~/bin && echo '[ OK ]'
            else
                cp -n "$HOME_SETUP"/bin/* ~/bin &>/dev/null
            fi

            # Copy all dotfiles
            for next in ${ALL_DOTFILES[*]}; do
                dotfile=~/.${next}
                echo ''
                read -r -n 1 -sp "Link $dotfile (y/[n])? " ANS
                test "$ANS" != 'y' -a "$ANS" != 'Y' && continue
                echo ''
                echo -n "Linking: " && ln -sfv "$HOME_SETUP/${next}.sh" "$dotfile"
                test -f "$dotfile" && printf "%s\n" "${GREEN}[   OK   ]${NC}"
                test -f "$dotfile" || printf "%s\n" "${RED}[ FAILED ]${NC}"
            done
        fi

        echo ''
    }
    
    # Clone the repository and install dotfiles.
    clone_repository() {
        
        echo ''
        printf "%s\n" "${NC}Cloning HomeSetup from repository ..."
        sleep 1
        command git clone "$REPO_URL" "$HOME_SETUP"
        # shellcheck disable=SC1091
        if [ -f "$HOME_SETUP/bash_colors.sh" ]; 
        then 
            source "$HOME_SETUP/bash_colors.sh"
        fi
    }

    # Reload the bash and apply the dotfiles.
    activate_dotfiles() {
        
        sleep 1
        echo ''
        printf "%s\n" "${GREEN}Done installing files. Reloading bash ...${NC}"

        printf "%s\n" "${CYAN}"
        echo 'ww      ww   eEEEEEEEEe   LL           cCCCCCCc    oOOOOOOo    mm      mm   eEEEEEEEEe'
        echo 'WW      WW   EE           LL          Cc          OO      Oo   MM M  M MM   EE        '
        echo 'WW  ww  WW   EEEEEEEE     LL          Cc          OO      OO   MM  mm  MM   EEEEEEEE  '
        echo 'WW W  W WW   EE           LL     ll   Cc          OO      Oo   MM      MM   EE        '
        echo 'ww      ww   eEEEEEEEEe   LLLLLLLll    cCCCCCCc    oOOOOOOo    mm      mm   eEEEEEEEEe'
        echo ''
        printf "%s\n" "${YELLOW}Dotfiles v$(cat "$HOME_SETUP/version") installed!"
        printf "%s\n" "${WHITE}"
        printf "%s\n" "? To activate dotfiles type: #> ${GREEN}source ~/.bashrc${NC}"
        printf "%s\n" "? To reload settings type: #> ${GREEN}reload${NC}"
        printf "%s\n" "? To check for updates type: #> ${GREEN}dv${NC}"
        echo '? Check README.md for full details about your new HomeSetup'
        printf "%s\n" "${NC}"

        quit 0
    }
    
    check_inst_method "$@"

} # this ensures the entire script is downloaded #
