# HomeSetup Functions Handbook

## Standard tools

### __hhs_has

```bash
Usage: __hhs_has <command>
```

**Purpose**: Check if a command is available on the current shell session.
**Returns**: '0' : If the command is available, '1' otherwise
**Parameters**:
  - $1 *Required* : The command to check.

_Examples:_
    `$ __hhs_has ls && echo "ls is installed"`
    `$ __hhs_has noexist || echo "ls is not installed"`

### __hhs_alias

```bash
Usage: __hhs_alias <alias_name>='<alias_expr>'
```

**Purpose**: Check if an alias does not exists and create it, otherwise just ignore it. Do not support the use of single quotes in the expression.
**Returns**: 0 if the alias name was created (available); non-zero otherwise.
**Parameters**: 
  - $1 *Required* : The alias to set/check.
  - $* *Required* : The alias expression.

_Examples:_
    `$ __hhs_alias ls='ls -la' || echo "Alias was not created !"`
    `$ __hhs_alias noexist='ls -la' || echo "Alias was created !"`


### __hhs_aliases

```bash
Usage: __hhs_aliases [-s|--sort] [alias <alias_expr>]

    Options: 
      -e | --edit    : Open the aliases file for editting.
      -s | --sort    : Sort results ASC.
      -r | --remove  : Remove an alias.

  Notes: 
    List all aliases    : When [alias_expr] is NOT provided. If [alias] is provided, filter restuls using it.
    Add/Set an alias    : When both [alias] and [alias_expr] are provided.
```

**Purpose**: Manipulate custom aliases (add/remove/edit/list).
**Returns**: 0 if the alias was created (available); non-zero otherwise.
**Parameters**: 
  - $1 *Optional* : The alias name.
  - $2 *Conditional* : The alias expression.

_Examples:_
    `$ __hhs_aliases my-alias 'ls -la' && echo "Alias created"`
    `$ __hhs_aliases my-alias && echo "Alias removed"`
    `$ __hhs_aliases -s && echo "Listing all sorted aliases"`


### __hhs_random_number

```bash
Usage: __hhs_random_number <min-val> <max-val>
```

**Purpose**: Generate a random number int the range <min> <max> (all limits included).
**Returns**: 0 if the number was generated; non-zero otherwise.
**Parameters**: 
  - $1 *Required* : The minimum range of the number.
  - $2 *Required* : The maximum range of the number.

_Examples:_
    `$ __hhs_random_number 0 10 && echo "Random from 0 to 10"`


### __hhs_ascof
```bash
Usage: __hhs_ascof <character>
```

**Purpose**: Display the decimal ASCII representation of a character.
**Returns**: 0 if the representation was displayed; non-zero otherwise.
**Parameters**: 
  - $1 *Required* : The character to display.

_Examples:_
    `$ __hhs_ascof H && echo "Thats the ascii representation of H"`


### __hhs_utoh
```bash
Usage: __hhs_utoh <unicode...>

  Notes: unicode is a four digits hexadecimal
```

**Purpose**: Convert unicode to hexadecimal
**Returns**: 0 if the unicode was successfully converted; non-zero otherwise.
**Parameters**: 
  - $1..$N *Required* : The unicode values to convert

_Examples:_
    `$ __hhs_utoh f123 f321 && echo "Thats the hexadecimal representation of the unicode valus f123 and f321"`


### __hhs_command
```bash
Usage: __hhs_command [options [cmd_alias] <cmd_expression>] | [cmd_index]

    Options:
      [cmd_index]   : Execute the command specified by the command index.
      -e | --edit   : Edit the commands file.
      -a | --add    : Store a command.
      -r | --remove : Remove a command.
      -l | --list   : List all stored commands.

  Notes:
    MSelect default : When no arguments are provided, the menu will be displayed.
```

**Purpose**: Add/Remove/List/Execute saved bash commands.
**Returns**: 0 if the command executed successfully; non-zero otherwise.
**Parameters**: 
  - $1 *Optional* : The command index or alias.
  - $2..$N *Conditional* : The command expression. This is required when alias is provided.

_Examples:_
    `$ cmd -a test ls -la && echo "Created a test command"`
    `$ cmd test && echo "Executed ls -la"`
    `$ cmd -r test && echo "Removed a test command"`


### __hhs_change_dir
```bash
Usage: __hhs_change_dir [-L|-P] [dir]

    Options:
        [dir]   : The directory to change. If not provided, default DIR is the value of the HOME variable.
        -L      : Force symbolic links to be followed.
        -P      : Use the physical directory structure without following symbolic links.
```

**Purpose**: Change the current working directory to a specific Folder.
**Returns**: 0 if the directory is changed; non-zero otherwise.
**Parameters**: 
  - $1 *Optional* : [-L|-P] whether to follow (-L) or not (-P) symbolic links.
  - $2 *Optional* : The directory to change. If not provided, default DIR is the value of the HOME variable.

_Examples:_
    `$ cd /tmp && echo "Directory changed to /tmp"`


### __hhs_changeback_ndirs
```bash
Usage: __hhs_changeback_ndirs [ndirs]

    Options:
        [ndirs]   : The number of directories to change backwards.
```

**Purpose**: Change the current working directory to the previous folder by N times.
**Returns**: 0 if directory is changed; non-zero otherwise.
**Parameters**: 
  - $1 *Optional* : The number of directories to change backwards. If not provided, default is one.

_Examples:_
    `$ .. && echo "Changed to the previous directory `pwd`"`
    `$ .. 3 && echo "Changed backwards to 3rd previous directory `pwd`"`


### __hhs_dirs
```bash
Usage: __hhs_dirs
```

**Purpose**: Display the list of currently selectable remembered directories.
**Returns**: 0 if directory is changed; non-zero otherwise.
**Parameters**: 
  - $N *Optional* : If any parameter is used, the default dirs command is invoked instead.

_Examples:_
    `$ dirs`


### __hhs_list_tree
```bash
Usage: __hhs_list_tree [from_dir] [recurse_level]
```

**Purpose**: List contents of directories in a tree-like format.
**Returns**: 0 on success ; non-zero otherwise.
**Parameters**: 

_Examples:_
    `$ __hhs_list_tree . 5`
    `$ __hhs_list_tree /tmp 2`
    `$ __hhs_list_tree /Users`






### __hhs
```bash
Usage: 
```

**Purpose**: 
**Returns**: 0 if blablabla; non-zero otherwise.
**Parameters**: 

_Examples:_
    `$ `


## Development tools

