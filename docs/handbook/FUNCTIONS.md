# HomeSetup Functions Handbook

## Standard tools

### __hhs_has

**Purpose:** check if a command is available on the current shell session.
**Returns:** '0' -> If the command is available, '1' otherwise
**Parametes:**
    - $1 *Required* -> The command to check.

Examples:
    `$ __hhs_has ls && echo "ls is installed"`
    `$ __hhs_has noexist || echo "ls is not installed"`

### __hhs_alias

**Purpose:** check if an alias does not exists and create it, otherwise just ignore it. Do not support the use of single quotes in the expression.
**Returns**: 0 -> If the alias name was created (available), 1 otherwise.
**Parametes**: 
    - $1 *Required* -> The alias to set/check. Use the format: `__hhs_alias <alias_name>='<alias_expr>'`

Examples:
    `$ __hhs_alias ls='ls -la' || echo "Alias was not created !"`
    `$ __hhs_alias noexist='ls -la' || echo "Alias was created !"`






## Development tools

