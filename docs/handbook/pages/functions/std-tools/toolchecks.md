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

### Tool checks functions

#### __hhs_version

```bash
Usage: __hhs_version <app_name>
```

##### **Purpose**

Check the version of the app using the most common ways.

##### **Returns**

**0** on success; **non-zero** otherwise.

##### **Parameters**

  - $1 _Required_ : The app to check.

##### **Examples**

`__hhs_version python3`

**Output**

```bash
Python 3.11.6
```

------

#### __hhs_toolcheck

```bash
Usage: __hhs_toolcheck [options] <app_name>

    Options:
      -q  : Quiet mode on
```

##### **Purpose**

Check whether a tool is installed on the system.

##### **Returns**

**0** if the tool is installed; **non-zero** otherwise.

##### **Parameters**

  - $1 _Required_ : The app to check.

##### **Examples**

`__hhs_toolcheck python3`

**Output**

```bash
[Darwin] Checking: python3 .............  INSTALLED => /usr/local/bin/python3
```

------

#### __hhs_tools

```bash
Usage: __hhs_tools [tool_list]

  Notes:
    - If tool_list is not provided, the value variable HHS_DEV_TOOLS will be used.
```

##### **Purpose**

Check whether development tools are installed or not.

##### **Returns**

**0** on success; **non-zero** otherwise.

##### **Parameters**

  - $1..$N _Optional_ : The tool list to be checked.

##### **Examples**

`__hhs_tools 'git' 'svn' 'java' 'python3'`

```bash
Checking (4) development tools:

[Darwin] Checking: git .................  INSTALLED => /usr/local/bin/git
[Darwin] Checking: svn .................  NOT FOUND
[Darwin] Checking: java ................  INSTALLED => /usr/bin/java
[Darwin] Checking: python3 .............  INSTALLED => /usr/local/bin/python3

 To check the current installed version, type: #> ver <tool_name>
 To install/uninstall a tool, type: #> hspm install/uninstall <tool_name>
 To override the list of tools, type: #> export HHS_DEV_TOOLS=( "tool1" "tool2" ... )
```
