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
  $ __hhs_tools 'git' 'svn' 'java' 'python'
```

------
### __hhs_about_command

```bash
Usage: __hhs_about_command <command>
```

##### **Purpose**:

Display information about the given command.

##### **Returns**:

**0** on success; **non-zero** otherwise.

##### **Parameters**: 

  - $1 _Required_ : The command to check.

##### **Examples:**

```bash
  $ __hhs_about_command ls
```
