# HomeSetup User Handbook

**Thank you** for using HomeSetup. This is a handbook contains a collection of instructions intended to provide ready
reference for your new terminal features. We will cover all related aliases, applications and functions, as well as 
environment variables, configuration files and such.

## Table of contents

<!-- toc -->

- [Environment Variables](#environment-variables)
- [Aliases](#aliases) 
- [Functions](#functions) 
- [Applications](#applications) 

<!-- tocstop -->

## Environment Variables

Your new terminal uses a bunch of environment variables, that will be extended by HomeSetup using the 
[bash_envs.bash](../dotfiles/bash/bash_env.bash). You can add or override the default definitions by
adding them to an **~/.env** file.

    - HHS_HOME : This is where HomeSetup was installed.
    - HHS_DIR : This is where HomeSetup stores it's configuration files.
    - HHS_VERSION : Currently installed HomeSetup version.
    - HHS_MOTD : Message of the day, to be displayed when HomeSetup is loaded.
    - HHS_SAVED_DIRS_FILE : This file holds the saved directories issued by __hhs_save_dir function.
    - HHS_CMD_FILE : This file holds the saved commands issued by __hhs_command function.
    - HHS_PATHS_FILE : This file holds the adittional PATH's to be added to your shell, and used by __hhs_paths function.
    - HHS_DEFAULT_EDITOR : This is the default editor used by all functions or apps that require text editting.
    - HHS_MENU_MAXROWS : This is used by __hhs_mselect and  __hhs_mchoose to set the maximum amount of items to be displayed.
    - HHS_PUNCH_FILE : This file holds the saved punches issued by __hhs_punch function.
    - HHS_VAULT_FILE : This file holds the user vault, used to store secure information.
    - HHS_VAULT_USER : This is the user that hhs vault plugin will use to store your vault data.

## Aliases

## Functions

## Applications
