<img src="https://iili.io/HvtxC1S.png" width="64" height="64" align="right" />

# HomeSetup Developer Handbook
>
> Applications handbook

## Table of contents

<!-- toc -->

- [Bash Applications](../../applications.md)
  - [Check-IP](check-ip.md#check-ip)
  - [Fetch](fetch.md#fetch)
  - [HHS-App](hhs-app.md#homesetup-application)
    - [Functions](hhs-app.md#functions)
      - [Built-Ins](hhs-app/functions/built-ins.md)
      - [Misc](hhs-app/functions/misc.md)
      - [Tests](hhs-app/functions/tests.md)
      - [Web](hhs-app/functions/web.md)
    - [Plugins](hhs-app.md#plug-ins)
      - [Firebase](hhs-app/plugins/firebase.md)
      - [HSPM](hhs-app/plugins/hspm.md)
      - [Settings](hhs-app/plugins/settings.md)
      - [Setup](hhs-app/plugins/setup.md)
      - [Starship](hhs-app/plugins/starship.md)
      - [Updater](hhs-app/plugins/updater.md)

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
    - To discover which plugins and functions are available type: hhs list.
```

## Functions

TODO

## Plug-ins

TODO
