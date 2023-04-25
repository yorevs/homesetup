# HomeSetup Applications Handbook

## Table of contents

<!-- toc -->
- [Bash Applications](../../applications.md)
  * [App-Commons](app-commons.md)
  * [Check-IP](check-ip.md)
  * [Fetch](fetch.md)
  * [HHS-App](hhs-app.md)
    + [Functions](#functions)
    + [Plugins](#plug-ins)
<!-- tocstop -->

## HHS-App application

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
Usage: hhs help [_hhs_<function_name>]
```

TODO

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

## Plug-ins

------
### Firebase


------
### HSPM


------
### Updater
