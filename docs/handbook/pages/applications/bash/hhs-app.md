<img src="https://iili.io/HvtxC1S.png" width="64" height="64" align="right" />

# HomeSetup Developer Handbook
>
> Applications handbook

## Table of contents

<!-- toc -->

- [Bash Applications](../../applications)
  - [Check-IP](check-ip#check-ip)
  - [Fetch](fetch#fetch)
  - [HHS-App](hhs-app#homesetup-application)
    - [Functions](hhs-app#functions)
      - [Built-Ins](hhs-app/functions/built-ins)
      - [Misc](hhs-app/functions/misc)
      - [Tests](hhs-app/functions/tests)
      - [Web](hhs-app/functions/web)
    - [Plugins](hhs-app#plug-ins)
      - [Firebase](hhs-app/plugins/firebase)
      - [HSPM](hhs-app/plugins/hspm)
      - [Settings](hhs-app/plugins/settings)
      - [Setup](hhs-app/plugins/setup)
      - [Starship](hhs-app/plugins/starship)
      - [Updater](hhs-app/plugins/updater)

<!-- tocstop -->

## HomeSetup application

```bash
Usage:  [option] {function <args> | plugin [task <args>]}

 _   _                      ____       _
| | | | ___  _ __ ___   ___/ ___|  ___| |_ _   _ _ __
| |_| |/ _ \| '_ ` _ \ / _ \___ \ / _ \ __| | | | '_ \
|  _  | (_) | | | | | |  __/___) |  __/ |_| |_| | |_) |
|_| |_|\___/|_| |_| |_|\___|____/ \___|\__|\__,_| .__/
                                                |_|

  HomeSetup Application Manager v1.0.0.

    Arguments:
      args              : Plugin/Function arguments will depend on the plugin/functions and may be required or not.

    Options:
      -v  |  --version  : Display current program version.
      -h  |     --help  : Display this help message.
      -p  |   --prefix  : Display the HomeSetup installation directory.

    Tasks:
      help              : Display a help about the plugin.
      version           : Display current plugin version.
      execute           : Execute a plugin command.

    Exit Status:
      (0) Success.
      (1) Failure due to missing/wrong client input or similar issues.
      (2) Failure due to program/plugin execution failures.

  Notes:
    - To discover which plugins and functions are available type: hhs list
```

## Functions

## Plug-ins


------

### HSPM

```bash
Usage: hspm [option] {install,uninstall,list,recover}

 _   _ ____  ____  __  __
| | | / ___||  _ \|  \/  |
| |_| \___ \| |_) | |\/| |
|  _  |___) |  __/| |  | |
|_| |_|____/|_|   |_|  |_|

  HomeSetup package manager.

    Options:
      -v  |   --version     : Display current program version.
      -h  |      --help     : Display this help message.

    Arguments:
      install   <package>   : Install the package using a matching installation recipe.
      uninstall <package>   : Uninstall the package using a matching uninstallation recipe.
      list [-a]             : List all available installation recipes specified by ${HHS_DEV_TOOLS}. If -a is provided,
                              list even packages without any matching recipe.
      recover [-i,-t,-e]    : Install or list all packages previously installed by hspm. If -i is provided, then hspm
                              will attempt to install all packages, otherwise the list is displayed. If -t is provided
                              hspm will check ${HHS_DEV_TOOLS} instead of previously installed packages. If -e is
                              provided, then the default editor will open the recovery file.
```

#### **Purpose**

HomeSetup package manager.

#### **Returns**

**0** if the command was successfully executed; **non-zero** otherwise.

#### **Examples**

```bash
  hhs hspm execute list' && echo 'List all available recipes'
  hhs hspm execute install nvm' && echo 'Install nvm on the system'
  hhs hspm execute uninstall nvm' && echo 'Uninstall nvm on the system'
```

------

### Updater

```bash
Usage: updater updater [option] {check,update,stamp}

 _   _           _       _
| | | |_ __   __| | __ _| |_ ___ _ __
| | | | '_ \ / _` |/ _` | __/ _ \ '__|
| |_| | |_) | (_| | (_| | ||  __/ |
 \___/| .__/ \__,_|\__,_|\__\___|_|
      |_|

  HomeSetup update manager.

    Options:
      -v  |   --version : Display current program version.
      -h  |      --help : Display this help message.

    Arguments:
      check             : Fetch the last_update timestamp and check if HomeSetup needs to be updated.
      update            : Check the current HomeSetup installation and look for updates.
      stamp             : Stamp the next auto-update check for 7 days ahead.
```

#### **Purpose**

HomeSetup update manager.

#### **Returns**

**0** if the command was successfully executed; **non-zero** otherwise.

#### **Examples**

```bash
  hhs updater execute check && echo 'Fetch last updated timestamp'
  hhs updater execute update' && echo 'Attempt to update HomeSetup'
  hhs updater execute stamp' && echo 'Set next update check to 7 days ahead'
```
