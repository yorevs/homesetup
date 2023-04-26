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


### General functions

#### __hhs_has

```bash
Usage: __hhs_has <command>
```

##### **Purpose**:

Check if a command is available on the current shell session.

##### **Returns**:

'0' : If the command is available; '1' otherwise

##### **Parameters**:

  - $1 _Required_ : The command to check.

##### **Examples:**

```bash
  $ __hhs_has ls && echo "ls is installed"
  $ __hhs_has noexist || echo "ls is not installed"
```

#### __hhs_log

```bash
Usage: __hhs_log <log_level> <log_message>
```

##### **Purpose**:

Log a message to the HomeSetup log file.

##### **Returns**:

'0' : If the command is was successful; '1' otherwise

##### **Parameters**:

  - $1 _Required_ : The log level. One of ["DEBUG", "INFO", "WARN", "ERROR", "ALL"].
  - $2 _Required_ : The log message.

##### **Examples:**

```bash
  $ __hhs_log "WARN" "Just a warning to you" && echo "WARN log message logged"
  $ __hhs_log "INFO" "Just a warning to you" && echo "INFO log message logged"
```

#### __hhs_source

```bash
Usage: __hhs_source <filepath>
```

##### **Purpose**:

Replacement for the original source bash command.

##### **Returns**:

'0' : If the command is was successful; '1' otherwise

##### **Parameters**:

  - $1 _Required_ : Path to the file to be source'd.

##### **Examples:**

```bash
  $ __hhs_source ~/.profile
```

#### __hhs_is_reachable

```bash
Usage: __hhs_is_reachable <url>
```

##### **Purpose**:

Check whether an URL is reachable.

##### **Returns**:

'0' : If the url is reachable; '1' otherwise

##### **Parameters**:

  - $1 _Required_ : The URL to test reachability.

##### **Examples:**

```bash
  $ __hhs_is_reachable www.example.com && echo "URL www.example.com is reachable"
```
