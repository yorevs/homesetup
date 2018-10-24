#!/usr/bin/env bash

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

    # Purpose: Quit the program and exhibits an exit message if specified.
    # @param $1 [Req] : The exit return code.
    # @param $2 [Opt] : The exit message to be displayed.
    quit() {

        unset -f quit usage check_inst_method copy_files clone_and_install activate_dotfiles

        test -n "$2" -o "$2" != "" && echo -e "$2"
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
        else
            export NC="\e[0m";
            export RED="\e[1;31m";
            export GREEN="\e[1;32m";
            export YELLOW="\e[1;33m";
            export CYAN="\e[1;36m";
            export WHITE="\e[1;37m";
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
        HOME_SETUP=${HOME_SETUP:-$INSTALL_DIR/HomeSetup}
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
        elif [ -z "$DOTFILES_VERSION" ] && [ ! -f "$HOME_SETUP/VERSION" ]; then
            METHOD='local'
        else
            METHOD='remote'
        fi
        
        echo "${BLUE}"
        echo '#'
        echo '# Install settings:'
        echo "# - HOME_SETUP: $HOME_SETUP"
        echo "# - OPTTIONS: $OPT"
        echo "# - METHOD: $METHOD"
        echo "# - FILES: ${ALL_DOTFILES[*]}"
        echo '#'
        echo "${YELLOW}"
        
        if [ "${METHOD}" = 'repair' ]; then
            copy_files
        elif [ "${METHOD}" = 'local' ] ; then
            copy_files
        else
            clone_and_install
        fi
    }
    
    # Copy the dotfiles.
    copy_files() {
        
        if [ "${METHOD}" = 'repair' ] || [ "${METHOD}" = 'local' ]; then
            read -r -n 1 -p "Your current .dotfiles will be replaced and your old files backed up. Continue y/[n] ?" ANS
            test -z "$ANS" -o "$ANS" = "n" -o "$ANS" = "N" && echo "${NC}" && quit 0
            echo ''
            echo "${NC}"
        else
            OPT='all'
        fi
        
        echo "Copying dotfiles into place ..."
        
        # If all option is used, do it at once
        if test "$OPT" = 'all' -o "$OPT" = 'ALL'; then
            if ! test -d ~/bin; then
                # Bin directory
                echo -n "Linking: " && ln -sfv "$HOME_SETUP/bin" ~/
                test -d ~/bin && echo -e '[   OK   ]'
            else
                cp -n "$HOME_SETUP"/bin/* ~/bin &>/dev/null
            fi

            # Bash dotfiles
            for next in ${ALL_DOTFILES[*]}; do
                dotfile=~/.${next}
                if test -f "$dotfile"; then test -h "$dotfile" || mv "$dotfile" "${dotfile}.bak"; fi
                echo -n "Linking: " && ln -sfv "$HOME_SETUP/${next}.sh" "$dotfile"
                test -f "$dotfile" && echo -e "${GREEN}[   OK   ]${NC}"
                test -f "$dotfile" || echo -e "${RED}[ FAILED ]${NC}"
            done
        else
            if ! test -d "$HOME_SETUP/bin"; then
                # Bin directory
                echo ''
                read -r -n 1 -sp 'Link  ~/bin folder (y/[n])? ' ANS
                test "$ANS" = 'y' -o "$ANS" = 'Y' && echo -en "$ANS \nLinking: " && ln -sfv "$HOME_SETUP/bin" ~/ && test -d ~/bin && echo '[ OK ]'
            else
                cp -n "$HOME_SETUP"/bin/* ~/bin &>/dev/null
            fi

            # Bash dotfiles
            for next in ${ALL_DOTFILES[*]}; do
                dotfile=~/.${next}
                echo ''
                read -r -n 1 -sp "Link $dotfile (y/[n])? " ANS
                test "$ANS" != 'y' -a "$ANS" != 'Y' && continue
                echo ''
                echo -n "Linking: " && ln -sfv "$HOME_SETUP/${next}.sh" "$dotfile"
                test -f "$dotfile" && echo -e "${GREEN}[   OK   ]${NC}"
                test -f "$dotfile" || echo -e "${RED}[ FAILED ]${NC}"
            done
        fi
        
        activate_dotfiles
    }
    
    clone_and_install() {
        
        command git clone "$REPO_URL" "$HOME_SETUP"
    }
    
    activate_dotfiles() {
        
        echo "${GREEN}Done installing files. Reloading bash ...${NC}"

        # Reload the shell to apply changes
        sleep 1
        reset

        echo "${CYAN}"
        echo 'ww      ww   eEEEEEEEEe   LL           cCCCCCCc    oOOOOOOo    mm      mm   eEEEEEEEEe'
        echo 'WW      WW   EE           LL          Cc          OO      Oo   MM M  M MM   EE        '
        echo 'WW  ww  WW   EEEEEEEE     LL          Cc          OO      OO   MM  mm  MM   EEEEEEEE  '
        echo 'WW W  W WW   EE           LL     ll   Cc          OO      Oo   MM      MM   EE        '
        echo 'ww      ww   eEEEEEEEEe   LLLLLLLll    cCCCCCCc    oOOOOOOo    mm      mm   eEEEEEEEEe'
        echo ''
        echo "${YELLOW}Dotfiles v$(cat "$HOME_SETUP/version") installed!"
        echo -n "${NC}"
        echo "${WHITE}"
        echo '? To reload settings type: #> reload'
        echo '? To check for updates type: #> dv'
        echo '? Read README.md for more details about HomeSetup'
        echo -n "${NC}"

        quit 0
    }

    check_inst_method "$@"
    
} # this ensures the entire script is downloaded #
