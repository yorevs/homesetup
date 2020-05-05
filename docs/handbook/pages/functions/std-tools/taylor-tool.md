# HomeSetup Taylor Tool Handbook

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


### Taylor tool

------
### __hhs_tailor

```bash
Usage: __hhs_tailor [filename]

  Notes:
    filename: If not provided, stdin will be used instead
```

##### **Purpose**:

Tail a log using colors and patterns specified on `.tailor' file

##### **Returns**:

**0** on success; **non-zero** otherwise.

##### **Parameters**: 

  $1 _Required_ : The log file name.

##### **Examples:**

```bash
  $ __hhs_tailor /var/log/syslog.log
  $ cat /var/log/syslog.log | __hhs_tailor
```
