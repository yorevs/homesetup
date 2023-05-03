# HomeSetup Standard-Tools Functions Handbook

## Table of contents

<!-- toc -->
- [Standard Tools](../../functions.md#standard-tools)
  * [General](general.md#general-functions)
  * [Aliases Related](aliases-related.md#aliases-related-functions)
  * [Built-ins](built-ins.md#built-ins-functions)
  * [Command Tool](command-tool.md#command-tool)
  * [Directory Related](directory-related.md#directory-related-functions)
  * [File Related](file-related.md#file-related-functions)
  * [MChoose Tool](mchoose-tool.md#mchoose-tool)
  * [MInput Tool](minput-tool.md#minput-tool)
  * [MSelect Tool](mselect-tool.md#mselect-tool)
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


### Tool checks functions

------
### __hhs_toolcheck

```bash
Usage: __hhs_toolcheck [options] <app_name>

    Options:
      -q  : Quiet mode on
```

##### **Purpose**:

Check whether a tool is installed on the system.

##### **Returns**:

**0** if the tool is installed; **non-zero** otherwise.

##### **Parameters**: 

  - $1 _Required_ : The app to check.

##### **Examples:**

```bash
  $ __hhs_toolcheck java && echo "java is installed"
  $ __hhs_toolcheck -q nottatool || echo "nottatool is not installed"
```

------
### __hhs_version

```bash
Usage: __hhs_version <app_name>
```

##### **Purpose**:

Check the version of the app using the most common ways.

##### **Returns**:

**0** on success; **non-zero** otherwise.

##### **Parameters**: 

  - $1 _Required_ : The app to check.

##### **Examples:**

```bash
  $ __hhs_version java
  $ __hhs_version git
```

------
### __hhs_tools

```bash
Usage: __hhs_tools [tool_list]
```

##### **Purpose**:

Check whether a list of development tools are installed or not.

##### **Returns**:

**0** on success; **non-zero** otherwise.

##### **Parameters**: 

  - $1..$N _Optional_ : The tool list to be checked.

##### **Examples:**

```bash
  $ __hhs_tools 'git' 'svn' 'java' 'python3'
```

------
### __hhs_about

```bash
Usage: __hhs_about <command>
```

##### **Purpose**:

Display information about the given command.

##### **Returns**:

**0** on success; **non-zero** otherwise.

##### **Parameters**: 

  - $1 _Required_ : The command to check.

##### **Examples:**

```bash
  $ __hhs_about ls
```
