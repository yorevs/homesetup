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
      - [Built-Ins](built-ins)
      - [Misc](misc)
      - [Tests](tests)
      - [Web](web)
    - [Plugins](../../hhs-app#plug-ins)
      - [Firebase](../plugins/firebase)
      - [HSPM](../plugins/hspm)
      - [Settings](../plugins/settings)
      - [Setup](../plugins/setup)
      - [Starship](../plugins/starship)
      - [Updater](../plugins/updater)

<!-- tocstop -->

## Built-ins

### "list"

```bash
Usage: __hhs list [-flat] [-plugins] [-funcs]
```

#### **Purpose**

List all HHS App Plug-ins and Functions.

#### **Returns**

**0** if the command was successfully executed; **non-zero** otherwise.

#### **Parameters**

  - -flat     : Instead of a formatted list, flat the items (e.g:. for bash completion).
  - -plugins  : Filter the list to display only plug-ins.
  - -funcs    : Filter the list to display only functions.

#### **Examples**

`__hhs list`

**Output**

```bash
HomeSetup application commands

-=- HHS Plug-ins -=-

 1  settings
 2  starship
 3  setup
 4  updater
 5  firebase
 6  hspm

-=- HHS Functions -=-

 1  docsify
 2  board
 3  list
 4  funcs
 5  logs
 6  man
 7  reset
 8  host-name
 9  shopt
10  tests
11  color-tests
```

`__hhs list -flat`

**Output**

```bash
settings starship setup updater firebase hspm docsify board list funcs logs man reset host-name shopt tests color-tests
```

------

### "funcs"

```bash
Usage: __hhs funcs [regex_filter]
```

#### **Purpose**

Search for all `__hhs` functions pointing it's source file name and line number.

#### **Returns**

**0** if the command was successfully executed; **non-zero** otherwise.

#### **Examples**

`__hhs funcs`

**Output**

N/A

------

### "logs"

```bash
Usage: __hhs logs [log_level]
```

#### **Purpose**

Retrieve HomeSetup logs. By default, this command is going to return 100 log lines. If the file contains more than that
you can set the environment variable \"$HHS_LOG_LINES\" to a greater value and issue the command again.

#### **Returns**

**0** if the command was successfully executed; **non-zero** otherwise.

#### **Examples**

`__hhs logs`

**Output**

```bash
Retrieving logs from /Users/runner/.hhs/log/hhsrc.log (last 100 lines) [level='ALL'] :

HomeSetup is starting: Mon Dec 18 17:23:17 -03 2023

12-18-23 17:23:17   INFO  Initialization settings loaded: /Users/runner/.hhs/.homesetup.toml
12-18-23 17:23:17   INFO  Loading dotfile: /Users/hjunior/.bash_env
12-18-23 17:23:17   INFO  Loading dotfile: /Users/hjunior/.bash_colors
12-18-23 17:23:17   INFO  Loading dotfile: /Users/hjunior/.bash_prompt
12-18-23 17:23:17   INFO  Starting starship prompt
...
...
```

------

### "man"

```bash
Usage: __hhs man <bash_command>
```

#### **Purpose**

Fetch the **ss64** manual from the website for the specified bash command.

#### **Returns**

**0** if the command was successfully executed; **non-zero** otherwise.

#### **Examples**

`__hhs man grep`

**Output**

```bash
Opening SS64 man page for grep: https://ss64.com/bash/grep.html
```

------

### "reset"

```bash
Usage: __hhs reset
```

#### **Purpose**

Clear all cache, log and backup files and HomeSetup config files. Force re-create all using defaults.

#### **Returns**

**0** if the command was successfully executed; **non-zero** otherwise.

#### **Examples**

`__hhs reset`

**Output**

```bash
Attention! Mark what you want to delete  (8)

  1      /Users/hjunior/.hhs/log/*.log
  2       /Users/hjunior/.hhs/backup/*.bak
  3       /Users/hjunior/.hhs/cache/*.cache
  4       /Users/hjunior/.inputrc
  5       /Users/hjunior/.hhs/.aliasdef
  6       /Users/hjunior/.hhs/.starship.toml
  7       /Users/hjunior/.hhs/.homesetup.toml
  8       /Users/hjunior/.hhs/shell-opts.toml

[Enter] Accept  [↑↓] Navigate  [Space] Mark  [I] Invert  [Esc] Quit  [1..8] Goto:
```
