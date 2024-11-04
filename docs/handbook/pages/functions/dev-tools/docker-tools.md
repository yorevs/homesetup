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

### Docker functions

#### __hhs_docker_count

```bash
usage: __hhs_docker_count
```

##### **Purpose**

Count the number of active docker containers.

##### **Returns**

**0** if the command executed successfully; **non-zero** otherwise.

##### **Parameters**

N/A

##### **Examples**

`__hhs_docker_count`

**Output**

```bash
1
```

-----

#### __hhs_docker_info

```bash
usage: __hhs_docker_info <container_id>
```

##### **Purpose**

Display information about the container.

##### **Returns**

**0** if the command executed successfully; **non-zero** otherwise.

##### **Parameters**

- $1 _Required_ : The active container ID.

##### **Examples**

`__hhs_docker_info 5d903d749ba1`

**Output**

```bash
5d903d749ba1   postgres:latest   "docker-entrypoint.s…"   6 days ago   Up 6 days (healthy)   0.0.0.0:5432->5432/tcp, :::5432->5432/tcp   postgres
```

-----

#### __hhs_docker_exec

```bash
usage: __hhs_docker_exec <container_id> [shell_cmd]

  Notes:
    - If shell_cmd is not provided '/bin/sh' will be used.
```

##### **Purpose**

Run a command or bash in a running container.

##### **Returns**

**0** if the command executed successfully; **non-zero** otherwise.

##### **Parameters**

- $1 _Required_ : The active container ID.
- $2 _Optional_ : The command to be executed on the container.

##### **Examples**

`__hhs_docker_exec 6ae3b31765d2 redis-cli`

**Output**

```bash
127.0.0.1:6379>
```

-----

#### __hhs_docker_compose_exec

```bash
usage: __hhs_docker_compose_exec <container_id> [shell_cmd]
```

##### **Purpose**

This is the equivalent of docker exec, but for docker-compose.

##### **Returns**

**0** if the command executed successfully; **non-zero** otherwise.

##### **Parameters**

N/A

- $1 _Required_ : The active container ID.
- $2 _Optional_ : The command to be executed on the container.

##### **Examples**

`__hhs_docker_compose_exec 6ae3b31765d2`

**Output**

```bash
#
```

-----

#### __hhs_docker_logs

```bash
usage: __hhs_docker_logs <container_id>
```

##### **Purpose**

Fetch the logs of a container.

##### **Returns**

**0** if the command executed successfully; **non-zero** otherwise.

##### **Parameters**

N/A

- $1 _Required_ : The active container ID.

##### **Examples**

`__hhs_docker_logs 6ae3b31765d2`

**Output**

```bash
The files belonging to this database system will be owned by user "postgres".
This user must also own the server process.

The database cluster will be initialized with locale "en_US.utf8".
The default database encoding has accordingly been set to "UTF8".
The default text search configuration will be set to "english".

Data page checksums are disabled.

fixing permissions on existing directory /var/lib/postgresql/data ... ok
...
...
```

-----

#### __hhs_docker_remove_volumes

```bash
usage: __hhs_docker_remove_volumes
```

##### **Purpose**

Remove all docker volumes not referenced by any containers (dangling).

##### **Returns**

**0** if the command executed successfully; **non-zero** otherwise.

##### **Parameters**

N/A

##### **Examples**

`__hhs_docker_remove_volumes`

**Output**

```bash
Removing dangling docker volume: e902d7f1c34c1cd1a7f65e0100f93f345d3bd40bec2eb304b2a5fa5ee712fb9b... OK
Removing dangling docker volume: postgres_postgres-data... OK
```

-----

#### __hhs_docker_kill_all

```bash
usage: __hhs_docker_kill_all [-a]

    Options:
      -a : Remove active and inactive volumes; othewise it will only remove inactive ones.
```

##### **Purpose**

Stop, remove and remove dangling [active?] volumes of all docker containers.

##### **Returns**

**0** if the command executed successfully; **non-zero** otherwise.

##### **Parameters**

- $1 _Optional_ : If specified, also remove active containers.

##### **Examples**

`__hhs_docker_kill_all -a`

**Output**

```bash
Stopping Docker container: 13f21a0fe4f3... OK
Removing Docker container: 13f21a0fe4f3... OK
Removing dangling docker volume: 9ffc71829b4e2d8e2221e8285aef0112472fa40df1fb57fdcf810fd415ed5f99... OK
Removing dangling docker volume: postgres_postgres-data... OK
```
