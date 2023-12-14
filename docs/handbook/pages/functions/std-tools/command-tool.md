<img src="https://iili.io/HvtxC1S.png" width="64" height="64" align="right" />

# HomeSetup Developer Handbook
>
> Standard-Tools

## Table of contents

<!-- toc -->
- [Standard Tools](../../functions.md#standard-tools)
  * [General](general.md#general-functions)
  * [Aliases Related](aliases-related.md#aliases-related-functions)
  * [Built-ins](built-ins.md#built-ins-functions)
  * [Command Tool](command-tool.md#command-tool)
  * [Directory Related](directory-related.md#directory-related-functions)
  * [File Related](file-related.md#file-related-functions)
  * [MChoose Tool](clitt.md#mchoose-tool)
  * [MInput Tool](clitt.md#minput-tool)
  * [MSelect Tool](clitt.md#mselect-tool)
  * [Network Related](network-related.md#network-related-functions)
  * [Paths Tool](paths-tool.md#paths-tool)
  * [Profile Related](profile-related.md#profile-related-functions)
  * [Punch-Tool](punch-tool.md#punch-tool)
  * [Search Related](search-related.md#search-related-functions)
  * [Security Related](security-related.md#security-related-functions)
  * [Shell Utilities](shell-utilities.md#shell-utilities)
  * [System Utilities](system-utilities.md#system-utilities)
  * [Taylor Tool](taylor-tool.md#taylor-tool)
  * [Text Utilities](text-utilities.md#text-utilities)
  * [Toolchecks](toolchecks.md#tool-checks-functions)
- [Development Tools](../../functions.md#development-tools)
  * [Gradle](../dev-tools/gradle-tools.md#gradle-functions)
  * [Docker](../dev-tools/docker-tools.md#docker-functions)
  * [Git](../dev-tools/git-tools.md#git-functions)
<!-- tocstop -->


### Command tool

#### __hhs_command

```bash
Usage: __hhs_command [options [cmd_alias] <cmd_expression>] | [cmd_index]

    Options:
      [cmd_index]   : Execute the command specified by the command index.
      -e | --edit   : Edit the commands file.
      -a | --add    : Store a command.
      -r | --remove : Remove a command.
      -l | --list   : List all stored commands.

  Notes:
    MSelect default : When no arguments is provided, a menu with options will be displayed.
```

##### **Purpose**:

Add/Remove/List/Execute saved bash commands.

##### **Returns**:

**0** if the command executed successfully; **non-zero** otherwise.

##### **Parameters**:

  - $1 _Optional_ : The command index or alias.
  - $2..$N _Conditional_ : The command expression. This is required when alias is provided.

##### **Examples:**

```bash
  $ __hhs_command -a test ls -la && echo "Created a test command"
  $ __hhs_command test && echo "Executed ls -la"
  $ __hhs_command -r test && echo "Removed a test command"
```
