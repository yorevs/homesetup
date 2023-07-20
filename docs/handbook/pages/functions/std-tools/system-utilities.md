# <img src="https://iili.io/HvtxC1S.png"  width="34" height="34"> HomeSetup Standard-Tools Functions Handbook

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


### System utilities

### __hhs_sysinfo

```bash
Usage: __hhs_sysinfo
```

##### **Purpose**:

Display relevant system information.

##### **Returns**:

**0** on success; **non-zero** otherwise.

##### **Parameters**: -

##### **Examples:**

```bash
  $ __hhs_sysinfo
```

------
### __hhs_process_list

```bash
Usage: __hhs_process_list [options] <process_name> [kill]

    Options:
        -i : Make case insensitive search
        -w : Match full words only
        -f : Do not ask questions when killing processes
        -q : Be less verbose as possible

  Notes:
    kill : If specified, it will kill the process it finds
```

##### **Purpose**:

Display a process list matching the process name/expression.

##### **Returns**:

**0** on success; **non-zero** otherwise.

##### **Parameters**: 

  - $1 __Required__ : The process name to check.
  - $2 __Optional__ : Whether to kill all found processes.

##### **Examples:**

```bash
  $ __hhs_process_list java && echo "Listed all Java processes"
  $ __hhs_process_list -i JAVA kill && echo "Listed all Java processes and killing them"
```

------
### __hhs_process_kill

```bash
Usage: __hhs_process_kill [options] <process_name>

    Options:
        -f | --force : Do not prompt for confirmation when killing a process
```

##### **Purpose**:

Kills ALL processes specified by name.

##### **Returns**:

**0** on success; **non-zero** otherwise.

##### **Parameters**: 

  - $1 __Required__ : The process name to kill.

##### **Examples:**

```bash
  $ __hhs_process_kill java
```

------
### __hhs_partitions

```bash
Usage: __hhs_partitions
```

##### **Purpose**:

Exhibit a Human readable summary about all partitions.

##### **Returns**:

**0** on success; **non-zero** otherwise.

##### **Parameters**: -

##### **Examples:**

```bash
  $ __hhs_partitions
```
