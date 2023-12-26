<img src="https://iili.io/HvtxC1S.png" width="64" height="64" align="right" />

# HomeSetup Developer Handbook
>
> Standard-Tools

## Table of contents

<!-- toc -->

- [Standard Tools](../../functions.md#standard-tools)
  - [Aliases Related](aliases-related.md#aliases-related-functions)
  - [Built-ins](built-ins.md#built-ins-functions)
  - [CLI Terminal Tools](clitt.md#cli-terminal-tools)
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
  - [TOML Utilities](toml-utilities.md#toml-utilities)
  - [Toolchecks](toolchecks.md#tool-checks-functions)
- [Development Tools](../../functions.md#development-tools)
  - [Gradle](../dev-tools/gradle-tools.md#gradle-functions)
  - [Docker](../dev-tools/docker-tools.md#docker-functions)
  - [Git](../dev-tools/git-tools.md#git-functions)

<!-- tocstop -->


### Shell utilities

### __hhs_history

```bash
Usage: __hhs_history [regex_filter]
```

##### **Purpose**:

Search for previously issued commands from history using filters.

##### **Returns**:

**0** on success; **non-zero** otherwise.

##### **Parameters**:

  - $1 _Optional_ : The case-insensitive filter to be used when listing.

##### **Examples:**

```bash
  $ hist ls && echo "List previously type `ls' commands"
```

### __hhs_hist_stats

```bash
Usage: __hhs_hist_stats [top_N]
```

##### **Purpose**:

Display statistics about commands in history.

##### **Returns**:

**0** on success; **non-zero** otherwise.

##### **Parameters**:

  - $1 _Optional_ : Limit to the top N commands.

##### **Examples:**

```bash
  $ __hhs_hist_stats 10 && echo "Top 10 used commands"
```

------
### __hhs_envs

```bash
Usage: __hhs_envs [regex_filter]
```

##### **Purpose**:

Display all environment variables using filters.

##### **Returns**:

**0** on success; **non-zero** otherwise.

##### **Parameters**:

  - $1 _Optional_ : The case-insensitive filter to be used when listing.

##### **Examples:**

```bash
  $ envs hhs && echo "That's all HHS variables"
```

------
### __hhs_envs

```bash
Usage: __hhs_defs [regex_filter]
```

##### **Purpose**:

Display all alias definitions using filters.

##### **Returns**:

**0** on success; **non-zero** otherwise.

##### **Parameters**:

  - $1 _Optional_ : If -e is present, edit the .aliasdef file, otherwise a case-insensitive filter to be used when listing.

##### **Examples:**

```bash
  $ defs gw && echo "That's all gradle wrapper alias definitions"
```

------
### __hhs_shell_select

```bash
Usage: __hhs_shell_select
```

##### **Purpose**:

Select a shell from the existing shell list.

##### **Returns**:

**0** on success; **non-zero** otherwise.

##### **Parameters**: -

##### **Examples:**

```bash
  $ __hhs_shell_select
```
