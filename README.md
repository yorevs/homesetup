# HomeSetup

## Your shell good as hell ! Not just dotfiles

[![Build](images/badge.svg)](images/badge.svg)
[![License](https://badgen.net/badge/license/the-unlicense/gray)](LICENSE.md)
[![Release](https://badgen.net/badge/release/v1.3.23/gray)](.VERSION)
[![Terminal](https://badgen.net/badge/icon/terminal?icon=terminal&label)](https://github.com/yorevs/homesetup)
[![Gitter](https://badgen.net/badge/icon/gitter?icon=gitter&label)](https://gitter.im/yorevs-homesetup/community?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)
[![Donate](https://badgen.net/badge/paypal/donate/yellow)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=J5CDEFLF6M3H4)

Terminal .dotfiles and bash improvements for MacOS. HomeSetup is a bundle os scripts and dotfiles that will elevate 
your shell to another level. There are many improvements and facilities, especially for developers that will ease the
usage and highly improve your productivity. Currently we only support Bash (v3.4+) for Darwin (MacOS). We have plans
to adapt all of the code to be able to run under Linux and also, add support for Zsh.

## Highlights

HomeSetup was created to help users with the command line. The purpose was to create useful and easy-to-use features 
that speedup daily tasks such as, punching the clock, searching for strings and files, change directories, using git, 
gradle, docker, etc...

- Setup most common configurations automatically.
- New <tab+shift> complete (using menu-complete) that will cycle though options.
- Prompt with a new monospaced font that supports [font-awesome](https://fontawesome.com/cheatsheet?from=io) icons.
- Package manager helper to help installing application using recipes (not only brew installs).
- Save your custom dotfiles on the [cloud](https://console.firebase.google.com) and use it wherever you go.
- New visual way to **select** and **input** data for your scripts without dependencies (pure bash code).
- Dozens of functions to help you configure your terminal, and do daily tasks.
- Highly customizable aliases, so you dictate what mnemonics you want to use (use your own syntax).
- All code is [unlicensed](LICENSE.md), so, you can modify and use freely.
- Small learning curve and a provided [user's handbook](docs/USER_HANDBOOK.md).

## Catalina moved from bash to zsh

Latest version of MacOS comes with zsh as the default shell. You can change it at any time using the following command:

```bash
$ sudo chsh -s /bin/bash
```

If apple decides to remove from next MacOS releases, you can always use HomeBrew version. In this case, the path is 
different, like this:

```bash
$ brew install bash
$ sudo chsh -s /usr/local/bin/bash
```

## Table of contents

<!-- toc -->

- [1. Installation](#installation)
  * [1.1. Requirements](#requirements)
    + [1.1.1. Supported Bash versions](#supported-bash-versions)
    + [1.1.2. Required software](#required-software)
    + [1.1.3. Recommended software](#recommended-software)
    + [1.1.4. Optional software](#optional-software)
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
  * [9.1. Plugins](#hhs-plugins)
  * [9.2. Functions](#hhs-functions)
- [10. Auto completions](#auto-completions)
  * [10.1. Bash completions](#bash-completions)
- [11. Terminal setup](#terminal-setup)
  * [11.1. Terminal App](#terminal-app)
  * [11.2. iTerm2 App](#iterm2-app)
- [12. Contact](#contact)
- [13. Support HomeSetup](#support-homesetup)
- [14. Final notes](#final-notes)

<!-- tocstop -->


## Installation

### Requirements

#### Supported Bash versions

- Everything from 3.2.57(1) and higher (macOS's highest version)

#### Required software

The following software are required either to clone the repository, execute the tests and install packages:

- **git** v2.20+ : To clone and maintain the code
- **brew** v2.0+ : To install the required tools

#### Recommended software

HomeSetup relies on a series of tools. To use most of the features of HomeSetup, the following packages are required:

- **bats** v0.4+ : To run the automated tests
- **python** v2.7+ or v3.0+
- **curl** v7.64+
- **perl** v5.0+
- **pcregrep** v8.43+
- **dig** v9.10+
- **tree** v1.8+
- **vim** v8.0+
- **figlet** v2.2.5+

#### Optional software

There are some tools that are also good to have  if you are a developer. HomeSetup provides some features to help using
those tools:

- **docker** 19.03+
- **gradle** 4+

### Remote installation

You can install HomeSetup directly from GitHub. To do that use the following command to clone and install:

`#> curl -o- https://raw.githubusercontent.com/yorevs/homesetup/master/install.bash | bash`

or

`#> wget -qO- https://raw.githubusercontent.com/yorevs/homesetup/master/install.bash | bash`

### Local installation

Clone the repository using the following command:

`#> git clone https://github.com/yorevs/homesetup.git ~/HomeSetup`

And then install dotfiles using the following command:

`#> cd ~/HomeSetup && ./install.bash` => **To install one by one**

or

`#> cd ~/HomeSetup && ./install.bash --all` => **To install all files**

Your old dotfiles (.bash*) will be backed up using '.orig' suffix and sent to ~/.hhs folder.

### Firebase setup

HomeSetup allows you to use your Firebase account to upload and download your custom files
(dotfiles files synchronization) to your *Realtime Database*. To be able to use this feature, you need first 
to configure your Google Firebase account.

#### Create new account

If you have a Google account but do not have a Firebase one, you can do that using your Google credentials.

Access: https://console.firebase.google.com/

1. Create a *new Project* (HomeSetup).
2. Create Database (as **testing mode**).
    * Click on Develop -> Database -> Create Database
    * Click on **Realtime Database**
    * Click on the **Rules** tab.
        - Change the line from: `".read": false,` to `".read": true,`.
        - Change the line from: `".write": false,` to `".write": true,`.
        - Click on the *Publish* button and accept changes.

#### Configure account

In order to use your Firebase account with HomeSetup, you will need to configure the read and write permissions as 
showed on topic [1.3.1.](#create-new-account).

Access your account from: https://console.firebase.google.com/

Grab you *Project ID* from the settings Settings menu.

Type in a shell: `#> dotfiles --setup`

Fill in the information required.
You are now ready to use the Firebase features of HomeSetup.
Type: `#> dotfiles.bash help fb` for further information about using it.

## Uninstallation

If you decide to, you can uninstall al HomeSetup files and restore your old dotfiles. To do that issue the command 
in a shell: `# HomeSetup> ./uninstall.bash`

The uninstaller will remove all files and folders related to HomeSetup for good. The only folder that will stay is
the ~/.hhs where your configurations were stored. It's safe to delete this folder after the uninstallation of HomeSetup.

## Usage

HomeSetup provides a [User Handbook](docs/USER_HANDBOOK.md) with all commands and examples of usage. There will also be a video about how to
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

To override or add customised stuff, you need to create a custom file as follows:

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

| ALIAS | Description                                                        |
| ----- | ------------------------------------------------------------------ |
| q     | Short for `exit 0' from terminal                                   |
| sudo  | Enable aliases to be sudo’ed                                       |
| ls    | Always use color output for **ls**                                 |
| l     | List _all files_ colorized in long format                          |
| lsd   | List _all directories_ in long format                              |
| ll    | List _all files_ colorized in long format, **including dot files** |
| lll   | List _all **.dotfiles**_ colorized in long format                  |
| lld   | List _all **.dotfolders**_ colorized in long format                |
| grep  | Always enable colored **grep** output                              |
| egrep | Always enable colored **fgrep** output                             |
| fgrep | Always enable colored **egrep** output                             |
| rm    | By default **rm** will prompt for confirmation and will be verbose |
| cp    | By default **cp** will prompt for confirmation and will be verbose |
| mv    | By default **mv** will prompt for confirmation and will be verbose |
| df    | Make **df** command output pretty and human readable format        |
| du    | Make **du** command output pretty and human readable format        |
| psg   | Make **ps** command output pretty and human readable format        |
| vi    | Use **vim** instead of **vi** if installed                         |
| more  | **more** will interpret escape sequences                           |
| less  | **less** will interpret escape sequences                           |
| mount | Make `mount' command output pretty and human readable format       |
| cpu   | **top** shortcut ordered by _cpu_                                  |
| mem   | **top** shortcut ordered by _Memory_                               |
| week  | Date&Time - Display current **week number**                        |
| now   | Date&Time - Display current **date and time**                      |
| ts    | Date&Time - Display current **timestamp**                          |
| wget  | If **wget** is not available, use **curl** instead                 |
| ps1   | Make _PS1_ prompt active                                           |
| ps2   | Make _PS2_ prompt active                                           |

### HomeSetup

| ALIAS          | Description                                   |
| -------------- | --------------------------------------------- |
| __hhs_vault    | Shortcut for hhs vault plug-in                |
| __hhs_hspm     | Shortcut for hhs hspm plug-in                 |
| __hhs_dotfiles | Shortcut for hhs firebase plug-in             |
| __hhs_hhu      | Shortcut for hhs updater plug-in              |
| __hhs_reload   | Reload HomeSetup                              |
| __hhs_clear    | Clear and reset all cursor attributes and IFS |
| __hhs_reset    | Clear the screen and reset the terminal       |

### Tool aliases

| ALIAS              | Description                                                                      |
| ------------------ | -------------------------------------------------------------------------------- |
| jenv_set_java_home | Jenv - Set JAVA_HOME using jenv                                                  |
| cleanup-db         | Dropbox - Recursively delete Dropbox conflicted files from the current directory |
| encode             | Shortcut for base64 encode                                                       |

### OS Specific aliases

#### Linux

| ALIAS  | Description                        |
| ------ | ---------------------------------- |
| ised   | Same as sed -i'' -r (Linux)        |
| esed   | Same as sed -r (Linux)             |
| decode | Shortcut for base64 decode (Linux) |

#### Darwin

| ALIAS          | Description                                                              |
| -------------- | ------------------------------------------------------------------------ |
| ised           | Same as sed -i '' -E (Darwin)                                            |
| esed           | Same as sed -E (Darwin)                                                  |
| decode         | Shortcut for **base64** decode (Darwin)                                  |
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
| __hhs_gradle_projects | Gradle -  Displays all available gradle projects     |
| __hhs_gradle_tasks    | Gradle - Displays all available gradle project tasks |

### Docker aliases

| ALIAS                     | Description                                  |
| ------------------------- | -------------------------------------------- |
| __hhs_docker_images       | Docker - Enhancement for docker images       |
| __hhs_docker_service      | Docker - Shortcut for docker service         |
| __hhs_docker_logs         | Docker - Shortcut for docker logs            |
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

| File                   | Function               | Purpose                                                                     |
| ---------------------- | ---------------------- | --------------------------------------------------------------------------- |
| bash_aliases.bash      | __hhs_has              | Check if a command exists                                                   |
|                        | __hhs_alias            | Check if an alias does not exists and create it, otherwise ignore it        |
| hhs-aliases.bash       | __hhs_aliases          | Manipulate custom aliases (add/remove/edit/list)                            |
| hhs-built-ins.bash     | __hhs_random_number    | Generate a random number int the range <min> <max>                          |
|                        | __hhs_ascof            | Display the decimal ASCII representation of a character                     |
|                        | __hhs_utoh             | Convert unicode to hexadecimal                                              |
| hhs-command.bash       | __hhs_command          | Add/Remove/List/Execute saved bash commands                                 |
| hhs-dirs.bash          | __hhs_change_dir       | Replace the build-in 'cd' with a more flexible one.                         |
|                        | __hhs_changeback_ndirs | Change back the shell working directory by N directories                    |
|                        | __hhs_dirs             | Replace the build-in 'dirs' with a more flexible one                        |
|                        | __hhs_list_tree        | List all directories recursively (Nth level depth) as a tree                |
|                        | __hhs_save_dir         | Save the one directory to be loaded by load                                 |
|                        | __hhs_load_dir         | **Pushd** into a saved directory previously issued by save                  |
|                        | __hhs_go_dir           | Search and **pushd** into the first match of the specified directory name   |
|                        | __hhs_mkcd             | Create all folders using a dot notation path and immediately change into it |
| hhs-files.bash         | __hhs_ls_sorted        | List files and sort by the specified column                                 |
|                        | __hhs_del_tree         | Move files recursively to the Trash                                         |
| hhs-mchoose.bash       | __hhs_mchoose          | Choose options from a list using a navigable menu                           |
| hhs-minput.bash        | __hhs_minput_curpos    | Retrieve the current cursor position on screen                              |
|                        | __hhs_minput           | Provide a terminal form input with validation checking                      |
| hhs-mselect.bash       | __hhs_mselect          | Select an option from a list using a navigable menu                         |
| hhs-network.bash       | __hhs_my_ip            | Find external IP by performing a DNS lookup                                 |
|                        | __hhs_ip_resolve       | Resolve domain names associated with the specified IP                       |
|                        | __hhs_all_ips          | Display a list of all assigned IPs                                          |
|                        | __hhs_local_ip         | Display local IP's of active interfaces                                     |
|                        | __hhs_active_ifaces    | Display a list of active network interfaces                                 |
|                        | __hhs_vpn_ip           | Get the IP associated to the active VPN connection                          |
|                        | __hhs_gateway_ip       | Get IP or hostname of the default gateway                                   |
|                        | __hhs_ip_info          | Get information about the specified IP                                      |
|                        | __hhs_ip_lookup        | Lookup DNS entries to determine the IP address                              |
|                        | __hhs_port_check       | Check the state of local port(s)                                            |
| hhs-paths.bash         | __hhs_paths            | Print each PATH entry on a separate line                                    |
| hhs-profile-tools.bash | __hhs_activate_nvm     | Lazy load helper to activate NVM for the terminal                           |
|                        | __hhs_activate_rvm     | Lazy load helper to activate RVM for the terminal                           |
|                        | __hhs_activate_jenv    | Lazy load helper to activate Jenv for the terminal                          |
|                        | __hhs_activate_docker  | Lazy load helper to start Docker-Daemon for the terminal                    |
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
| hhs-sysman.bash        | __hhs_sysinfo          | Display relevant system information                                         |
|                        | __hhs_process_list     | Display a process list matching the process name/expression                 |
|                        | __hhs_process_kill     | Kills ALL processes specified by name                                       |
|                        | __hhs_partitions       | Exhibit a Human readable summary about all partitions                       |
| hhs-taylor.bash        | __hhs_tailor           | Tail a log using colors and patterns specified on **.tailor** file          |
| hhs-text.bash          | __hhs_errcho           | Echo a message in red color and to stderr                                   |
|                        | __hhs_highlight        | Highlight words from the piped stream                                       |
|                        | __hhs_json_print       | Pretty print (format) JSON string                                           |
|                        | __hhs_edit             | Create and/or open a file using the default editor or vi if not set         |
| hhs-toolcheck.bash     | __hhs_toolcheck        | Check whether a tool is installed on the system                             |
|                        | __hhs_version          | Check the version of the app using the most common ways                     |
|                        | __hhs_tools            | Check whether a list of development tools are installed or not              |
|                        | __hhs_about_command    | Display information about the given command                                 |

### Development tools

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
| hhs-gradle-tools.bash | __hhs_gradlew                | Prefer using the wrapper instead of the command itself                             |

## Applications

HomeSetup provides useful applications that can be used directly from shell. It is also added to your PATH variable.

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

```
Usage:  [option] {function | plugin {task} <command>} [args...]

    HomeSetup Application Manager.

    Options:
      -v  |  --version  : Display current program version.
      -h  |     --help  : Display this help message.

    Tasks:
      help      : Display a help about the plugin.
      version   : Display current plugin version.
      execute   : Execute a plugin command.

    Arguments:
      args    : Plugin command arguments will depend on the plugin. May be mandatory or not.

    Exit Status:
      (0) Success.
      (1) Failure due to missing/wrong client input or similar issues.
      (2) Failure due to program/plugin execution failures.

  Notes:
    - To discover which plugins and functions are available type: hhs list
```

### HHS plugins

| Plug-in  | Purpose                                                                  |
| -------- | ------------------------------------------------------------------------ |
| updater  | Update manager for HomeSetup.                                            |
| firebase | Manager for HomeSetup Firebase integration.                              |
| hspm     | Manage your development tools using installation/uninstallation recipes. |
| vault    | This application is a vault for secrets and passwords.                   |

### HHS functions

| Function  | Purpose                                                                              |
| --------- | ------------------------------------------------------------------------------------ |
| help      | Provide a help for __hhs functions.                                                  |
| list      | List all HHS App Plug-ins and Functions.                                             |
| tests     | Execute all HomeSetup automated tests.                                               |
| funcs     | Search for all hhs <functions> describing it's containing file name and line number. |
| board     | Open the HomeSetup GitHub project board for the current version.                     |
| host-name | Retrieve/Get/Set the current hostname.                                               |

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
| hhs-completion.bash               | Bash completion for HomeSetup.                    |
| pcf-completion.bash               | Bash completion for Cloud Foundry CLI.            |
| kubectl-completion.bash           | Bash completion for kubectl.                      |
| helm-completion.bash              | Bash completion for helm.                         |

## Terminal setup

HomeSetup suggests a terminal profile to use. If you want to, you will need to do the following steps:

    [x] Install the terminal [Droid font](misc/fonts/Droid-Sans-Mono-for-Powerline-Nerd-Font-Complete.otf).

### Terminal App

    [x] Import the HomeSetup-(14|15)-inch.terminal from "$HHS_HOME/misc" to your Terminal App.
    [x] Set HomeSetup as the default profile.

### iTerm2 App

    [x] Import the iterm2-terminal-(14|15)-inch.json from "$HHS_HOME/misc" to your iTerm2 App.
    [x] Set HomeSetup as the default profile.

## Contact

You can contact us using our [Gitter](https://gitter.im/yorevs-homesetup/community) community or using our 
[Reddit](https://www.reddit.com/user/yorevs).

## Support HomeSetup

You can support HomeSetup by [donating](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=J5CDEFLF6M3H4) 
or coding. Fell free to contact me for details. When contributing with code change please take a look at our 
[guidelines](CONTRIBUTING.md) and [code of conduct](CODE_OF_CONDUCT.md).

## Final notes

HomeSetup will fetch for update automatically every 7 days from the installation on.

**To manually keep your HomeSetup updated**, run `$ hhs updater execute`. This will install the latest HomeSetup version.

[![paypal](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=J5CDEFLF6M3H4)
