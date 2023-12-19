<img src="https://iili.io/HvtxC1S.png" width="64" height="64" align="right" />

# HomeSetup Developer Handbook
>
> Standard-Tools

## Table of contents

<!-- toc -->

- [Standard Tools](../../functions.md#standard-tools)
  - [Aliases Related](aliases-related.md#aliases-related-functions)
  - [Built-ins](built-ins.md#built-ins-functions)
  - [CLI Terminal Tools](clitt.md#clitt)
  - [Command Tool](command-tool.md#command-tool)
  - [Directory Related](directory-related.md#directory-related-functions)
  - [File Related](file-related.md#file-related-functions)
  - [Network Related](network-related.md#network-related-functions)
  - [Paths Tool](paths-tool.md#paths-tool)
  - [Profile Related](profile-related.md#profile-related-functions)
  - [Search Related](search-related.md#search-related-functions)
  - [Security Related](security-related.md#security-related-functions)
  - [Shell Utilities](shell-utilities.md#shell-utilities)
  - [System Utilities](system-utilities.md#system-utilities)
  - [Taylor Tool](taylor-tool.md#taylor-tool)
  - [Text Utilities](text-utilities.md#text-utilities)
  - [TOML Utilities](toml-utilities.md#toml)
  - [Toolchecks](toolchecks.md#tool-checks-functions)
- [Development Tools](../../functions.md#development-tools)
  - [Gradle](../dev-tools/gradle-tools.md#gradle-functions)
  - [Docker](../dev-tools/docker-tools.md#docker-functions)
  - [Git](../dev-tools/git-tools.md#git-functions)

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
Usage: __hhs_aliases <alias> <alias_expr>

    Options:
      -e | --edit    : Open the aliases file for editing.
      -r | --remove  : Remove an alias.

  Notes:
    List all aliases    : When [alias_expr] is NOT provided. If [alias] is provided, filter results using it.
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
