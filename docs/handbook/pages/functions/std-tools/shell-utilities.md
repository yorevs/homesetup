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


### Shell utilities functions

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
