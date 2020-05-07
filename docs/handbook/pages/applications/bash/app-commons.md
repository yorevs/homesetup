# HomeSetup Applications Handbook

## Table of contents

<!-- toc -->
- [Bash Apps](../../applications.md#bash-apps)
  * [App-Commons](app-commons.md)
  * [Check-IP](check-ip.md)
  * [Fetch](fetch.md)
  * [HHS-App](hhs-app.md)
- [Python Apps](../../applications.md#python-apps)
  * [Free](../py/free.md)
  * [Json-Find](../py/json-find.md)
  * [PPrint-xml](../py/pprint-xml.md)
  * [Print-Uni](../py/print-uni.md)
  * [Send-Msg](../py/send-msg.md)
  * [TCalc](../py/tcalc.md)
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

