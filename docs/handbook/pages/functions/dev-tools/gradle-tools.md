<img src="https://iili.io/HvtxC1S.png" width="64" height="64" align="right" />

# HomeSetup Developer Handbook
>
> Developer-Tools

## Table of contents

<!-- toc -->

- [Standard Tools](../../functions.md#standard-tools)
  - [General](../std-tools/general.md#general-functions)
  - [Aliases Related](../std-tools/aliases-related.md#aliases-related-functions)
  - [Built-ins](../std-tools/built-ins.md#built-ins-functions)
  - [Command Tool](../std-tools/command-tool.md#command-tool)
  - [Directory Related](../std-tools/directory-related.md#directory-related-functions)
  - [File Related](../std-tools/file-related.md#file-related-functions)
  - [MChoose Tool](../std-tools/clitt.md#mchoose-tool)
  - [MInput Tool](../std-tools/clitt.md#minput-tool)
  - [MSelect Tool](../std-tools/clitt.md#mselect-tool)
  - [Network Related](../std-tools/network-related.md#network-related-functions)
  - [Paths Tool](../std-tools/paths-tool.md#paths-tool)
  - [Profile Related](../std-tools/profile-related.md#profile-related-functions)
  - [Punch-Tool](../std-tools/punch-tool.md#punch-tool)
  - [Search Related](../std-tools/search-related.md#search-related-functions)
  - [Security Related](../std-tools/security-related.md#security-related-functions)
  - [Shell Utilities](../std-tools/shell-utilities.md#shell-utilities)
  - [System Utilities](../std-tools/system-utilities.md#system-utilities)
  - [Taylor Tool](../std-tools/taylor-tool.md#taylor-tool)
  - [Text Utilities](../std-tools/text-utilities.md#text-utilities)
  - [Toolchecks](../std-tools/toolchecks.md#tool-checks-functions)
- [Development Tools](../../functions.md#development-tools)
  - [Gradle](gradle-tools.md#gradle-functions)
  - [Docker](docker-tools.md#docker-functions)
  - [Git](git-tools.md#git-functions)
-
<!-- tocstop -->

### Gradle functions

#### __hhs_gradle

```bash
usage: __hhs_gradle [gradle_args]
```

##### **Purpose**

Prefer using the wrapper instead of the installed command itself.

##### **Returns**

**0** if the command executed successfully; **non-zero** otherwise.

##### **Parameters**

- $1..$N _Optional_ : The gradle arguments to call.

##### **Examples:**

`__hhs_gradle clean`

```bash
./gradlew clean
Starting a Gradle Daemon (subsequent builds will be faster)
<-------------> 0% CONFIGURING [1s]
> root project
...
...
```
