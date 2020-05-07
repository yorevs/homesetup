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


### System utilities functions

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
