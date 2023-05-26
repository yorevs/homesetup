# <img src="https://iili.io/HvtxC1S.png"  width="34" height="34"> HomeSetup

## Your shell, good as hell ! 

[![License](https://badgen.net/badge/license/MIT/gray)](LICENSE.md)
[![Release](https://badgen.net/badge/release/v1.5.47/gray)](docs/CHANGELOG.md#unreleased)
[![Terminal](https://badgen.net/badge/icon/terminal?icon=terminal&label)](https://github.com/yorevs/homesetup)
[![Gitter](https://badgen.net/badge/icon/gitter?icon=gitter&label)](https://gitter.im/yorevs-homesetup/community?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)
[![Donate](https://badgen.net/badge/paypal/donate/yellow)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=J5CDEFLF6M3H4)

HomeSetup, created in **August 17, 2018**, is a comprehensive bundle of scripts and dotfiles designed to elevate your 
**bash shell** experience to new heights. Packed with numerous enhancements and developer-friendly features, HomeSetup 
is geared towards streamlining your workflow and significantly boosting productivity. Currently, it offers robust 
support for Bash (version 3.4+) on both _macOS_ and _Linux_ platforms. Moreover, we have exciting plans to extend 
support for [Zsh](https://www.zsh.org/) in the near future, catering to a wider range of users. If you're seeking a 
more powerful and efficient shell experience, HomeSetup is the perfect solution.

**THIS IT NOT JUST ANOTHER DOTFILES FRAMEWORK**

**LINUX IS HERE**

## Highlights

HomeSetup was specifically developed to enhance the command line experience for users. Its primary objective is to provide useful and user-friendly features that expedite daily tasks, such as time tracking, string and file searching, directory navigation, and seamless integration with popular tools like Git, Gradle, Docker, and more.

Key features of HomeSetup include:

- Automated setup for commonly used configurations, ensuring a hassle-free initial setup.
- A wide range of functions to simplify terminal configuration and streamline daily tasks.
- A visually appealing prompt with a monospaced font that supports [Font-Awesome](https://fontawesome.com/) icons.
- Highly customizable **aliases**, allowing users to define their preferred syntax and mnemonics.
- A **universal package manager** helper that facilitates the installation of applications using recipes, catering to various package managers _beyond normal package managers_.
- The ability to save custom dotfiles on [Firebase](https://firebase.google.com/) and easily download them across different environments.
- Offers a short learning curve and provides a comprehensive [User's Handbook](docs/handbook/USER_HANDBOOK.md) for reference.
- All code is licensed under The [MIT License](https://opensource.org/license/mit/), granting users the freedom to modify and use it as desired.
- New Tab completion with Shift key (using menu-complete) to cycle through options conveniently.
- Intuitive visual interfaces for selecting, choosing, and inputting data within scripts.
- Now supports Linux, expanding its compatibility to a wider range of operating systems.
- Can be tried on a [Docker](https://www.docker.com/) container before installing it on your local machine, ensuring a **risk-free trial**.

## Catalina moved from bash to zsh

Starting with the _Catalina_ version of macOS, the default shell has been switched to **Zsh**. Nonetheless, you retain 
the flexibility to change the default shell back to bash. To accomplish this, you can utilize the following command:

```bash
$ sudo chsh -s /bin/bash
```

If Apple decides to remove **Bash** from future macOS releases, you can always rely on Homebrew's version. In such cases, 
the path to the shell may differ. Here's an alternative approach:

```bash
$ brew install bash
$ sudo chsh -s /usr/local/bin/bash
```

## HomeSetup Python scripts moved to pypi

As HomeSetup evolved over time and expanded, the inclusion of Python scripts became essential. To streamline the 
management of the growing [Python](https://www.python.org/) codebase, we recognized the need for a dedicated project. 
Introducing **HomeSetup HsPyLib**, a separate project designed specifically for handling all **Python-related 
functionality**. You can find the HomeSetup HsPyLib project on PyPI (Python Package Index) at: https://pypi.org/. 
HsPyLib comprises _several modules_, each dedicated to a specific purpose, ensuring modular and focused functionality. 
Additionally, we have developed a range of highly useful applications as part of the HomeSetup ecosystem. Here is a 
list of all the applications managed by HomeSetup:

- [hspylib](https://pypi.org/project/hspylib/) :: HSPyLib - Core python library 
- [hspylib-kafman](https://pypi.org/project/hspylib-kafman/) :: HSPyLib - Apache Kafka Manager 
- [hspylib-datasource](https://pypi.org/project/hspylib-datasource/) :: HSPyLib - Datasource integration 
- [hspylib-vault](https://pypi.org/project/hspylib-vault/) :: HSPyLib - Secrets Vault 
- [hspylib-cfman](https://pypi.org/project/hspylib-cfman/) :: HSPyLib - CloudFoundry manager 
- [hspylib-firebase](https://pypi.org/project/hspylib-firebase/) :: HSPyLib - Firebase integration 
- [hspylib-hqt](https://pypi.org/project/hspylib-hqt/) :: HSPyLib - QT framework extensions 
- [hspylib-clitt](https://pypi.org/project/hspylib-clitt/) :: HSPyLib - CLI Terminal Tools

The HsPyLib project is also licensed under the MIT license and is hosted on GitHub at: https://github.com/yorevs/hspylib.

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
      - [1.1.5.1. Terminal App](#terminal-app-darwin)
      - [1.1.5.2. iTerm2 App](#iterm2-app-darwin)
  * [1.1. Try-it first](#try-it-first)
  * [1.2. Remote installation](#remote-installation)
  * [1.3. Local installation](#local-installation)
  * [1.4. Firebase setup](#firebase-setup)
    + [1.4.1. Create account](#create-new-account)
    + [1.4.2. Configure account](#configure-account)
- [2. Uninstallation](#uninstallation)
- [3. HomeSetup usage](#homesetup-usage)
- [4. Built-in dotfiles](#built-in-dotfiles)
- [5. Aliases](#aliases)
  * [5.1. Navigational](#navigational)
  * [5.2. General](#general)
  * [5.3. HomeSetup](#homesetup)
  * [5.4. External tools](#external-tools)
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
  * [7.1. Built-ins](#built-ins)
- [8. Alias Definitions](#alias-definitions)
- [9. HomeSetup application](#homesetup-application)
  * [9.1. HHS-Plug-ins](#hhs-plug-ins)
  * [9.2. HHS-Built-Ins](#hhs-built-ins)
- [10. Auto completions](#auto-completions)
  * [10.1. Bash completions](#bash-completions)
- [11. Support HomeSetup](#support-homesetup)
- [12. Final notes](#final-notes)
- [13. Contacts](#contacts)

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

While it's possible to install HomeSetup on **other Linux** distributions and it might work, it's important to note that
**there are no guarantees** of its _full functionality or compatibility_.

#### Supported Shells

- Bash: Everything from 3.2.57(1) and higher.
- Zsh: Zsh is not supported yet.

#### Required software

The following software are required either to clone the repository, execute tests and install all of the packages:

##### Darwin and Linux

- **git** v2.20+ : To clone and maintain the code.
- **sudo** v1.5+ : To enable sudo commands.
- **curl** v7.64+ : To make http(s) requests.
- **vim** v5.0+ : To edit your dotfiles.
- **python** v3.10+ : To run python based scripts.
- **python3-pip** : To install required python packages.
- **pip** v3.10+ : To install python modules.
- **gpg** v2.2+ : To enable encryption based functions.

##### Darwin only

- **brew** v2.0+ : To install the required tools.
- **xcode-select** v2373+: To install command line tools.

##### Ubuntu required packages

- locales 
- libpq-dev 

##### Fedora required packages

- findutils 
- procps 
- uptimed 
- glibc-common
- net-tools

##### Centos required packages

- wget 
- glibc-common 
- libpq-devel 
- openssl-devel 
- bzip2-devel 
- libffi-devel

#### Recommended software

HomeSetup depends on a series of tools. To use some of the features of HomeSetup, the following packages are required:

- **bats-core** v0.4+ : To run the automated tests.
- **perl** v5.0+ : To enable perl based functions.
- **dig** v9.10+ : To enable networking functions.
- **tree** v1.8+ : To enable directory visualization functions.
- **ifconfig** v8.43+ : To enable networking functions.
- **hostname** any : To enable hostname management functions.

#### Optional software

If you're a developer, there are several tools that can greatly enhance your workflow. HomeSetup offers a range of 
features specifically designed to improve the usage of the following tools:

- **docker** 19.03+ : To enable docker functions.
- **gradle** 4+ : To enable gradle functions.

#### Terminal setup

To fully utilize the Font-Awesome icons in HomeSetup, you'll need a compatible font. We recommend using the font we 
provide:

* [Droid font](misc/fonts/Droid-Sans-Mono-for-Powerline-Nerd-Font-Complete.otf).

Before installing or trying HomeSetup, make sure to install this font on your machine. Otherwise, you may see **question 
mark icons** instead of the **actual ones**.

**Linux users**: Some terminals already support icons, but if not, you can manually install the font.

**Mac users**: We suggest using one of the terminal profiles listed below to ensure optimal icon display:

##### Terminal App (Darwin)

* Import the HomeSetup-(14|15)-inch.terminal from "$HHS_HOME/misc" to your Terminal App.
* Set HomeSetup as the default profile.

##### iTerm2 App (Darwin)

* Import the iterm2-terminal-(14|15)-inch.json from "$HHS_HOME/misc" to your iTerm2 App.
* Set HomeSetup as the default profile.

### Try-it first

You have the option to run HomeSetup from a [Docker container](https://www.docker.com/), allowing you to evaluate its 
functionality before deciding to install it on your machine. To do this, follow these steps:

1. Start by pulling the Docker image you wish to try by executing one of the following commands:
    ```bash
    $ docker run --rm -it yorevs/hhs-centos
    $ docker run --rm -it yorevs/hhs-ubuntu
    $ docker run --rm -it yorevs/hhs-fedora
    ```

2. Once the image is successfully pulled, you can proceed to run HomeSetup within the Docker container, explore its features, and evaluate its suitability for your needs.

Running HomeSetup in a Docker container offers a convenient and isolated environment for testing purposes, ensuring 
that your machine remains unaffected during the evaluation process.

### Remote installation

This is the recommended installation method. You can install HomeSetup directly from GitHub by executing onr of the
following commands:

`$ curl -o- https://raw.githubusercontent.com/yorevs/homesetup/master/install.bash | bash`

or

`$ wget -qO- https://raw.githubusercontent.com/yorevs/homesetup/master/install.bash | bash`

### Local installation

Clone the HomeSetup repository:

`$ git clone https://github.com/yorevs/homesetup.git ~/HomeSetup`

And then install all dotfiles using the following command:

`$ cd ~/HomeSetup && ./install.bash` => **To install all files at once**

or

`$ cd ~/HomeSetup && ./install.bash -i` => **To install one by one**

Your existing dotfiles (such as .bashrc, .bash_profile, etc.) will be backed up with the **'.orig'** suffix and stored 
in the **~/.hhs/backup** folder. This ensures that your original dotfiles are safely preserved during the installation
process.

### Post-Installation

Once the installation is completed successfully, you should see the following welcome message:

![HomeSetup Welcome](https://iili.io/H8lOPxS.png "Welcome to HomeSetup")

### Firebase setup

HomeSetup provides the capability to utilize your Firebase account for uploading and downloading your custom files
(dotfiles file synchronization) to your *Real-time Database*. To utilize this feature, you must first configure your 
Google Firebase account.

#### Create new account

If you have a Google account but don't have a Firebase account yet, you can create one using your Google credentials.

Access: [https://console.firebase.google.com/](https://console.firebase.google.com/)

1. Create a *new Project* (HomeSetup).
2. Create a Database (in **production mode**):
   - Go to Develop -> Database -> Create Database.
   - Select **Real-time Database**.
   - Navigate to the **Rules** tab.
3. Add the following rule to your HomeSetup **ruleset**.

```json
{
  /* Visit https://firebase.google.com/docs/database/security to learn more about security rules. */
  "rules": {
    "homesetup": {
      ...
      "dotfiles": {
        ".read": "false",
        ".write": "false",
        "$uid" : { 
            ".read": "true",
            ".write": "true"
          }
        },
      ...
    }
  }
}
```

#### Configure account

To configure your Firebase account for use with HomeSetup, follow these steps:

1. Configure the read and write permissions as shown in section [1.3.1.](#create-new-account) of the documentation.
2. Access your account from: [https://console.firebase.google.com/](https://console.firebase.google.com/)
3. Create a service key to **enable read/write access** to your Firebase account:

   - Click on *Authentication* in the left menu, then select *Users*.
   - Obtain your **USER UID** and Identifier (email).
   - Click on the *cogwheel icon* and choose *Project settings*.
   - Go to the *Service accounts* tab.
   - Obtain your **Project ID**.
   - Click on *Generate new private key*.
   - Save the generated file into the **$HHS_DIR** directory (usually ~/.hhs).
   - Rename the file to *<project-id>-firebase-credentials.json*.

   For more details, consult the [Firebase help page](https://console.firebase.google.com/u/1/project/homesetup-37970/settings/serviceaccounts/adminsdk).

4. In a shell, run the command `$ firebase setup` and fill in the setup form as follows:

   ![Firebase Setup](https://iili.io/H8ll1pa.png "Firebase Setup")

You have now successfully configured Firebase for use with HomeSetup. To learn more about using Firebase features, 
type in your shell: 

`$ firebase help`

## Uninstallation

If you choose to uninstall HomeSetup and restore your old dotfiles, you can do so by issuing the following command 
in a shell: 

`# HomeSetup> ./uninstall.bash`

The uninstaller will remove all files and folders associated with HomeSetup. The only folder that will remain is 
the $HHS_DIR (~/.hhs typically), whereas your configurations were stored. After a successful uninstallation, it is safe
to delete this folder if you no longer need it, **HOWEVER ALL CUSTOM DOTFILES WILL BE GONE**.

## HomeSetup usage

HomeSetup offers a comprehensive [User Handbook](docs/handbook/USER_HANDBOOK.md) that contains detailed documentation
on all commands and examples of their usage. Additionally, there will soon be a _YouTube video_ available that guides
you through the installation, usage, configuration, and utilization of all the features and enhancements provided.

The User Handbook serves as a valuable resource for understanding and making the most of HomeSetup's capabilities, 
while the accompanying YouTube and [asciinema](https://asciinema.org/~yorevs) videos provides a visual demonstration of 
its usage.

## Built-in dotfiles

The following dotfiles will be available after installing HomeSetup:

| HHS Dotfile         | Description                |
|---------------------|----------------------------|
| ~/.bashrc           | Bash resources             |
| ~/.bash_profile     | Profile bash               |
| ~/.bash_aliases     | HomeSetup built-in aliases |
| ~/.bash_prompt      | Enhanced shell prompt      |
| ~/.bash_env         | Environment variables      |
| ~/.bash_colors      | Terminal color definitions |
| ~/.bash_functions   | Bash scripting functions   |

The following directories will be created in your <$HHS_DIR> folder:

- `$HHS_DIR/bin` # Includes all useful scripts provided by the project.
- `$HHS_DIR/log` # Includes all HomeSetup log files.
- `$HHS_DIR/backup` # Includes all HomeSetup backup files.

If the installation folder already exists, the install script will replace all files, taking care to back up the 
important ones. To override or add customized configurations, you can create a custom file using the following:

| Custom Dotfile     | Description                                      |
|--------------------|--------------------------------------------------|
| ~/.colors          | To customize your colors                         |
| ~/.env             | To customize your environment variables          |
| ~/.aliases         | To customize your aliases                        |
| ~/.prompt          | To customize your prompt                         |
| ~/.functions       | To customize your functions                      |
| ~/.profile         | To customize your profile                        |
| ~/.path            | To customize your paths                          |
| ~/.aliasdef        | To customize your alias definitions              |

## Aliases

HomeSetup will provide many useful aliases (shortcuts) to your terminal:

### Navigational

| ALIAS | Equivalent | Description                                      |
|-------|------------|--------------------------------------------------|
| ...   | cd ...     | Change-back two previous directories             |
| ....  | cd ....    | Change-back three previous directories           |
| ..... | cd .....   | Change-back four previous directories            |
| ~     | cd ~       | Change the current directory to HOME dir         |
| \-    | cd -       | Change the current directory to the previous dir |
| ?     | pwd        | Display the current directory path               |

### General

| ALIAS | Description                                                        |
|-------|--------------------------------------------------------------------|
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
| ifs   | Display current value of IFS                                       |
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
| ps2   | Make _PS2_ prompt active (continuation prompt)                     |

### HomeSetup

| ALIAS          | Description                                                       |
|----------------|-------------------------------------------------------------------|
| __hhs_hspm     | Alias for `hhs hspm` plug-in                                      |
| __hhs_hhu      | Alias for `hhs updater` plug-in                                   |
| __hhs_vault    | Alias for `hspylib vault` application                             |
| __hhs_firebase | Alias for `hspylib firebase` application                          |
| __hhs_reload   | Alias to reload HomeSetup                                         |
| __hhs_clear    | Alias to clear and reset cursor attributes and **IFS**            |
| __hhs_reset    | Alias to clear screen and reset the terminal                      |
| __hhs_open     | Alias to use the assigned application to open a file or directory |
| __hhs_hspylib  | Alias to access HSPyLib python application                        |

### External tools

| ALIAS              | Description                                                                      |
|--------------------|----------------------------------------------------------------------------------|
| jenv_set_java_home | Jenv - Set JAVA_HOME using jenv                                                  |
| cleanup-db         | Dropbox - Recursively delete Dropbox conflicted files from the current directory |
| encode             | Shortcut for base64 encode                                                       |

### OS Specific aliases

#### Linux

| ALIAS  | Description                     |
|--------|---------------------------------|
| cpu    | `top' shortcut ordered by CPU % |
| mem    | `top' shortcut ordered by MEM % |
| ised   | Same as sed -i'' -r             |
| esed   | Same as sed -r                  |
| decode | Shortcut for base64 decode      |
| apt    | Same as apt-get                 |

#### Darwin

| ALIAS          | Description                                                              |
|----------------|--------------------------------------------------------------------------|
| cpu            | `top' shortcut ordered by CPU %                                          |
| mem            | `top' shortcut ordered by MEM %                                          |
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
|--------------------|--------------------------------------|
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

| ALIAS   | Description                         |
|---------|-------------------------------------|
| calc    | Evaluate mathematical expressions   |
| urle    | URL-encode strings                  |
| urld    | URL-decode strings                  |
| uuid    | Generate a random UUID              |

### Perl aliases

| ALIAS         | Description                            |
|---------------|----------------------------------------|
| clean_escapes | Remove escape (\EscXX) codes from text |
| clipboard     | Copy to clipboard **pbcopy required**  |

### Git aliases

| ALIAS                 | Description                             |
|-----------------------|-----------------------------------------|
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
|-----------------------|------------------------------------------------------|
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
|---------------------------|----------------------------------------------|
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


### Dotfiles

HomeSetup include some basic helper functions:

| Dotfile              | Function               | Purpose                                                                       |
|----------------------|------------------------|-------------------------------------------------------------------------------|
| bash_prompt.bash     | __hhs_git_prompt       | Check whether inside a git repository or not, and which branch is checked     |
| bash_commons.bash    | __hhs_has              | Check if a command is available on the current shell context                  |
|                      | __hhs_log              | Log to HomeSetup log file                                                     |
|                      | __hhs_source           | Read/Execute commands from the filename argument in the current shell context |
|                      | __hhs_is_reachable     | Check whether URL/URI is reachable on the network                             |
| bash_aliases.bash    | __hhs_alias            | Check if an alias does not exists and create it, otherwise ignore it          |
| bash_completion.bash | __hhs_check_completion | Check and add completion for tool if found in HHS completions dir             |
|                      | __hhs_load_completions | Load all available auto-completions                                           |

### Standard tools

The complete handbook of standard tools can be found on the [functions handbook](docs/handbook/pages/functions.md#standard-tools)

| File                   | Function                | Purpose                                                                                      |
|------------------------|-------------------------|----------------------------------------------------------------------------------------------|
| hhs-aliases.bash       | __hhs_aliases           | Manipulate custom aliases (add/remove/edit/list).                                            |
| hhs-built-ins.bash     | __hhs_random            | Generate a random number int the range <min> <max> (all limits included).                    |
|                        | __hhs_ascof             | Convert string into it's decimal ASCII representation.                                       |
|                        | __hhs_open              | Open a file or URL with the default program.                                                 |
|                        | __hhs_edit              | Create and/or open a file using the default editor                                           |
|                        | __hhs_utoh              | Convert unicode to hexadecimal                                                               |
| hhs-clitt.bash         | __hhs_minput            | Provide a terminal form input with simple validation.                                        |
|                        | __hhs_mchoose           | Choose options from a list using a navigable menu.                                           |
|                        | __hhs_mselect           | Select an option from a list using a navigable menu.                                         |
| hhs-command.bash       | __hhs_command           | Add/Remove/List/Execute saved bash commands.                                                 |
| hhs-dirs.bash          | __hhs_list_tree         | List all directories recursively (Nth level depth) as a tree.                                |
|                        | __hhs_save_dir          | Save one directory path for future __hhs_load.                                               |
|                        | __hhs_change_dir        | Change the current working directory to a specific Folder.                                   |
|                        | __hhs_load_dir          | Change the current working directory to pre-saved entry from __hhs_save.                     |
|                        | __hhs_godir             | Search and cd into the first match of the specified directory name.                          |
|                        | __hhs_mkcd              | Create all folders using a slash or dot notation path and immediately change into it.        |
|                        | __hhs_changeback_ndirs  | Change back the current working directory by N directories.                                  |
|                        | __hhs_dirs              | Display the list of currently remembered directories.                                        |
| hhs-files.bash         | __hhs_ls_sorted         | List files sorted by the specified column.                                                   |
|                        | __hhs_del_tree          | Move files recursively to the Trash.                                                         |
| hhs-network.bash       | __hhs_ip_info           | Retrieve information about the specified IP.                                                 |
|                        | __hhs_ip_lookup         | Lookup DNS payload to determine the IP address.                                              |
|                        | __hhs_ip_resolve        | Resolve domain names associated with the specified IP.                                       |
|                        | __hhs_active_ifaces     | Display a list of active network interfaces.                                                 |
|                        | __hhs_port_check        | Check the state of local port(s).                                                            |
|                        | __hhs_ip                | Display the associated machine IP of the given kind.                                         |
| hhs-paths.bash         | __hhs_paths             | Manage your custom PATH entries.                                                             |
| hhs-profile-tools.bash | __hhs_activate_nvm      | Lazy load helper function to initialize NVM for the terminal.                                |
|                        | __hhs_activate_rvm      | Lazy load helper function to initialize RVM for the terminal.                                |
|                        | __hhs_activate_jenv     | Lazy load helper function to initialize Jenv for the terminal.                               |
|                        | __hhs_activate_docker   | Lazy load helper function to initialize Docker-Daemon for the terminal.                      |
| hhs-punch.bash         | __hhs_punch             | PUNCH-THE-CLOCK. This is a helper tool to aid with the timesheet.                            |
| hhs-search.bash        | __hhs_search_file       | Search for files and links to files recursively.                                             |
|                        | __hhs_search_dir        | Search for directories and links to directories recursively.                                 |
|                        | __hhs_search_string     | Search in files for strings matching the specified criteria recursively.                     |
| hhs-security.bash      | __hhs_encrypt_file      | Encrypt file using GPG.                                                                      |
|                        | __hhs_decrypt_file      | Decrypt a GPG encrypted file.                                                                |
| hhs-shell-utils.bash   | __hhs_shell_select      | Select a shell from the existing shell list.                                                 |
|                        | __hhs_history           | Search for previously issued commands from history using filters.                            |
|                        | __hhs_envs              | Display all environment variables using filters.                                             |
|                        | __hhs_defs              | Display all alias definitions using filters.                                                 |
| hhs-sys-utils.bash     | __hhs_sysinfo           | Display relevant system information.                                                         |
|                        | __hhs_process_kill      | Kills ALL processes specified by name                                                        |
|                        | __hhs_partitions        | Exhibit a Human readable summary about all partitions.                                       |
|                        | __hhs_process_list      | Display a process list matching the process name/expression.                                 |
| hhs-taylor.bash        | __hhs_tailor            | Tail a log using colors and patterns specified on `.tailor' file                             |
| hhs-text.bash          | __hhs_errcho            | Echo a message in red color into stderr.                                                     |
|                        | __hhs_highlight         | Highlight words from the piped stream.                                                       |
|                        | __hhs_json_print        | Pretty print (format) JSON string.                                                           |
| hhs-toolcheck.bash     | __hhs_about             | Display information about the given command.                                                 |
|                        | __hhs_toolcheck         | Check whether a tool is installed on the system.                                             |
|                        | __hhs_help              | Display a help for the given command.                                                        |
|                        | __hhs_version           | Check the version of the app using the most common ways.                                     |
|                        | __hhs_tools             | Check whether a list of development tools are installed or not.                              |
| bash_aliases.bash      | __hhs_alias             | Check if an alias does not exists and create it, otherwise just ignore it. Do not support... |
| bash_commons.bash      | __hhs_has               | Check if a command is available on the current shell session.                                |
|                        | __hhs_log               | Log a message to the HomeSetup log file.                                                     |
|                        | __hhs_source            | Replacement for the original source bash command.                                            |
|                        | __hhs_is_reachable      | Check whether an URL is reachable.                                                           |
| bash_completion.bash   | __hhs_check_completion  | Check and add completion for tool if found in HHS completions dir.                           |
|                        | __hhs_load_completions  | Load all available auto-completions.                                                         |
| bash_prompt.bash       | __hhs_git_prompt        | Retrieve the current git branch if inside a git repository.                                  |

### Development tools

The complete handbook of development tools can be found [here](docs/handbook/pages/functions.md#development-tools)

| File                  | Function                     | Purpose                                                                             |
|-----------------------|------------------------------|-------------------------------------------------------------------------------------|
| hhs-docker-tools.bash | __hhs_docker_kill_all        | Stop, remove and remove dangling [active?] volumes of all docker containers.        |
|                       | __hhs_docker_count           | Count the number of active docker containers.                                       |
|                       | __hhs_docker_info            | Display information about the container.                                            |
|                       | __hhs_docker_exec            | Run a command or bash in a running container.                                       |
|                       | __hhs_docker_compose_exec    | This is the equivalent of docker exec, but for docker-compose.                      |
|                       | __hhs_docker_logs            | Fetch the logs of a container.                                                      |
|                       | __hhs_docker_remove_volumes  | Remove all docker volumes not referenced by any containers (dangling).              |
| hhs-git-tools.bash    | __hhs_git_branch_all         | Get the current branch name of all repositories from the base search path.          |
|                       | __hhs_git_status_all         | Get the status of current branch of all repositories from the base search path.     |
|                       | __hhs_git_branch_previous    | Checkout the previous branch in history (skips branch-to-same-branch changes ).     |
|                       | __hhs_git_show_file_diff     | Display a file diff comparing the version between the first and second commit IDs.  |
|                       | __hhs_git_show_file_contents | Display the contents of a file from specific commit ID.                             |
|                       | __hhs_git_show_changes       | List all changed files from a commit ID.                                            |
|                       | __hhs_git_pull_all           | Search and pull projects from the specified path using the given repository/branch. |
|                       | __hhs_git_branch_select      | Select and checkout a local or remote branch.                                       |
| hhs-gradle-tools.bash | __hhs_gradle                 | Prefer using the wrapper instead of the installed command itself.                   |

## Applications

HomeSetup includes a collection of useful applications that can be accessed directly from the shell. These applications
are also automatically added to your **$PATH** variable for easy execution.

For a comprehensive list and detailed information about the development tools available with HomeSetup, please refer 
to the [Applications](docs/handbook/pages/applications.md) section in the complete handbook.

### Built-ins

| Application      | Purpose                                                                                       |
|------------------|-----------------------------------------------------------------------------------------------|
| app-commons.bash | Commonly used bash code functions and variables that you may include it on your bash scripts. |
| check-ip.bash    | Validate and check information about a specified IP.                                          |
| fetch.bash       | Fetch REST APIs data easily.                                                                  |
| hhs.bash         | HomeSetup application.                                                                        |

## Alias definitions

You have the flexibility to customize **most of the HomeSetup aliases** by editing the `~/.aliasdef` file. When you 
initially install HomeSetup, this file will be automatically generated for you. However, future updates may require 
you to update this file. We always keep a backup of this file, allowing you to preserve your customizations. Please 
note that the backup process needs to be done manually in this case.

The original content and aliases are defined in the original [aliasdef](dotfiles/aliasdef) file. If you remove your 
`~/.aliasdef` file, the HomeSetup's original definitions file will be copied to your "$HHS_DIR" folder next time you
start you terminal.

## HomeSetup Application

HomeSetup is more than just a collection of scripts and functions to enhance your terminal experience. It also includes
an application framework and a variety of **plug-able scripts and functions** that can be seamlessly integrated into it. 
To view a comprehensive list of all available functions and plug-ins, you can simply run the following command in your 
terminal: `# __hhs list`. 

If you want to explore and check all the existing functions within HomeSetup, you can simply run the following command
in your terminal: `# __hhs funcs`.

Those commands will provide you with an overview of all the functions and plug-ins that HomeSetup offers, allowing you 
to explore and leverage their capabilities.

### HHS-Plug-ins

| Plug-in  | Purpose                                                                  |
|----------|--------------------------------------------------------------------------|
| updater  | Update manager for HomeSetup.                                            |
| firebase | Manager for HomeSetup Firebase integration.                              |
| hspm     | Manage your development tools using installation/uninstallation recipes. |

### HHS-Built-Ins

| Function    | Purpose                                                                                |
|-------------|----------------------------------------------------------------------------------------|
| host-name   | Retrieve/Get/Set the current hostname.                                                 |
| list        | List all HHS App **Plug-ins** and **Functions**.                                       |
| funcs       | Search for all hhs **functions** describing it's containing file name and line number. |
| logs        | Retrieve latest HomeSetup load logs.                                                   |
| man         | Open manual for command.                                                               |
| board       | Open the HomeSetup GitHub project **board** for the current version.                   |
| tests       | Execute all HomeSetup **automated tests**.                                             |
| color-tests | Execute all HomeSetup **terminal color tests**.                                        |

## Auto completions

In addition to the standard bash <tab> complete feature, HomeSetup introduces an enhanced completion functionality 
accessed through **<shift+tab>**. This feature allows you to iterate over the available options provided by the 
completion function, providing a more interactive experience.

By default, HomeSetup _does not load the completions_ during terminal startup to optimize performance. However, if you 
wish to load the completions and utilize this enhanced feature, you can issue the following command in your terminal: 
`$ __hhs_load_completions`

Executing this command will load the completions and enable the <shift+tab> complete functionality within HomeSetup.

### Bash completions

| File                           | Purpose                                           |
|--------------------------------|---------------------------------------------------|
| hhs-completion.bash            | Bash completion for HomeSetup.                    |
| brew-completion.bash           | Bash completion for Home Brew.                    |
| docker-completion.bash         | Bash completion file for core docker commands.    |
| docker-compose-completion.bash | Bash completion for docker-compose commands.      |
| docker-machine-completion.bash | Bash completion file for docker-machine commands. |
| git-completion.bash            | Bash/zsh completion support for core Git.         |
| gradle-completion.bash         | Bash and Zsh completion support for Gradle.       |
| helm-completion.bash           | Bash completion for helm.                         |
| kubectl-completion.bash        | Bash completion for kubectl.                      |
| pcf-completion.bash            | Bash completion for Cloud Foundry CLI.            |

## Support HomeSetup

You can support HomeSetup by [donating](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=J5CDEFLF6M3H4) 
or contributing code. Feel free to contact me for further details. When making code contributions, please make sure to 
review our [guidelines](docs/CONTRIBUTING.md) and adhere to our [code of conduct](docs/CODE_OF_CONDUCT.md).

Your support and contributions are greatly appreciated in helping us improve and enhance HomeSetup. Together, we can 
make it even better!

## Final notes

HomeSetup is designed to automatically fetch updates **every 7 days** from the time of installation. However, if you 
want to manually ensure that your HomeSetup is up to date, you can run the following command in your terminal: 

`$ hhs updater execute update`. 

This will install the latest version of HomeSetup, keeping your setup current and incorporating any new features and 
improvements. Keeping HomeSetup updated is essential to benefit from the latest enhancements and bug fixes. If you have 
any questions or encounter any issues during the update process, feel free to reach out for assistance.

## Contacts

- Documentation: [API](docs/handbook/USER_HANDBOOK.md)
- License: [MIT](LICENSE.md)
- Code: https://github.com/yorevs/homesetup
- Issue tracker: https://github.com/yorevs/homesetup/issues
- Official chat: https://gitter.im/yorevs-homesetup/community
- Contact: https://www.reddit.com/user/yorevs
- Mailto: [Yorevs](mailto:homesetup@gmail.com)


Happy scripting with HomeSetup!
