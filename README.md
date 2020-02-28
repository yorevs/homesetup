# HomeSetup
## Your shell good as hell ! Not just dotfiles

[![Gitter](https://badgen.net/badge/icon/gitter?icon=gitter&label)](https://gitter.im/yorevs-homesetup/community?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)
[![Terminal](https://badgen.net/badge/icon/terminal?icon=terminal&label)](https://github.com/yorevs/homesetup)

Terminal .dotfiles and bash improvements for MacOS. HomeSetup is a bundle os scripts and dotfiles that will elevate 
your shell to another level. There are many improvements and facilities, especially for developers that will ease the
usage and highly improve your productivity. Currently we only support Bash (v3.4+) for Darwin (MacOS). We have plans
to adapt all of the code to be able to run under Linux and also, add support for Zsh.

## Table of contents

<!-- toc -->

- [1. Installation](#installation)
  * [1.1. Local installation](#local-installation)
  * [1.2. Remote installation](#remote-installation)
  * [1.3. Firebase setup](#firebase-setup)
    + [1.3.1. Create account](#create-new-account)
    + [1.3.2. Configure account](#configure-account)
- [2. Uninstallation](#uninstallation)
- [3. Dotfiles in this project](#dotfiles-in-this-project)
- [4. Aliases](#aliases)
  * [4.1. Navigational](#navigational)
  * [4.2. General](#general)
  * [4.3. HomeSetup](#homesetup)
  * [4.4. Tool aliases](#tool-aliases)
  * [4.5. OS Specific aliases](#os-specific-aliases)
    + [4.5.1. Linux](#linux)
    + [4.5.2. Darwin](#darwin)
  * [4.6. Handy terminal shortcuts](#handy-terminal-shortcuts)
  * [4.7. Python aliases](#python-aliases)
  * [4.8. Perl aliases](#perl-aliases)
  * [4.9. Git aliases](#git-aliases)
  * [4.10. Gradle aliases](#gradle-aliases)
  * [4.11. Docker aliases](#docker-aliases)
- [5. Functions](#functions)
  * [5.1. Standard tools](#standard-tools)
  * [5.2. Development tools](#development-tools)
- [6. Applications](#applications)
  * [6.1. Bash apps](#bash-apps)
  * [6.2. Python apps](#python-apps)
- [7. Alias Definitions](#alias-definitions)
- [8. HomeSetup application](#homesetup-application)
  * [8.1. Plugins](#hhs-plugins)
  * [8.2. Functions](#hhs-functions)
- [9. Auto-completes](#auto-completes)
- [10. Terminal setup](#terminal-setup)
  * [10.1. Terminal App](#terminal-app)
  * [10.2. iTerm2 App](#iterm2-app)
- [11. Final notes](#final-notes)

<!-- tocstop -->


## Installation

### Local installation

Clone the repository using the following command:

`#> git clone https://github.com/yorevs/homesetup.git ~/HomeSetup`

And then install dotfiles using the following command:

`#> cd ~/HomeSetup && ./install.bash` => **To install one by one**

or

`#> cd ~/HomeSetup && ./install.bash --all` => **To install all files**

Your old dotfiles (.bash*) will be backed up using '.orig' suffix and sent to ~/.hhs folder.

### Remote installation

You can install HomeSetup directly from GitHub. To do that use the following command to clone and install:

`#> curl -o- https://raw.githubusercontent.com/yorevs/homesetup/master/install.bash | bash`

or

`#> wget -qO- https://raw.githubusercontent.com/yorevs/homesetup/master/install.bash | bash`

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

If you decide to, you can uninstall al HomeSetup files and restore your old dotfiles. To do that issue the command in a shell: `# HomeSetup> ./uninstall.bash`

The uninstaller will remove all files and folders related to HomeSetup for good.

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

| Application      | Purpose                                                                                      |
| ---------------- | -------------------------------------------------------------------------------------------- |
| app-commons.bash | Commonly used bash code functions and variables that you may include it on your bash scripts |
| check-ip.bash    | Validate and check information about a specified IP                                          |
| fetch.bash       | Script to fetch REST APIs data                                                               |
| hhs.bash         | HomeSetup application                                                                        |

### Python apps

| Function      | Purpose                                                       |
| ------------- | ------------------------------------------------------------- |
| free.py       | Report system memory usage.                                   |
| json-find.py  | Find an object from the Json string or file.                  |
| pprint-xml.py | Pretty print (format) an xml file.                            |
| print-uni.py  | Print a backslash (4 digits) unicode character E.g:. \\uf118. |
| send-msg.py   | IP Message Sender. Sends TCP/UDP messages (multi-threaded).   |
| tcalc.py      | Simple app to do mathematical calculations with time.         |

## Alias definitions

You can customize most of HomeSetup aliases by editing your file `~/.aliasdef`. When you first install HomeSetup,
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
| funcs     | Search for all hhs <functions> describing it's containing file name and line number. |
| board     | Open the HomeSetup GitHub project board for the current version.                     |
| host-name | Retrieve/Get/Set the current hostname.                                               |

## Auto Completes

### Bash completes

| File                           | Purpose                                           |
| ------------------------------ | ------------------------------------------------- |
| docker-completion.bash         | Bash completion file for core docker commands.    |
| docker-compose-completion.bash | Bash completion for docker-compose commands.      |
| docker-machine-completion.bash | Bash completion file for docker-machine commands. |
| git-completion.bash            | Bash/zsh completion support for core Git.         |
| gradle-completion.bash         | Bash and Zsh completion support for Gradle.       |
| hhs-completion.bash            | Bash completion for HomeSetup.                    |
| pcf-completion.bash            | Bash completion for Cloud Foundry CLI.            |

## Terminal setup

HomeSetup suggests a terminal profile to use. If you want to, you will need to do the following steps:

* [x] Install the terminal [Droid font](misc/fonts/Droid-Sans-Mono-for-Powerline-Nerd-Font-Complete.otf).

### Terminal App

* [x] Import the HomeSetup-(14|15)-inch.terminal from "$HHS_HOME/misc" to your Terminal App.
* [x] Set HomeSetup as the default profile.

### iTerm2 App

* [x] Import the iterm2-terminal-(14|15)-inch.json from "$HHS_HOME/misc" to your iTerm2 App.
* [x] Set HomeSetup as the default profile.

## Contact

You can contact us using our [Gitter](https://gitter.im/yorevs-homesetup/community) community.

## Support HomeSetup

You can support HomeSetup by donating or helping code it. Fell free to contact me for details.

[![paypal](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=J5CDEFLF6M3H4)

## Final notes

HomeSetup will fetch for update automatically every 7 days from the installation on.

**To manually keep your HomeSetup updated, run `#> hhu` . This will pull the latest HomeSetup code**
