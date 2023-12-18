<img src="https://iili.io/HvtxC1S.png" width="64" height="64" align="right" />

# HomeSetup Developer Handbook
>
> Applications handbook

## Table of contents

<!-- toc -->

- [Bash Applications](../../../../applications)
  - [Check-IP](../../check-ip#check-ip)
  - [Fetch](../../fetch#fetch)
  - [HHS-App](../../hhs-app#homesetup-application)
    - [Functions](../../hhs-app#functions)
      - [Built-Ins](../functions/built-ins)
      - [Misc](../functions/misc)
      - [Tests](../functions/tests)
      - [Web](../functions/web)
    - [Plugins](../../hhs-app#plug-ins)
      - [Firebase](firebase)
      - [HSPM](hspm)
      - [Settings](settings)
      - [Setup](setup)
      - [Starship](starship)
      - [Updater](updater)

<!-- tocstop -->

## Firebase

### "help"

#### **Purpose**

Display HHS-Firebase help message.

#### **Returns**

**0** if the command was successfully executed; **non-zero** otherwise.

#### **Parameters**

  - N/A

#### **Examples**

`__hhs firebase help`

**Output**

```bash
usage: firebase [-h] [-v] [-d [CONFIG-DIR]] {setup,upload,download} ...

 _____ _          _
|  ___(_)_ __ ___| |__   __ _ ___  ___
| |_  | | '__/ _ \ '_ \ / _` / __|/ _ \
|  _| | | | |  __/ |_) | (_| \__ \  __/
|_|   |_|_|  \___|_.__/ \__,_|___/\___|

Firebase Agent v0.9.143 - Manage your firebase integration.

options:
  -h, --help               show this help message and exit
  -v, --version            show program's version number and exit
  -d [CONFIG-DIR], --config-dir [CONFIG-DIR]
                           the configuration directory. If omitted, the User's home will be used.

operation:
  {setup,upload,download}  the Firebase operation to process
    setup                  setup your Firebase account
    upload                 upload files to your Firebase Realtime Database
    download               download files from your Firebase Realtime Database
```

------

### "setup"

#### **Purpose**

Setup you Firebase account for HomeSetup usage.

#### **Returns**

**0** if the command was successfully executed; **non-zero** otherwise.

#### **Parameters**

  - N/A

#### **Examples**

`__hhs firebase execute setup`

**Output**

```bash
### Firebase Setup ###
------------------------------
Please fill in your Realtime Database configurations
  UID        : FEE5B6F051654D75B64834162E79                       :   28/28
  PROJECT_ID : homesetup-12345                                    :   15/50
  EMAIL      : example@gmail.com                                  :   17/50
  DATABASE   : homesetup                                          :    9/50

 the uid

[Enter] Submit  [↑↓] Navigate  [↹] Next  [Space] Toggle  [^P] Paste  [Esc] Quit
```

------

### "upload"

#### **Purpose**

Upload your dotfiles to Firebase.

#### **Returns**

**0** if the command was successfully executed; **non-zero** otherwise.

#### **Parameters**

  - N/A

#### **Examples**

`__hhs firebase execute upload work`

**Output**

```bash
-=- Uploading files to \"work\" -=-

Uploading file  .path................. [  OK  ]
Uploading file  .cmd_file............. [  OK  ]
Uploading file  .homesetup.toml....... [  OK  ]
Uploading file  .last_dirs............ [  OK  ]
Uploading file  .saved_dirs........... [  OK  ]
Uploading file  .env.................. [  OK  ]
Uploading file  .colors............... [  OK  ]
Uploading file  .prompt............... [  OK  ]
Uploading file  .profile.............. [  OK  ]
Uploading file  .aliasdef............. [  OK  ]
Uploading file  .functions............ [  OK  ]
Uploading file  .starship.toml........ [  OK  ]
Uploading file  .aliases.............. [  OK  ]
Uploading file  .hspm................. [  OK  ]

File(s):
  |- .path
  |- .cmd_file
  |- .homesetup.toml
  |- .last_dirs
  |- .saved_dirs
  |- .env
  |- .colors
  |- .prompt
  |- .profile
  |- .aliasdef
  |- .functions
  |- .starship.toml
  |- .aliases
  |- .hspm

Successfully uploaded to Firebase !
```

------

### "download"

#### **Purpose**

Download your dotfiles from Firebase.

#### **Returns**

**0** if the command was successfully executed; **non-zero** otherwise.

#### **Parameters**

  - N/A

#### **Examples**

`__hhs firebase execute download work`

**Output**

```bash
-=- Downloading files from \"work\" -=-

Downloading files from Firebase into "/Users/runner/.hhs" ...

File(s):
  |- .path
  |- .cmd_file
  |- .homesetup.toml
  |- .last_dirs
  |- .saved_dirs
  |- .env
  |- .colors
  |- .prompt
  |- .profile
  |- .aliasdef
  |- .functions
  |- .starship.toml
  |- .aliases
  |- .hspm

Successfully downloaded into: "/Users/runner/.hhs"
```
