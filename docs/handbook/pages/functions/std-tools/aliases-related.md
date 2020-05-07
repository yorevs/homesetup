# HomeSetup Standard-Tools Functions Handbook

## Table of contents

<!-- toc -->
- [Standard Tools](../../functions.md#standard-tools)
  * [General](general.md)
  * [Aliases Related](aliases-related.md)
  * [Built-ins](built-ins.md)
  * [Command Tool](command-tool.md)
  * [Directory Related](directory-related.md)
  * [File Related](file-related.md)
  * [MChoose Tool](mchoose-tool.md)
  * [MInput Tool](minput-tool.md)
  * [MSelect Tool](mselect-tool.md)
  * [Network Related](network-related.md)
  * [Paths Tool](paths-tool.md)
  * [Profile Related](profile-related.md)
  * [Punch-Tool](punch-tool.md)
  * [Search Related](search-related.md)
  * [Security Related](security-related.md)
  * [Shell Utilities](shell-utilities.md)
  * [System Utilities](system-utilities.md)
  * [Taylor Tool](taylor-tool.md)
  * [Text Utilities](text-utilities.md)
  * [Toolchecks](toolchecks.md)
- [Development Tools](../../functions.md#development-tools)
  * [Gradle](../dev-tools/gradle-tools.md)
  * [Docker](../dev-tools/docker-tools.md)
  * [Git](../dev-tools/git-tools.md)
<!-- tocstop -->


### Aliases related functions

#### __hhs_alias

```bash
Usage: __hhs_alias <alias_name>='<alias_expr>'
```

##### **Purpose**:

Check if an alias does not exists and create it, otherwise just ignore it. Do not support the use of single quotes in the expression.

##### **Returns**:

**0** if the alias name was created (available); **non-zero** otherwise.

##### **Parameters**: 

  - $1 _Required_ : The alias to set/check.
  - $* _Required_ : The alias expression.

##### **Examples:**

```bash
  $ __hhs_alias ls='ls -la' || echo "Alias was not created !"
  $ __hhs_alias noexist='ls -la' || echo "Alias was created !"
```


------
#### __hhs_aliases

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

##### **Purpose**:

Manipulate custom aliases (add/remove/edit/list).

##### **Returns**:

**0** if the alias was created (available); **non-zero** otherwise.

##### **Parameters**: 

  - $1 _Optional_ : The alias name.
  - $2 _Conditional_ : The alias expression.

##### **Examples:**

```bash
  $ __hhs_aliases my-alias 'ls -la' && echo "Alias created"
  $ __hhs_aliases my-alias && echo "Alias removed"
  $ __hhs_aliases -s && echo "Listing all sorted aliases"
```
