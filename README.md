# HomeSetup
## Your shell good as hell ! Not just dotfiles

Terminal .dotfiles and bash improvements for MacOS. HomeSetup is a bundle os scripts and dotfiles that will elevate 
your shell to another level. There are many improvements and facilities, especially for developers that will ease the
usage and highly improve your productivity. Currently we only support Bash (v3.4+) for Darwin (MacOS). We have plans
to adapt all of the code to be able to run under Linux and also, add support for Zsh.

## Table of contents

<!-- toc -->

- [Installation](#1.-Installation)
  * [Local Installation](#1.1-Local-installation)
  * [Remote Installation](#1.2-Remote-installation)
  * [Firebase Setup](#1.3-Firebase-setup)
    + [Create Account](#1.3.1-Create-new-account)
    + [Configure Account](#1.3.2-Configure-account)
- [Uninstallation](#2.-Uninstallation)
- [Dotfiles in this project](#3.-Dotfiles-in-this-project)
- [Aliases](#4.-Aliases)
- [Functions](#5.-Functions)
- [Applications](#6.-Applications)
  * [Python Apps](#6.1-Python-apps)
  * [Bash Apps](#6.2-Bash-apps)
- [Terminal Setup](#7.-Terminal-setup)
  * [Terminal.app](#7.1-Terminal.app)
  * [iTerm2.app](#7.2-iTerm2.app)

<!-- tocstop -->


### 1. Installation

#### 1.1 Local installation

Clone the repository using the following command:

`#> git clone https://github.com/yorevs/homesetup.git ~/HomeSetup`

And then install dotfiles using the following command:

`#> cd ~/HomeSetup && ./install.bash` => **To install one by one**

or

`#> cd ~/HomeSetup && ./install.bash --all` => **To install all files**

Your old dotfiles (.bash*) will be backed up using '.orig' suffix and sent to ~/.hhs folder.

#### 1.2 Remote installation

You can install HomeSetup directly from GitHub. To do that use the following command to clone and install:

`#> curl -o- https://raw.githubusercontent.com/yorevs/homesetup/master/install.bash | bash`

or

`#> wget -qO- https://raw.githubusercontent.com/yorevs/homesetup/master/install.bash | bash`

#### 1.3 Firebase setup

HomeSetup allows you to use your Firebase account to upload and download your custom files
(dotfiles files synchronization) to your *Realtime Database*. To be able to use this feature, you need first 
to configure your Google Firebase account.

##### 1.3.1 Create new account

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

##### 1.3.2 Configure account

In order to use your Firebase account with HomeSetup, you will need to configure the read and write permissions as 
showed on topic [1.3.1](#1.3.1-Create-new-account).

Access your account from: https://console.firebase.google.com/

Grab you *Project ID* from the settings Settings menu.

Type in a shell: `#> dotfiles --setup`

Fill in the information required.
You are now ready to use the Firebase features of HomeSetup.
Type: `#> dotfiles.bash help fb` for further information about using it.

### 2. Uninstallation

If you decide to, you can uninstall al HomeSetup files and restore your old dotfiles. To do that issue the command in a shell: `# HomeSetup> ./uninstall.bash`

The uninstaller will remove all files and folders related to HomeSetup for good.

### 3. Dotfiles in this project

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

### 4. Aliases

HomeSetup will provide many useful aliases (shortcuts) to your terminal:

#### 4.1 Navigational

ALIAS           | Equivalent      | Description
--------------- | --------------- | ---------------
...             | cd ...          | Change-back two previous directories
....            | cd ....         | Change-back three previous directories
.....           | cd .....        | Change-back four previous directories
~               | cd ~            | Change the current directory to HOME dir
\-              | cd -            | Change the current directory to the previous dir
?               | pwd             | Display the current directory path

#### 4.2 General

ALIAS           | Description
--------------- | ---------------
q               | Short for `exit 0' from terminal
sudo            | Enable aliases to be sudo’ed
ls              | Always use color output for **ls**
l               | List _all files_ colorized in long format
lsd             | List _all directories_ in long format
ll              | List _all files_ colorized in long format, **including dot files**
lll             | List _all **.dotfiles**_ colorized in long format
lld             | List _all **.dotfolders**_ colorized in long format
grep            | Always enable colored **grep** output
egrep           | Always enable colored **fgrep** output
fgrep           | Always enable colored **egrep** output
rm              | By default **rm** will prompt for confirmation and will be verbose
cp              | By default **cp** will prompt for confirmation and will be verbose
mv              | By default **mv** will prompt for confirmation and will be verbose
df              | Make **df** command output pretty and human readable format
du              | Make **du** command output pretty and human readable format
psg             | Make **ps** command output pretty and human readable format
vi              | Use **vim** instead of **vi** if installed
more            | **more** will interpret escape sequences
less            | **less** will interpret escape sequences
mount           | Make `mount' command output pretty and human readable format
cpu             | **top** shortcut ordered by _cpu_
mem             | **top** shortcut ordered by _Memory_
week            | Date&Time - Display current **week number**
now             | Date&Time - Display current **date and time**
ts              | Date&Time - Display current **timestamp**
wget            | If **wget** is not available, use **curl** instead
ps1             | Make _PS1_ prompt active
ps2             | Make _PS2_ prompt active
jq              | Use `jq' to format json instead of `json_pp' if installed

#### 4.3 HomeSetup

ALIAS           | Description
--------------- | ---------------
__hhs_vault     | Shortcut for hhs vault plug-in
__hhs_hspm      | Shortcut for hhs hspm plug-in
__hhs_dotfiles  | Shortcut for hhs firebase plug-in
__hhs_hhu       | Shortcut for hhs updater plug-in
__hhs_reload    | Reload HomeSetup
__hhs_clear     | Clear and reset all cursor attributes and IFS
__hhs_reset     | Clear the screen and reset the terminal

#### 4.4 Tool aliases

ALIAS               | Description
------------------- | -------------------
jenv_set_java_home  | Jenv - Set JAVA_HOME using jenv
cleanup-db          | Dropbox - Recursively delete Dropbox conflicted files from the current directory
encode              | Shortcut for base64 encode

#### 4.5 OS Specific aliases

##### 4.5.2 Linux

ALIAS           | Description
--------------- | ---------------
ised            | Same as sed -i'' -r (Linux)
esed            | Same as sed -r (Linux)
decode          | Shortcut for base64 decode (Linux)

##### 4.5.2 Darwin

ALIAS           | Description
--------------- | ---------------
ised            | Same as sed -i '' -E (Darwin)
esed            | Same as sed -E (Darwin)
decode          | Shortcut for **base64** decode (Darwin)
cleanup-ds      | Delete all _.DS_store_ files recursively
flush           | Flush Directory Service cache
cleanup-reg     | Clean up LaunchServices to remove duplicates in the **"Open With"** menu
show-files      | Show hidden files in Finder
hide-files      | Hide hidden files in Finder
show-deskicons  | Show all desktop icons
hide-deskicons  | Hide all desktop icons
hd              | Canonical hex dump; some systems have this symlinked
md5sum          | If **md5sum** is not available, use **md5** instead`
sha1            | If **sha1** is not available, use **shasum** instead`


#### 4.6 Handy Terminal Shortcuts

ALIAS               | Description
------------------- | -------------------
show-cursor         | Make terminal cursor visible
hide-cursor         | Make terminal cursor invisible
save-cursor-pos     | Save terminal cursor position
restore-cursor-pos  | Restore terminal cursor position
enable-line-wrap    | Enable terminal line wrap
disable-line-wrap   | Disable terminal line wrap
enable-echo         | Enable terminal echo
disable-echo        | Disable terminal echo
reset-cursor-attrs  | Reset all terminal cursor attributes

#### 4.7 Python aliases
ALIAS           | Description
--------------- | ---------------
json_pp         | If **json_pp** is not available, use **python** instead
calc            | Evaluate mathematical expressions
urle            | URL-encode strings
urld            | URL-decode strings
uuid            | Generate a random UUID

#### 4.8 Perl aliases
ALIAS           | Description
--------------- | ---------------
clean_escapes   | Remove escape (\EscXX) codes from text
clipboard       | Copy to clipboard **pbcopy required**

#### 4.9 Git aliases

ALIAS                   | Description
----------------------- | -----------------------
__hhs_git_status        | Git - Enhancement for **git status**
__hhs_git_fetch         | Git - Shortcut for **git fetch**
__hhs_git_history       | Git - Shortcut for **git log**
__hhs_git_branch        | Git - Shortcut for **git branch**
__hhs_git_diff          | Git - Shortcut for **git diff**
__hhs_git_pull          | Git - Shortcut for **git pull**
__hhs_git_log           | Git - Enhancement for **git log**
__hhs_git_checkout      | Git - Shortcut for git **checkout**
__hhs_git_add           | Git - Shortcut for git **add**
__hhs_git_commit        | Git - Shortcut for git **commit**
__hhs_git_amend         | Git - Shortcut for git **commit amend**
__hhs_git_pull_rebase   | Git - Shortcut for git **pull rebase**
__hhs_git_push          | Git - Shortcut for git **push**
__hhs_git_show          | Git - Enhancement for **git diff-tree**
__hhs_git_difftool      | Git - Enhancement for **git difftool**

#### 4.10 Gradle aliases

ALIAS                   | Description
----------------------- | -----------------------
__hhs_gradle_build      | Gradle - Enhancement for **gradle build**
__hhs_gradle_run        | Gradle - Enhancement for **gradle bootRun**
__hhs_gradle_test       | Gradle - Shortcut for **gradle Test**
__hhs_gradle_init       | Gradle - Shortcut for **gradle init**
__hhs_gradle_quiet      | Gradle - Shortcut for **gradle -q**
__hhs_gradle_wrapper    | Gradle - Shortcut for **gradle wrapper**
__hhs_gradle_projects   | Gradle -  Displays all available gradle projects
__hhs_gradle_tasks      | Gradle - Displays all available gradle project tasks


#### 4.11 Docker aliases

ALIAS                       | Description
--------------------------- | ---------------------------
__hhs_docker_images         | Docker - Enhancement for docker images
__hhs_docker_service        | Docker - Shortcut for docker service
__hhs_docker_logs           | Docker - Shortcut for docker logs
__hhs_docker_remove         | Docker - Shortcut for docker container rm
__hhs_docker_remove_image   | Docker - Shortcut for docker rmi
__hhs_docker_ps             | Docker - Enhancement for docker ps
__hhs_docker_top            | Docker - Enhancement for docker stats
__hhs_docker_ls             | Docker - Enhancement for docker container ls
__hhs_docker_up             | Enhancement for `docker compose up
__hhs_docker_down           | Shortcut for `docker compose stop

**Please check: [bash_aliases](dotfiles/bash/bash_aliases.bash) for all aliases**

### 5. Functions

This project adds many script functions the shell. All functions provide a help using the options -h or --help.

Function        | Purpose
--------------- | ---------------
encrypt         | Encrypt file using GPG encryption.
decrypt         | Decrypt file using GPG encryption.
hl              | Highlight words from the piped stream.
sf              | Search for **files** and **links to files** recursively.
sd              | Search for **directories** and **links to directories** recursively.
ss              | Search for **strings** matching the specified criteria in files recursively.
hist            | Search for previous issued commands from history using filters.
del-tree        | Move files recursively to the **Trash**.
jp              | Pretty print **(format) JSON** string.
ip-info         | Check information about the specified IP.
ip-resolve      | Resolve domain names associated with the IP.
ip-lookup       | Lookup DNS entries to determine the IP address.
port-check      | Check the state of **local port(s)**.
envs            | Prints all **environment variables** on a separate line using filters.
paths           | Print each **PATH entry** on a separate line.
ver             | Check the **version** of the app using the most common ways.
tc              | Check whether a **tool** is installed on the system.
tools           | Check whether a list of **development tools** are installed.
mselect         | Select an option from a list using a navigable menu.
aa              | Manipulate custom aliases **(add/remove/edit/list)**.
save            | **Save** the one directory to be loaded by *load*.
load            | **Pushd** into a saved directory issued by *save*.
cmd             | Add/Remove/List/Execute saved bash commands.
punch           | Punch the Clock. Add/Remove/Edit/List clock punches.
plist           | Display a process list matching the process name/expression.
godir           | **Pushd** from the first match of the specified directory name.
git-            | GIT Checkout the previous branch in history **(skips branch-to-same-branch changes )**.
sysinfo         | Retrieve relevant system information.
parts           | Exhibit a Human readable summary about all partitions.
hhu             | Check the current **HomeSetup** installation and look for updates..

**Please check: [bash_functions](dotfiles/bash/bash_functions.bash) for all functions**

### 6. Applications

The project contains some useful scripts that can be used directly from shell. It is also added to your path variable.

#### 6.1 Python apps

Function        | Purpose
--------------- | ---------------
tcalc.py        | Simple app to do mathematical calculations with time.
free.py         | Report system memory usage.
json-find.py    | Find an object from the Json string or file.
pprint-xml.py   | Pretty print (format) an xml file.
send-msg.py     | IP Message Sender. Sends UDP/TCP messages using multi-threads.
hhu             | Check for HomeSetup updates.

#### 6.2 Bash apps

Function                | Purpose
----------------------- | -----------------------
dotfiles.bash           | Manage your HomeSetup .dotfiles and more.
hspm.bash               | Manage your development tools using installation/uninstallation recipes.
fetch.bash              | Script to fetch REST APIs data.
git-completion.bash     | bash/zsh completion support for core Git.
git-diff-cmd.bash       | Enable opendiff to be used with git instead of normal diff.
hostname-change.bash    | Change the hostname permanently.
ip-utils.bash           | Validate an IP and check details about it.
toolcheck.bash          | Check if the a tool is installed on the system.

**Please check: [bin](./bin) for all scripts**

### 7. Terminal setup

#### 7.1 Terminal.app

HomeSetup suggests a terminal profile to use. If you want to, you will need to do the following steps:

* [x] Install the terminal font from '$HHS_HOME/misc/fonts/Droid-Sans-Mono-for-Powerline-Nerd-Font-Complete.otf'.
* [x] Import the HomeSetup.terminal from "$HHS_HOME/misc/HomeSetup.terminal" to your Terminal App.
* [x] Set HomeSetup as the default profile.

#### 7.2 iTerm2.app

TODO: https://www.iterm2.com/features.html


Done! Now you have your terminal just like mine.

**To keep your HomeSetup updated, run `#> hhu` often, to update (git pull) to the latest HomeSetup code**

