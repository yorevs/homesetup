# <img src="https://iili.io/HvtxC1S.png"  width="34" height="34"> HomeSetup Applications Handbook

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

## Application commons

This is not an actual application, it's just a Bash library with bundled commonly used functions, variables and imports. 


### Imports

- **.bash_colors** : Enable colors to be used on 'printf' and 'echo'
- **.bash_aliases** : Allow aliased commands to be used.
- **.bash_functions** : Allow '_hhs_' functions to be used.


### Variables

- **VERSION** : Current application version. If not provided '0.9.0' will be assumed.
- **APP_NAME** : The application name.
- **USAGE** : Help message to be displayed by the application.
- **UNSETS** : Default identifiers to be unset.


### Functions

#### quit

##### **Purpose**:

Exit the application with the provided exit code and exhibits an exit message if provided.

##### **Returns**:

The provided exit code.

##### **Parameters**: 

  - $1 _Required_ : The exit return code. 0 = SUCCESS, 1 = FAILURE, * = ERROR
  - $2 _Optional_ : The exit message to be displayed.

##### **Examples:**

```bash
  quit 0 && echo "Exited with success !"
  quit 1 "Failed" || echo "Exited with error code 1 !"
```


------
#### usage

##### **Purpose**:

Display the usage message and exit with the provided code ( or zero as default ).

##### **Returns**:

The provided exit code.

##### **Parameters**: 

  - $1 _Required_ : The exit return code. 0 = SUCCESS, 1 = FAILURE, * = ERROR
  - $2 _Optional_ : The exit message to be displayed.

##### **Examples:**

```bash
  usage 0 && echo "Exited with success !"
  usage 1 "Failed" || echo "Exited with error code 1 !"
```


------
#### version

##### **Purpose**:

Display the current application version and exit.

##### **Returns**:

**0** always.

##### **Parameters**: -

##### **Examples:**

```bash
  version
```


------
#### trim

##### **Purpose**:

Trim whitespaces from the provided text.

##### **Returns**:

**0** always.

##### **Parameters**: 

  - $1..$N _Required_ : The text to be trimmed.

##### **Examples:**

```bash
  trim " this text has spaces  "
```


------
#### list_contains

##### **Purpose**:

Check whether the list contains the specified string.

##### **Returns**:

**0** if the  provided list contains the specified string; **non-zero** otherwise.

##### **Parameters**: 

  - $1 _Required_ : The list to check against.
  - $2 _Required_ : The string to be checked.

##### **Examples:**

```bash
  list_contains "one two three four" "one" && echo 'List contains one'
  list_contains "one two three four" "five" || echo 'List does not contain five'
```
