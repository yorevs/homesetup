# HomeSetup User Handbook

**Thank you** for using HomeSetup. This is a handbook contains a collection of instructions intended to provide ready
reference for your new terminal features. We will cover all related aliases, applications and functions, as well as 
environment variables, configuration files and such.

## Table of contents

<!-- toc -->

- [Environment variables](#environment-variables)
- [Aliases](#aliases) 
- [Functions](#functions) 
- [Applications](#applications) 
- [Templates](#templates) 

<!-- tocstop -->

## Environment Variables

Your new terminal uses a bunch of environment variables, that will be extended by HomeSetup using the 
[bash_envs.bash](../dotfiles/bash/bash_env.bash).

You can override or add additional variables by adding entries to your installed **~/.env** file. When you first 
install HomeSetup this file will be created automatically for you, so you just need to edit it.

- HHS_MY_OS : Your OS name.
- HHS_MY_SHELL : Your login shell name.
- HHS_TERM_OPTS : Active terminal options.
- HHS_HOME : HomeSetup installation directory.
- HHS_DIR : This is where HomeSetup stores it's configuration files.
- HHS_VERSION : Currently installed HomeSetup version.
- HHS_BASH_COMPLETIONS : Bash-completions that are actually active.
- HHS_MOTD : Message of the day, to be displayed when HomeSetup is loaded.
- HHS_DEFAULT_EDITOR : This is the default editor used by all functions or apps that require text editting.
- HHS_SAVED_DIRS_FILE : This file holds the saved directories issued by __hhs_save_dir function.
- HHS_CMD_FILE : This file holds the saved commands issued by __hhs_command function.
- HHS_PATHS_FILE : This file holds the adittional PATH's to be added to your shell, and used by __hhs_paths function.
- HHS_PUNCH_FILE : This file holds the saved punches issued by __hhs_punch function.
- HHS_VAULT_FILE : This file holds the user vault, used to store secure information.
- HHS_VAULT_USER : This is the user that hhs vault plugin will use to store your vault data.
- HHS_MENU_MAXROWS : This is used by __hhs_mselect and  __hhs_mchoose to set the maximum amount of items to be displayed.
- HHS_HIGHLIGHT_COLOR : Color to use to highlight text on some functions.
- HHS_DEV_TOOLS : Tools that HomeSetup will keep an eye on, to check is they are installed or not.

## Aliases

HomeSetup defines some [aliases](../README.md#aliases) that can be used to ease common tasks and commands. We provide many functions tha are 
also aliased, but those can be customised using the installed **~/.aliasdef** file. You can customize most of HomeSetup 
aliases by editing this file. 

When you first install HomeSetup, the file will be automatically generated for you. Further updates may require this 
file to be updated. We always keep a backup of this file, so, you can preserve your customizations, but this process has 
to be manual. The original content is defined on the original [aliasdef](../dotfiles/aliasdef) file.

You can override or add additional aliases by adding entries to your installed **~/.aliases** file. When you first 
install HomeSetup this file will be created automatically for you, so you just need to edit it.

### Categories

We group our aliases using the following categories:

- [Navigational](../README.md#navigational)
- [General](../README.md#general)
- [HomeSetup](../README.md#homesetup)
- [Tool aliases](../README.md#tool-aliases)
- [OS Specific aliases](../README.md#os-specific-aliases)
- [Handy Terminal Shortcuts](../README.md#handy-terminal-shortcuts)
- [Python aliases](../README.md#python-aliases)
- [Perl aliases](../README.md#perl-aliases)
- [Git aliases](../README.md#git-aliases)
- [Gradle aliases](../README.md#gradle-aliases)
- [Docker aliases](../README.md#docker-aliases)

## Functions

HomeSetup defines a bunch of [functions](../README.md#functions) to help with the daily tasks such as "punch the clock", 
calculations with time, search and cd into directories, save most used directories, aliases and commands, git stuff and more. 
They can also be aliased using the **~/.aliasdef** file. We also define some default values for them (that you can also change later).

You can override or add additional variables by adding entries to your installed **~/.functions** file. When you first 
install HomeSetup this file will be created automatically for you, so you just need to edit it.

Functions are grouped into two categories:

- [Standard tools](../README.md#standard-tools)
- [Development tools](../README.md#development-tools)

Checkout the full handbook of [functions here](FUNCTIONS.md).

## Applications

In addition to aliases and functions, HomeSetup also puts available some [applications](../README.md#applications)
with different purposes, such as IP information verification, fetch REST services, and more. Currently we are using two
kinds of applications:

- [Bash applications](../README.md#bash-apps)
- [Python applications](../README.md#python-apps)

Checkout the full handbook of [applications here](APPLICATIONS.md).

## Templates

Currently HomeSetup offers a handful of templates, that helps you code or configure your git like we do. The following
are provided with the latest version:

- [Bash templates](../templates/bash)
    * [app.bash](../templates/bash/app.bash) : Create bash applications using our style.
- [Git templates](../templates/git)
    * [commits](../templates/git/commits) : HomeSetup commit messages format.
    * [gitconfig](../templates/git/gitconfig) : .gitconfig file template.
    * [gitignore](../templates/git/gitignore) : .gitignore file template.
    * [commit-msg](../templates/git/hooks/commit-msg) : Git hook to make sure your commit message is following our format.
    * [prepare-commit-msg](../templates/git/hooks/prepare-commit-msg) : Make sure no one commits on master.
- [Python templates](../templates/py)
    * [app.py](../templates/py/app.py) : Create python applications using our style.
- [Text templates](../templates/txt)
    * [help.txt](../templates/txt/help.txt) : Template used to create HomeSetup help messages.
    * [man.txt](../templates/txt/man.txt) : Template used to create bash man pages.

