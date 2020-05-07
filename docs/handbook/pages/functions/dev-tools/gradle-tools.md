# HomeSetup Developer-Tools Functions Handbook

## Table of contents

<!-- toc -->
- [Standard Tools](../../functions.md#standard-tools)
  * [General](../std-tools/general.md)
  * [Aliases Related](../std-tools/aliases-related.md)
  * [Built-ins](../std-tools/built-ins.md)
  * [Command Tool](../std-tools/command-tool.md)
  * [Directory Related](../std-tools/directory-related.md)
  * [File Related](../std-tools/file-related.md)
  * [MChoose Tool](../std-tools/mchoose-tool.md)
  * [MInput Tool](../std-tools/minput-tool.md)
  * [MSelect Tool](../std-tools/mselect-tool.md)
  * [Network Related](../std-tools/network-related.md)
  * [Paths Tool](../std-tools/paths-tool.md)
  * [Profile Related](../std-tools/profile-related.md)
  * [Punch-Tool](../std-tools/punch-tool.md)
  * [Search Related](../std-tools/search-related.md)
  * [Security Related](../std-tools/security-related.md)
  * [Shell Utilities](../std-tools/shell-utilities.md)
  * [System Utilities](../std-tools/system-utilities.md)
  * [Taylor Tool](../std-tools/taylor-tool.md)
  * [Text Utilities](../std-tools/text-utilities.md)
  * [Toolchecks](../std-tools/toolchecks.md)
- [Development Tools](../../functions.md#development-tools)
  * [Gradle](gradle-tools.md)
  * [Docker](docker-tools.md)
  * [Git](git-tools.md)
<!-- tocstop -->


### Gradle functions

#### __hhs_gradle

```bash
Usage: __hhs_gradle <gradle_task>
```

##### **Purpose**:

Prefer using the wrapper instead of the installed command itself.

##### **Returns**:

**0** if the command executed successfully; **non-zero** otherwise.

##### **Parameters**: 

  - $1..$N _Required_ : The gradle tasks to call.

##### **Examples:**

```bash
  $ __hhs_gradle clean build
```
