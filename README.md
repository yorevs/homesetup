# HomeSetup

## Your shell, good as hell ! 

[![Tests](images/tests-badge.svg)](images/tests-badge.svg)
[![License](https://badgen.net/badge/license/MIT/gray)](LICENSE.md)
[![Release](https://badgen.net/badge/release/v1.4.013/gray)](docs/CHANGELOG.md#unreleased)
[![Terminal](https://badgen.net/badge/icon/terminal?icon=terminal&label)](https://github.com/yorevs/homesetup)
[![Gitter](https://badgen.net/badge/icon/gitter?icon=gitter&label)](https://gitter.im/yorevs-homesetup/community?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)
[![Donate](https://badgen.net/badge/paypal/donate/yellow)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=J5CDEFLF6M3H4)

HomeSetup is a bundle of scripts and dotfiles that will elevate your bash shell experience to another level. There are 
many improvements and facilities, especially for developers that will ease the usage and highly improve your productivity. 
Currently we support **Bash** (v3.4+) for **Darwin** (MacOS) and **Linux**. We have plans to add support for _Zsh_ as well.

**THIS IT NOT JUST ANOTHER DOTFILES FRAMEWORK**

**LINUX IS HERE**

## Highlights

HomeSetup was created to help users with the command line. The purpose was to create useful and easy-to-use features 
that speedup daily tasks such as, punching the clock, searching for strings and files, change directories, using git, 
gradle, docker, etc...

- Setup most common used configurations automatically.
- New <tab+shift> complete (using menu-complete) that will cycle though options.
- Prompt with a mono-spaced font that supports [Font-Awesome](https://fontawesome.com/cheatsheet?from=io) icons.
- Package manager helper to help installing application using recipes (**not only brew installs**).
- Save your custom dotfiles on a [Firebase](https://console.firebase.google.com) and download it wherever you go.
- New visual way to **select**, **choose** and **input** data for your scripts (pure bash code).
- Dozens of functions to help you configure your terminal and deal with your daily tasks.
- Highly customizable aliases, so, you dictate what mnemonics you want to use (use your own syntax).
- All code is licensed under [The MIT License](LICENSE.md), so, you can modify and use freely.
- Small learning curve and a complete [User's Handbook](docs/handbook/USER_HANDBOOK.md).
- **NEW** HomeSetup now works on Linux as well.
- **NEW** Try HomeSetup on a docker container before installing on your machine.

## Catalina moved from bash to zsh

Latest version of MacOS comes with **zsh** as the _default shell_, but you can change it at any time with the following command:

```bash
$ sudo chsh -s /bin/bash
```

If apple decides to remove from next MacOS releases, you can always use Home-Brew's version. In this case, the path is 
different:

```bash
$ brew install bash
$ sudo chsh -s /usr/local/bin/bash
```

## Table of contents

<!-- toc -->

- [1. Installation](#installation)
  * [1.1. Requirements](#requirements)
    + [1.1.1. Operating systems](#operating-systems)
    + [1.1.1. Supported Shells](#supported-shells)
    + [1.1.2. Required software](#required-software)
      - [1.1.2.1. Darwin and Linux](#darwin-and-linux)
      - [1.1.2.2. Darwin only](#darwin-only)
    + [1.1.3. Recommended software](#recommended-software)
    + [1.1.4. Optional software](#optional-software)
    + [1.1.5. Terminal setup](#terminal-setup)
      + [1.1.5.1. Terminal App](#terminal-app-darwin)
      + [1.1.5.2. iTerm2 App](#iterm2-app-darwin)
  * [1.1. Try-it first](#try-it-first)
  * [1.2. Remote installation](#remote-installation)
  * [1.3. Local installation](#local-installation)
  * [1.4. Firebase setup](#firebase-setup)
    + [1.4.1. Create account](#create-new-account)
    + [1.4.2. Configure account](#configure-account)
- [2. Uninstallation](#uninstallation)
- [3. Usage](#usage)
- [4. Dotfiles in this project](#dotfiles-in-this-project)
- [5. Aliases](#aliases)
  * [5.1. Navigational](#navigational)
  * [5.2. General](#general)
  * [5.3. HomeSetup](#homesetup)
  * [5.4. Tool aliases](#tool-aliases)
  * [5.5. OS Specific aliases](#os-specific-aliases)
    + [5.5.1. Linux](#linux)
    + [5.5.2. Darwin](#darwin)
  * [5.6. Handy terminal shortcuts](#handy-terminal-shortcuts)
  * [5.7. Python aliases](#python-aliases)
  * [5.8. Perl aliases](#perl-aliases)
  * [5.9. Git aliases](#git-aliases)
  * [5.10. Gradle aliases](#gradle-aliases)
  * [5.11. Docker aliases](#docker-aliases)
- [6. Functions](#functions)
  * [6.1. Standard tools](#standard-tools)
  * [6.2. Development tools](#development-tools)
- [7. Applications](#applications)
  * [7.1. Bash apps](#bash-apps)
  * [7.2. Python apps](#python-apps)
- [8. Alias Definitions](#alias-definitions)
- [9. HomeSetup application](#homesetup-application)
  * [9.1. Plug-ins](#hhs-plugins)
  * [9.2. Functions](#hhs-functions)
- [10. Auto completions](#auto-completions)
  * [10.1. Bash completions](#bash-completions)
- [12. Contact](#contact)
- [13. Support HomeSetup](#support-homesetup)
- [14. Final notes](#final-notes)

<!-- tocstop -->

## Installation

### Requirements

#### Operating Systems

- Darwin 
    + High Sierra and higher
- Linux 
    + Ubuntu 16 and higher
    + CentOS 7 and higher
    + Fedora 31 and higher

You may want to install HomeSetup on other linux distributions and it will probably work, but there are no guarantees 
that it **WILL ACTUALLY WORK** .

#### Supported Shells

- Bash: Everything from 3.2.57(1) and higher.
- Zsh: Zsh is not supported yet.

#### Required software

The following software are required either to clone the repository, execute the tests and install packages:

###### Darwin and Linux

- **git** v2.20+ : To clone and maintain the code.
- **curl** v7.64+ : To make http(s) requests.
- **python** v2.7+ or v3.0+ : To run python based scripts.
- **gpg** v2.2+: : To enable encryption based functions.

##### Darwin only

- **brew** v2.0+ : To install the required tools.
- **xcode-select** v2373+: To install command line tools.

#### Recommended software

HomeSetup depends on a series of tools. To use some of the features of HomeSetup, the following packages are required:

- **bats** v0.4+ : To run the automated tests.
- **perl** v5.0+ : To enable perl based functions.
- **dig** v9.10+ : To enable networking functions.
- **tree** v1.8+ : To enable directory visualization functions.
- **ifconfig** v8.43+ : To enable networking functions.

#### Optional software

There are some tools that are also good to have if you are a developer, HomeSetup provides features to improve using
the following tools:

- **docker** 19.03+ : To enable docker functions.
- **gradle** 4+ : To enable gradle functions.

#### Terminal setup

HomeSetup requires a font that supports Font-Awesome icons. We suggest you to use the one we provide:

* [Droid font](misc/fonts/Droid-Sans-Mono-for-Powerline-Nerd-Font-Complete.otf).

You need to install it on your machine before installing or trying HomeSetup, otherwise, you will see a question mark icon instead of the real icons.

**Mac users**: We suggest a terminal profile to use (see the below topics).

**Linux users**: We have checked that some terminals already support icons, if not, you can install it manually.

##### Terminal App (Darwin)

* Import the HomeSetup-(14|15)-inch.terminal from "$HHS_HOME/misc" to your Terminal App.
* Set HomeSetup as the default profile.

##### iTerm2 App (Darwin)

* Import the iterm2-terminal-(14|15)-inch.json from "$HHS_HOME/misc" to your iTerm2 App.
* Set HomeSetup as the default profile.

### Try-it first

You can run HomeSetup from a docker container and then decide whether to install it on your machine. To do that, you need to pull the image you want to try:

`$ docker run --rm -it yorevs/hhs-centos`

or

`$ docker run --rm -it yorevs/hhs-ubuntu`

or

`$ docker run --rm -it yorevs/hhs-fedora`

### Remote installation

_This is the recommended installation type_. You can install HomeSetup directly from GitHub. To do that use the following command to clone and install:

`$ curl -o- https://raw.githubusercontent.com/yorevs/homesetup/master/install.bash | bash`

or

`$ wget -qO- https://raw.githubusercontent.com/yorevs/homesetup/master/install.bash | bash`

### Local installation

Clone the repository using the following command:

`$ git clone https://github.com/yorevs/homesetup.git ~/HomeSetup`

And then install dotfiles using the following command:

`$ cd ~/HomeSetup && ./install.bash` => **To install all files**

or

`$ cd ~/HomeSetup && ./install.bash -i` => **To install one by one**

Your old dotfiles (.bash*) will be backed up using '.orig' suffix and sent to ~/.hhs folder.

### Firebase setup

HomeSetup allows you to use your Firebase account to upload and download your custom files
(dotfiles files synchronization) to your *Real-time Database*. To be able to use this feature, you need first 
to configure your Google Firebase account.

#### Create new account

If you have a Google account but do not have a Firebase one, you can do that using your Google credentials.

Access: https://console.firebase.google.com/

1. Create a *new Project* (HomeSetup).
2. Create Database (as **production mode**).
    * Click on Develop -> Database -> Create Database
    * Click on **Real-time Database**
    * Click on the **Rules** tab.
        - Change the line from: `".read": false,` to `".read": true,`.
        - Change the line from: `".write": false,` to `".write": true,`.
        - Click on the *Publish* button and accept changes.

#### Configure account

In order to use your Firebase account with HomeSetup, you will need to configure the read and write permissions as 
showed on topic [1.3.1.](#create-new-account).

Access your account from: https://console.firebase.google.com/

Grab you *Project ID* from the settings Settings menu.

Type in a shell: `$ dotfiles --setup`

Fill in the information required.
You are now ready to use the Firebase features of HomeSetup.
Type: `$ dotfiles.bash help fb` for further information about using it.

## Uninstallation

If you decide to, you can uninstall all HomeSetup files and restore your old dotfiles. To do that issue the command 
in a shell: `# HomeSetup> ./uninstall.bash`

The uninstaller will remove all files and folders related to HomeSetup for good. The only folder that will stay is
the ~/.hhs where your configurations were stored. It's safe to delete this folder after the uninstallation of HomeSetup.

## Usage

HomeSetup provides a [User Handbook](docs/handbook/USER_HANDBOOK.md) with all commands and examples of usage. There will also be a video about how to
install, configure and all available features demo.

## Dotfiles in this project

The following files will be added when installing this project:

```
~/.bashrc # Bash resources init
~/.bash_profile # Profile bash init
~/.bash_aliases # All defined aliases
~/.bash_prompt # Enhanced shell prompt
~/.bash_env # Environment variables
~/.bash_colors # All defined color related stuff
~/.bash_functions # Scripting functions
```

The following directory will be linked to your HOME folder:

`~/bin # Includes all useful script provided by the project`

If this folder already exists, the install script will copy all files into it.

To override or add customized stuff, you need to create a custom file as follows:

```
~/.colors           : To customize your colors
~/.env              : To customize your environment variables
~/.aliases          : To customize your aliases
~/.prompt           : To customize your prompt
~/.functions        : To customize your functions
~/.profile          : To customize your profile
~/.path             : To customize your paths
~/.aliasdef         : To customize your alias definitions
```

## Aliases

HomeSetup will provide many useful aliases (shortcuts) to your terminal:

### Navigational

| ALIAS | Equivalent | Description                                      |
| ----- | ---------- | ------------------------------------------------ |
| ...   | cd ...     | Change-back two previous directories             |
| ....  | cd ....    | Change-back three previous directories           |
| ..... | cd .....   | Change-back four previous directories            |
| ~     | cd ~       | Change the current directory to HOME dir         |
| \-    | cd -       | Change the current directory to the previous dir |
| ?     | pwd        | Display the current directory path               |

### General

| ALIAS     | Description                                                           |
| --------- | --------------------------------------------------------------------- |
| q         | Short for `exit 0' from terminal                                      |
| sudo      | Enable aliases to be sudo’ed                                          |
| ls        | Always use color output for **ls**                                    |
| l         | List _all files_ colorized in long format                             |
| lsd       | List _all directories_ in long format                                 |
| ll        | List _all files_ colorized in long format, **including dot files**    |
| lll       | List _all **.dotfiles**_ colorized in long format                     |
| lld       | List _all **.dotfolders**_ colorized in long format                   |
| grep      | Always enable colored **grep** output                                 |
| egrep     | Always enable colored **fgrep** output                                |
| fgrep     | Always enable colored **egrep** output                                |
| rm        | By default **rm** will prompt for confirmation and will be verbose    |
| cp        | By default **cp** will prompt for confirmation and will be verbose    |
| mv        | By default **mv** will prompt for confirmation and will be verbose    |
| df        | Make **df** command output pretty and human readable format           |
| du        | Make **du** command output pretty and human readable format           |
| psg       | Make **ps** command output pretty and human readable format           |
| vi        | Use **vim** instead of **vi** if installed                            |
| more      | **more** will interpret escape sequences                              |
| less      | **less** will interpret escape sequences                              |
| mount     | Make `mount' command output pretty and human readable format          |
| cpu       | **top** shortcut ordered by _cpu_                                     |
| mem       | **top** shortcut ordered by _Memory_                                  |
| week      | Date&Time - Display current **week number**                           |
| now       | Date&Time - Display current **date and time**                         |
| ts        | Date&Time - Display current **timestamp**                             |
| time-ms   | Date&Time - Display current **time in millis**                        |
| wget      | If **wget** is not available, use **curl** instead                    |
| ps1       | Make _PS1_ prompt active                                              |
| ps2       | Make _PS2_ prompt active                                              |

### HomeSetup (HHS)

| ALIAS          | Description                                   |
| -------------- | --------------------------------------------- |
| __hhs_vault    | Shortcut for hhs vault plug-in                |
| __hhs_hspm     | Shortcut for hhs hspm plug-in                 |
| __hhs_firebase | Shortcut for hhs firebase plug-in             |
| __hhs_hhu      | Shortcut for hhs updater plug-in              |
| __hhs_reload   | Reload HomeSetup                              |
| __hhs_clear    | Clear and reset all cursor attributes and IFS |
| __hhs_reset    | Clear the screen and reset the terminal       |
| __hhs_open     | Use the assigned app to open a file           |

### Tool aliases

| ALIAS              | Description                                                                      |
| ------------------ | -------------------------------------------------------------------------------- |
| jenv_set_java_home | Jenv - Set JAVA_HOME using jenv                                                  |
| cleanup-db         | Dropbox - Recursively delete Dropbox conflicted files from the current directory |
| encode             | Shortcut for base64 encode                                                       |

### OS Specific aliases

#### Linux

| ALIAS  | Description                      |
| ------ | -------------------------------- |
| cpu    | `top' shortcut ordered by CPU%   |
| mem    | `top' shortcut ordered by MEM%   |
| ised   | Same as sed -i'' -r              |
| esed   | Same as sed -r                   |
| decode | Shortcut for base64 decode       |
| apt    | Same as apt-get                  |

#### Darwin

| ALIAS          | Description                                                              |
| -------------- | ------------------------------------------------------------------------ |
| cpu            | `top' shortcut ordered by CPU%                                           |
| mem            | `top' shortcut ordered by MEM%                                           |
| ised           | Same as sed -i '' -E                                                     |
| esed           | Same as sed -E                                                           |
| decode         | Shortcut for **base64** decode                                           |
| cleanup-ds     | Delete all _.DS_store_ files recursively                                 |
| flush          | Flush Directory Service cache                                            |
| cleanup-reg    | Clean up LaunchServices to remove duplicates in the **"Open With"** menu |
| show-files     | Show hidden files in Finder                                              |
| hide-files     | Hide hidden files in Finder                                              |
| show-deskicons | Show all desktop icons                                                   |
| hide-deskicons | Hide all desktop icons                                                   |
| hd             | Canonical hex dump; some systems have this symlinked                     |
| md5sum         | If **md5sum** is not available, use **md5** instead`                     |
| sha1           | If **sha1** is not available, use **shasum** instead`                    |


### Handy Terminal Shortcuts

| ALIAS              | Description                          |
| ------------------ | ------------------------------------ |
| show-cursor        | Make terminal cursor visible         |
| hide-cursor        | Make terminal cursor invisible       |
| save-cursor-pos    | Save terminal cursor position        |
| restore-cursor-pos | Restore terminal cursor position     |
| enable-line-wrap   | Enable terminal line wrap            |
| disable-line-wrap  | Disable terminal line wrap           |
| enable-echo        | Enable terminal echo                 |
| disable-echo       | Disable terminal echo                |
| reset-cursor-attrs | Reset all terminal cursor attributes |
| save-screen        | Save the current terminal screen     |
| restore-screen     | Restore the saved terminal screen    |

### Python aliases

| ALIAS | Description                       |
| ----- | --------------------------------- |
| calc  | Evaluate mathematical expressions |
| urle  | URL-encode strings                |
| urld  | URL-decode strings                |
| uuid  | Generate a random UUID            |

### Perl aliases

| ALIAS         | Description                            |
| ------------- | -------------------------------------- |
| clean_escapes | Remove escape (\EscXX) codes from text |
| clipboard     | Copy to clipboard **pbcopy required**  |

### Git aliases

| ALIAS                 | Description                             |
| --------------------- | --------------------------------------- |
| __hhs_git_status      | Git - Enhancement for **git status**    |
| __hhs_git_fetch       | Git - Shortcut for **git fetch**        |
| __hhs_git_history     | Git - Shortcut for **git log**          |
| __hhs_git_branch      | Git - Shortcut for **git branch**       |
| __hhs_git_diff        | Git - Shortcut for **git diff**         |
| __hhs_git_pull        | Git - Shortcut for **git pull**         |
| __hhs_git_log         | Git - Enhancement for **git log**       |
| __hhs_git_checkout    | Git - Shortcut for git **checkout**     |
| __hhs_git_add         | Git - Shortcut for git **add**          |
| __hhs_git_commit      | Git - Shortcut for git **commit**       |
| __hhs_git_amend       | Git - Shortcut for git **commit amend** |
| __hhs_git_pull_rebase | Git - Shortcut for git **pull rebase**  |
| __hhs_git_push        | Git - Shortcut for git **push**         |
| __hhs_git_show        | Git - Enhancement for **git diff-tree** |
| __hhs_git_difftool    | Git - Enhancement for **git difftool**  |

### Gradle aliases

| ALIAS                 | Description                                          |
| --------------------- | ---------------------------------------------------- |
| __hhs_gradle_build    | Gradle - Enhancement for **gradle build**            |
| __hhs_gradle_run      | Gradle - Enhancement for **gradle bootRun**          |
| __hhs_gradle_test     | Gradle - Shortcut for **gradle Test**                |
| __hhs_gradle_init     | Gradle - Shortcut for **gradle init**                |
| __hhs_gradle_quiet    | Gradle - Shortcut for **gradle -q**                  |
| __hhs_gradle_wrapper  | Gradle - Shortcut for **gradle wrapper**             |
| __hhs_gradle_projects | Gradle - Displays all available gradle projects      |
| __hhs_gradle_tasks    | Gradle - Displays all available gradle project tasks |

### Docker aliases

| ALIAS                     | Description                                  |
| ------------------------- | -------------------------------------------- |
| __hhs_docker_images       | Docker - Enhancement for docker images       |
| __hhs_docker_service      | Docker - Shortcut for docker service         |
| __hhs_docker_remove       | Docker - Shortcut for docker container rm    |
| __hhs_docker_remove_image | Docker - Shortcut for docker rmi             |
| __hhs_docker_ps           | Docker - Enhancement for docker ps           |
| __hhs_docker_top          | Docker - Enhancement for docker stats        |
| __hhs_docker_ls           | Docker - Enhancement for docker container ls |
| __hhs_docker_up           | Enhancement for `docker compose up           |
| __hhs_docker_down         | Shortcut for `docker compose stop            |


## Functions

HomeSetup provides many functions for the shell. All functions includes a help using the options -h or --help.

### Standard tools

The complete handbook of standard tools can be found on the [functions handbook](docs/handbook/pages/functions.md#standard-tools)

| File                   | Function               | Purpose                                                                     |
| ---------------------- | ---------------------- | --------------------------------------------------------------------------- |
| bash_aliases.bash      | __hhs_has              | Check if a command is available on the current shell session.               |
|                        | __hhs_alias            | Check if an alias does not exists and create it, otherwise ignore it        |
| hhs-aliases.bash       | __hhs_aliases          | Manipulate custom aliases (add/remove/edit/list)                            |
| hhs-built-ins.bash     | __hhs_random_number    | Generate a random number int the range <min> <max> (all limits included)    |
|                        | __hhs_ascof            | Display the decimal ASCII representation of a character                     |
|                        | __hhs_utoh             | Convert unicode to hexadecimal                                              |
| hhs-command.bash       | __hhs_command          | Add/Remove/List/Execute saved bash commands                                 |
| hhs-dirs.bash          | __hhs_change_dir       | Replace the build-in 'cd' with a more flexible one.                         |
|                        | __hhs_changeback_ndirs | Change back the shell working directory by N directories                    |
|                        | __hhs_dirs             | Replace the build-in 'dirs' with a more flexible one                        |
|                        | __hhs_list_tree        | List all directories recursively (Nth level depth) as a tree                |
|                        | __hhs_save_dir         | Save the one directory to be loaded by load                                 |
|                        | __hhs_load_dir         | **Pushd** into a saved directory previously issued by save                  |
|                        | __hhs_godir            | Search and **pushd** into the first match of the specified directory name   |
|                        | __hhs_mkcd             | Create all folders using a dot notation path and immediately change into it |
| hhs-files.bash         | __hhs_ls_sorted        | List files and sort by the specified column                                 |
|                        | __hhs_del_tree         | Move files recursively to the **Trash**                                     |
| hhs-mchoose.bash       | __hhs_mchoose          | Choose options from a list using a navigable menu                           |
| hhs-minput.bash        | __hhs_minput_curpos    | Retrieve the current cursor position on screen                              |
|                        | __hhs_minput           | Provide a terminal form input with validation checking                      |
| hhs-mselect.bash       | __hhs_mselect          | Select an option from a list using a navigable menu                         |
| hhs-network.bash       | __hhs_active_ifaces    | Display a list of active network interfaces                                 |
|                        | __hhs_ip               | Display the associated machine IP of the given kind                         |
|                        | __hhs_ip_info          | Get information about the specified IP                                      |
|                        | __hhs_ip_lookup        | Lookup DNS entries to determine the IP address                              |
|                        | __hhs_ip_resolve       | Resolve domain names associated with the specified IP                       |
|                        | __hhs_port_check       | Check the state of local port(s)                                            |
| hhs-paths.bash         | __hhs_paths            | Print each PATH entry on a separate line                                    |
| hhs-profile-tools.bash | __hhs_activate_nvm     | Lazy load helper to activate **NVM** for the terminal                       |
|                        | __hhs_activate_rvm     | Lazy load helper to activate **RVM** for the terminal                       |
|                        | __hhs_activate_jenv    | Lazy load helper to activate **Jenv** for the terminal                      |
|                        | __hhs_activate_docker  | Lazy load helper to start **Docker-Daemon** for the terminal                |
| hhs-punch.bash         | __hhs_punch            | Punch the Clock. Add/Remove/Edit/List clock punches                         |
| hhs-search.bash        | __hhs_search_file      | Search for files and links to files recursively                             |
|                        | __hhs_search_dir       | Search for directories and links to directories recursively                 |
|                        | __hhs_search_string    | Search for strings matching the specified criteria in files recursively     |
| hhs-security.bash      | __hhs_encrypt_file     | Encrypt file using GPG                                                      |
|                        | __hhs_decrypt_file     | Decrypt file using GPG                                                      |
| hhs-shell-utils.bash   | __hhs_history          | Search for previous issued commands from history using filters              |
|                        | __hhs_envs             | Display all environment variables using filters                             |
|                        | __hhs_shell_select     | Select a shell from the existing shell list                                 |
|                        | __hhs_color_palette    | Terminal color palette test                                                 |
| hhs-sys-utils.bash     | __hhs_sysinfo          | Display relevant system information                                         |
|                        | __hhs_process_list     | Display a process list matching the process name/expression                 |
|                        | __hhs_process_kill     | Kills **ALL processes** specified by name                                   |
|                        | __hhs_partitions       | Exhibit a Human readable summary about all partitions                       |
| hhs-taylor.bash        | __hhs_tailor           | Tail a log using colors and patterns specified on **.tailor** file          |
| hhs-text.bash          | __hhs_errcho           | Echo a message in red color and to stderr                                   |
|                        | __hhs_highlight        | Highlight words from the piped stream                                       |
|                        | __hhs_json_print       | Pretty print **(format) JSON** string                                           |
|                        | __hhs_edit             | Create and/or open a file using the default editor or vi if not set         |
| hhs-toolcheck.bash     | __hhs_toolcheck        | Check whether a tool is installed on the system                             |
|                        | __hhs_version          | Check the version of the app using the most common ways                     |
|                        | __hhs_tools            | Check whether a list of development tools are installed or not              |
|                        | __hhs_about_command    | Display information about the given command                                 |

### Development tools

The complete handbook of development tools can be found [here](docs/handbook/pages/functions.md#development-tools)

| File                  | Function                     | Purpose                                                                            |
| --------------------- | ---------------------------- | ---------------------------------------------------------------------------------- |
| hhs-docker-tools.bash | __hhs_docker_count           | Return the number of active docker containers                                      |
|                       | __hhs_docker_exec            | Run a command or bash in a running container                                       |
|                       | __hhs_docker_compose_exec    | This is the equivalent of docker exec, but for docker-compose                      |
|                       | __hhs_docker_info            | Display information about the container                                            |
|                       | __hhs_docker_logs            | Fetch the logs of a container                                                      |
|                       | __hhs_docker_remove_volumes  | Remove all docker volumes not referenced by any containers (dangling)              |
|                       | __hhs_docker_kill_all        | Stop, remove and remove dangling (active?) volumes of all docker containers        |
| hhs-git-tools.bash    | __hhs_git_branch_previous    | Checkout the previous branch in history (skips branch-to-same-branch changes)      |
|                       | __hhs_git_branch_all         | Get the current branch name of all repositories from the base search path          |
|                       | __hhs_git_status_all         | Get the status of current branch of all repositories from the base search path     |
|                       | __hhs_git_show_file_diff     | Display a file diff comparing the version between the first and second commit IDs  |
|                       | __hhs_git_show_file_contents | Display the contents of a file from specific commit ID                             |
|                       | __hhs_git_show_changes       | List all changed files from a commit ID                                            |
|                       | __hhs_git_branch_select      | Select and checkout a local or remote branch                                       |
|                       | __hhs_git_pull_all           | Search and pull projects from the specified path using the given repository/branch |
| hhs-gradle-tools.bash | __hhs_gradle                | Prefer using the wrapper instead of the command itself                             |

## Applications

HomeSetup provides useful applications that can be used directly from shell. It is also added to your PATH variable.
The complete handbook of development tools can be found [here](docs/handbook/pages/applications.md)

### Bash apps

| Application      | Purpose                                                                                       |
| ---------------- | --------------------------------------------------------------------------------------------- |
| app-commons.bash | Commonly used bash code functions and variables that you may include it on your bash scripts. |
| check-ip.bash    | Validate and check information about a specified IP.                                          |
| fetch.bash       | Fetch REST APIs data easily.                                                                  |
| hhs.bash         | HomeSetup application.                                                                        |

### Python apps

| Function         | Purpose                                                       |
| ---------------- | ------------------------------------------------------------- |
| free.py          | Report system memory usage.                                   |
| json-find.py     | Find an object from the Json string or file.                  |
| pprint-xml.py    | Pretty print (format) an xml file.                            |
| print-uni.py     | Print a backslash (4 digits) unicode character E.g:. \\uf118. |
| send-msg.py      | IP Message Sender. Sends TCP/UDP messages (multi-threaded).   |
| tcalc.py         | Simple app to do mathematical calculations with time.         |

## Alias definitions

You can customize most of HomeSetup aliases by editing your file **~/.aliasdef**. When you first install HomeSetup,
this file will be automatically generated for you. Further updates may require this file to be updated. We always keep a
backup of this file, so, you can preserve your customizations, but this process has to be manual.

The original content and aliases are defined on the original [aliasdef](dotfiles/aliasdef) file.

## HomeSetup Application

HomeSetup application is a bundle of scripts and functions to extend the terminal features. There are plug-able scripts
and functions to be incorporated into the app.

### HHS plugins

| Plug-in  | Purpose                                                                  |
| -------- | ------------------------------------------------------------------------ |
| updater  | Update manager for HomeSetup.                                            |
| firebase | Manager for HomeSetup Firebase integration.                              |
| hspm     | Manage your development tools using installation/uninstallation recipes. |
| vault    | This application is a vault for secrets and passwords.                   |

### HHS functions

| Function  | Purpose                                                                                   |
| --------- | ----------------------------------------------------------------------------------------- |
| help      | Provide a **help** for __hhs functions.                                                   |
| list      | List all HHS App **Plug-ins** and **Functions**.                                          |
| tests     | Execute all HomeSetup **automated tests**.                                                |
| funcs     | Search for all hhs **functions** describing it's containing file name and line number.    |
| board     | Open the HomeSetup GitHub project **board** for the current version.                      |
| host-name | Retrieve/Get/Set the current hostname.                                                    |

## Auto completions

In addition to the normal bash <tab> complete, HomeSetup comes with another <shift+tab> complete. With this, you can iterate
over the options provided by the complete function instead of just displaying them. 

### Bash completions

| File                              | Purpose                                           |
| --------------------------------- | ------------------------------------------------- |
| brew-completion.bash              | Bash completion file for HomeBrew commands        |
| docker-completion.bash            | Bash completion file for core docker commands.    |
| docker-compose-completion.bash    | Bash completion for docker-compose commands.      |
| docker-machine-completion.bash    | Bash completion file for docker-machine commands. |
| git-completion.bash               | Bash/zsh completion support for core Git.         |
| gradle-completion.bash            | Bash and Zsh completion support for Gradle.       |
| helm-completion.bash              | Bash completion for helm.                         |
| hhs-completion.bash               | Bash completion for HomeSetup.                    |
| kubectl-completion.bash           | Bash completion for kubectl.                      |
| pcf-completion.bash               | Bash completion for Cloud Foundry CLI.            |

## Contact

You can contact us using our [Gitter](https://gitter.im/yorevs-homesetup/community) community or using our 
[Reddit](https://www.reddit.com/user/yorevs).

## Support HomeSetup

You can support HomeSetup by [donating](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=J5CDEFLF6M3H4) 
or coding. Fell free to contact me for details. When contributing with code change please take a look at our 
[guidelines](docs/CONTRIBUTING.md) and [code of conduct](docs/CODE_OF_CONDUCT.md).

## Final notes

HomeSetup will fetch for update automatically every 7 days from the installation on.

**To manually keep your HomeSetup updated**, run `$ hhs updater execute`. This will install the latest HomeSetup version.

[![paypal](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=J5CDEFLF6M3H4)
