# <img src="https://iili.io/HvtxC1S.png"  width="34" height="34"> HomeSetup Developer-Tools Functions Handbook

## Table of contents

<!-- toc -->
- [Standard Tools](../../functions.md#standard-tools)
  * [General](../std-tools/general.md#general-functions)
  * [Aliases Related](../std-tools/aliases-related.md#aliases-related-functions)
  * [Built-ins](../std-tools/built-ins.md#built-ins-functions)
  * [Command Tool](../std-tools/command-tool.md#command-tool)
  * [Directory Related](../std-tools/directory-related.md#directory-related-functions)
  * [File Related](../std-tools/file-related.md#file-related-functions)
  * [MChoose Tool](../std-tools/clitt.md#mchoose-tool)
  * [MInput Tool](../std-tools/clitt.md#minput-tool)
  * [MSelect Tool](../std-tools/clitt.md#mselect-tool)
  * [Network Related](../std-tools/network-related.md#network-related-functions)
  * [Paths Tool](../std-tools/paths-tool.md#paths-tool)
  * [Profile Related](../std-tools/profile-related.md#profile-related-functions)
  * [Punch-Tool](../std-tools/punch-tool.md#punch-tool)
  * [Search Related](../std-tools/search-related.md#search-related-functions)
  * [Security Related](../std-tools/security-related.md#security-related-functions)
  * [Shell Utilities](../std-tools/shell-utilities.md#shell-utilities)
  * [System Utilities](../std-tools/system-utilities.md#system-utilities)
  * [Taylor Tool](../std-tools/taylor-tool.md#taylor-tool)
  * [Text Utilities](../std-tools/text-utilities.md#text-utilities)
  * [Toolchecks](../std-tools/toolchecks.md#tool-checks-functions)
- [Development Tools](../../functions.md#development-tools)
  * [Gradle](gradle-tools.md#gradle-functions)
  * [Docker](docker-tools.md#docker-functions)
  * [Git](git-tools.md#git-functions)
<!-- tocstop -->


### Docker functions

#### __hhs_docker_count

```bash
Usage: __hhs_docker_count 
```

##### **Purpose**:

Count the number of active docker containers.

##### **Returns**:

**0** if the command executed successfully; **non-zero** otherwise.

##### **Parameters**: -

##### **Examples:**

```bash
  $ __hhs_docker_count
```


-----
#### __hhs_docker_info

```bash
Usage: __hhs_docker_info <container_id>
```

##### **Purpose**:

Display information about the container.

##### **Returns**:

**0** if the command executed successfully; **non-zero** otherwise.

##### **Parameters**: 

  - $1 _Required_ : The running container ID.

##### **Examples:**

```bash
  $ __hhs_docker_info 6ae3b31765d2
```


-----
#### __hhs_docker_exec

```bash
Usage: __hhs_docker_exec <container_id> [shell_cmd]

  Notes: 
    - If shell_cmd is not provided /bin/bash will be used.
```

##### **Purpose**:

Run a command or bash in a running container.

##### **Returns**:

**0** if the command executed successfully; **non-zero** otherwise.

##### **Parameters**: 

  - $1 _Required_ : The running container ID.
  - $2 _Optional_ : The command to be executed on the container.

##### **Examples:**

```bash
  $ __hhs_docker_exec 6ae3b31765d2 redis-cli
```


-----
#### __hhs_docker_compose_exec

```bash
Usage: __hhs_docker_compose_exec <container_id> [shell_cmd]
```

##### **Purpose**:

This is the equivalent of docker exec, but for docker-compose.

##### **Returns**:

**0** if the command executed successfully; **non-zero** otherwise.

##### **Parameters**: 

  - $1 _Required_ : The running container ID.
  - $2 _Optional_ : The command to be executed on the container.

##### **Examples:**

```bash
  $ __hhs_docker_compose_exec 6ae3b31765d2 redis-cli
```


-----
#### __hhs_docker_logs

```bash
Usage: __hhs_docker_logs <container_id>
```

##### **Purpose**:

Fetch the logs of a container.

##### **Returns**:

**0** if the command executed successfully; **non-zero** otherwise.

##### **Parameters**: 

  - $1 _Required_ : The running container ID.

##### **Examples:**

```bash
  $ __hhs_docker_logs 6ae3b31765d2
```


-----
#### __hhs_docker_remove_volumes

```bash
Usage: __hhs_docker_remove_volumes
```

##### **Purpose**:

Remove all docker volumes not referenced by any containers (dangling).

##### **Returns**:

**0** if the command executed successfully; **non-zero** otherwise.

##### **Parameters**: -

##### **Examples:**

```bash
  $ __hhs_docker_remove_volumes
```


-----
#### __hhs_docker_kill_all

```bash
Usage: __hhs_docker_kill_all [-a]

    Options: 
      -a : Remove active and inactive volumes; othewise it will only remove inactive
```

##### **Purpose**:

Stop, remove and remove dangling [active?] volumes of all docker containers.

##### **Returns**:

**0** if the command executed successfully; **non-zero** otherwise.

##### **Parameters**: 

  - $1 _Optional_ : Option to remove active containers as well.

##### **Examples:**

```bash
  $ __hhs_docker_kill_all -a
```
