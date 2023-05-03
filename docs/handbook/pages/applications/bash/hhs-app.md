# HomeSetup Applications Handbook

## Table of contents

<!-- toc -->
- [Bash Applications](../../applications.md)
  * [App-Commons](app-commons.md#application-commons)
  * [Check-IP](check-ip.md#check-ip-application)
  * [Fetch](fetch.md#fetch-application)
  * [HHS-App](hhs-app.md#homesetup-application)
    + [Functions](hhs-app.md#functions)
    + [Plugins](hhs-app.md#plug-ins)
<!-- tocstop -->

## HomeSetup application

```bash
Usage:  [option] {function | plugin {task} <command>} [args...]

    HomeSetup Application Manager.
    
    Options:
      -v  |  --version  : Display current program version.
      -h  |     --help  : Display this help message.
      -p  |   --prefix  : Display the HomeSetup installation directory.
    
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

## Functions

------
### External Tools

#### "host-name"

```bash
Usage: hhs host-name [new_hostname]
```

##### **Purpose**:

Retrieve/Get/Set the current hostname.

##### **Returns**:

**0** if the hostname was successfully changed/retrieved; **non-zero** otherwise.

##### **Parameters**: 

  - $1 _Optional_ : The new hostname. If not provided, current hostname is retrieved.

##### **Examples:**

```bash
  $ hhs host-name my.domain.hostname
  $ hhs host-name && echo 'This is the current hostname'
```


------
### Built-ins

#### "help"

```bash
Usage: hhs help <__hhs_command>
```

##### **Purpose**:

Display any HomeSetup command help.

##### **Returns**:

**0** if the command was successfully executed; **non-zero** otherwise.

##### **Parameters**: 

  - $1 _Required_ : The HomeSetup command to get help with.

##### **Examples:**

```bash
  $ hhs help hhs
  $ hhs help __hhs_has
```


------
#### "list"

```bash
Usage: hhs list [opts]
```

##### **Purpose**:

List all HHS App Plug-ins and Functions

##### **Returns**:

**0** if the command was successfully executed; **non-zero** otherwise.

##### **Parameters**: 

  - $1 _Optional_ : Instead of a formatted as a list, flat the commands for bash completion.

##### **Examples:**

```bash
  $ hhs list && echo 'This is the listing format'
  $ hhs list opts && echo 'This is the bash complete format'
```


------
#### "funcs"

```bash
Usage: hhs funcs
```

##### **Purpose**:

Search for all `__hhs_` functions pointing it's source file name and line number.

##### **Returns**:

**0** if the command was successfully executed; **non-zero** otherwise.

##### **Examples:**

```bash
  $ hhs funcs && echo 'Those are all available __hhs_ functions'
```


------
#### "logs"

```bash
Usage: hhs logs [log_level]
```

##### **Purpose**:

Retrieve HomeSetup logs. By default, this command is going to return 100 log lines. If the file contains more than that
you can set the environment variable HHS_LOG_LINES to a greater value and issue the command again.

##### **Returns**:

**0** if the command was successfully executed; **non-zero** otherwise.

##### **Examples:**

```bash
  $ hhs logs && echo 'Those are all HomeSetup logs'
  $ hhs logs warn && echo 'Those are all HomeSetup WARN logs'
```


------
#### "man"

```bash
Usage: hhs man <bash_command>
```

##### **Purpose**:

Fetch the ss64 manual from the web for the specified bash command.

##### **Returns**:

**0** if the command was successfully executed; **non-zero** otherwise.

##### **Examples:**

```bash
  $ hhs man grep && echo 'Open the manual page for grep command'
```


------
#### "board"

```bash
Usage: hhs board
```

##### **Purpose**:

Open the HomeSetup GitHub project board.

##### **Returns**:

**0** if the command was successfully executed; **non-zero** otherwise.

##### **Examples:**

```bash
  $ hhs board && echo 'Open HomeSetup issues board'
```

------
### Run tests

#### "tests"

```bash
Usage: hhs tests
```

##### **Purpose**:

Run all HomeSetup automated tests.

##### **Returns**:

**0** if all tests ran successfully; **non-zero** otherwise.

##### **Examples:**

```bash
  $ hhs tests && echo 'ALL TESTS PASSED'
```


------
#### "color-tests"

```bash
Usage: hhs color-tests
```

##### **Purpose**:

Run all terminal color palette tests.

##### **Returns**:

**0** if all color tests ran successfully; **non-zero** otherwise.

##### **Examples:**

```bash
  $ hhs color-tests && echo 'ALL TESTS PASSED'
```


------
## Plug-ins

### Firebase

```bash
usage: firebase [-h] [-v] [-d [CONFIG-DIR]] {setup,upload,download} ...

 _____ _          _
|  ___(_)_ __ ___| |__   __ _ ___  ___
| |_  | | '__/ _ \ '_ \ / _` / __|/ _ \
|  _| | | | |  __/ |_) | (_| \__ \  __/
|_|   |_|_|  \___|_.__/ \__,_|___/\___|

Firebase Agent v0.9.97 - Manage your firebase integration.

options:
  -h, --help            show this help message and exit
  -v, --version         show program's version number and exit
  -d [CONFIG-DIR], --config-dir [CONFIG-DIR]
                        the configuration directory. If omitted, the User's home will be used.

operation:
  {setup,upload,download}
                        the Firebase operation to process
    setup               setup your Firebase account
    upload              upload files to your Firebase Realtime Database
    download            download files from your Firebase Realtime Database

### Error firebase -> the following arguments are required: operation
```

##### **Purpose**:

Manager for HomeSetup Firebase integration.

##### **Returns**:

**0** if the command was successfully executed; **non-zero** otherwise.

##### **Examples:**

```bash
  $ hhs firebase setup' && echo 'Setup Firebase'
  $ hhs firebase upload work' && echo 'Upload dotfiles to `work\' db alias'
  $ hhs firebase download work'  && echo 'Download dotfiles from `work\' db alias'
```

------
### HSPM

```bash
 _   _ ____  ____  __  __ 
| | | / ___||  _ \|  \/  |
| |_| \___ \| |_) | |\/| |
|  _  |___) |  __/| |  | |
|_| |_|____/|_|   |_|  |_|

Manage your packages using installation/uninstallation recipes.

Usage: hspm [option] {install,uninstall,list,recover}

    Options:
      -v  |   --version     : Display current program version.
      -h  |      --help     : Display this help message.
    
    Arguments:
      install   <package>   : Install the package using a matching installation recipe.
      uninstall <package>   : Uninstall the package using a matching uninstallation recipe.
      list [-a]             : List all available installation recipes specified by ${HHS_DEV_TOOLS}. If -a is provided,
                              list even packages without any matching recipe.
      recover [-i][-t]      : Install or list all packages previously installed by hspm. If -i is provided, then hspm
                              will attempt to install all packages, otherwise the list is displayed. If -t is provided
                              hspm will check ${HHS_DEV_TOOLS} instead of previously installed packages.
```

##### **Purpose**:

Manage your packages using installation/uninstallation recipes.

##### **Returns**:

**0** if the command was successfully executed; **non-zero** otherwise.

##### **Examples:**

```bash
  $ hhs hspm execute list' && echo 'List all available recipes'
  $ hhs hspm execute install nvm' && echo 'Install nvm on the system'
  $ hhs hspm execute uninstall nvm' && echo 'Uninstall nvm on the system'
```

------
### Updater

```bash
 _   _           _       _            
| | | |_ __   __| | __ _| |_ ___ _ __ 
| | | | '_ \ / _` |/ _` | __/ _ \ '__|
| |_| | |_) | (_| | (_| | ||  __/ |   
 \___/| .__/ \__,_|\__,_|\__\___|_|   
      |_|                             

HomeSetup update manager.

Usage: updater updater [option] {check,update,stamp}

    Options:
      -v  |   --version : Display current program version.
      -h  |      --help : Display this help message.
      
    Arguments:
      check             : Fetch the last_update timestamp and check if HomeSetup needs to be updated.
      update            : Check the current HomeSetup installation and look for updates.
      stamp             : Stamp the next auto-update check for 7 days ahead.
```

##### **Purpose**:

HomeSetup update manager.

##### **Returns**:

**0** if the command was successfully executed; **non-zero** otherwise.

##### **Examples:**

```bash
  $ hhs updater execute check && echo 'Fetch last updated timestamp' 
  $ hhs updater execute update' && echo 'Attempt to update HomeSetup'
  $ hhs updater execute stamp' && echo 'Set next update check to 7 days ahead'
```
