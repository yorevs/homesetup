# HomeSetup Functions Handbook

## Standard tools

### __hhs_has

```bash
Usage: __hhs_has <command>
```

**Purpose**: Check if a command is available on the current shell session.
**Returns**: '0' -> If the command is available, '1' otherwise
**Parametes**:
  - $1 *Required* -> The command to check.

Examples:
    `$ __hhs_has ls && echo "ls is installed"`
    `$ __hhs_has noexist || echo "ls is not installed"`

### __hhs_alias

```bash
Usage: __hhs_alias <alias_name>='<alias_expr>'
```

**Purpose**: Check if an alias does not exists and create it, otherwise just ignore it. Do not support the use of single quotes in the expression.
**Returns**: 0 -> If the alias name was created (available), 1 otherwise.
**Parametes**: 
  - $1 *Required* -> The alias to set/check.
  - $* *Required* -> The alias expression.

Examples:
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
**Returns**: 0 -> If the alias was created (available), 1 otherwise.
**Parametes**: 
  - $1 *Optional* -> The alias name.
  - $2 *Conditional* -> The alias expression.

Examples:
    `$ __hhs_aliases my-alias 'ls -la' && echo "Alias created"`
    `$ __hhs_aliases my-alias && echo "Alias removed"`
    `$ __hhs_aliases -s && echo "Listing all sorted aliases"`


### __hhs_random_number

```bash
Usage: __hhs_random_number <min-val> <max-val>
```

**Purpose**: Generate a random number int the range <min> <max> (all limits included).
**Returns**: 0 -> If the number was generated, 1 otherwise.
**Parametes**: 
  - $1 *Required* -> The minimum range of the number.
  - $2 *Required* -> The maximum range of the number.

Examples:
    `$ __hhs_random_number 0 10 && echo "Random from 0 to 10"`


### __hhs_ascof
```bash
Usage: __hhs_ascof <character>
```

**Purpose**: Display the decimal ASCII representation of a character.
**Returns**: 0 -> If the representation was displayed, 1 otherwise.
**Parametes**: 
  - $1 *Required* -> The character to display.

Examples:
    `$ __hhs_ascof H && echo "Thats the ascii representation of H"`


## Development tools

