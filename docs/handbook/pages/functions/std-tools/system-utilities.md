<img src="https://iili.io/HvtxC1S.png" width="64" height="64" align="right" />

# HomeSetup Developer Handbook
>
> Standard-Tools

## Table of contents

<!-- toc -->

- [Standard Tools](../../functions.md#standard-tools)
  - [Aliases Related](aliases-related.md#aliases-related-functions)
  - [Built-ins](built-ins.md#built-ins-functions)
  - [CLI Terminal Tools](clitt.md#cli-terminal-tools)
  - [Command Tool](command-tool.md#command-tool)
  - [Directory Related](directory-related.md#directory-related-functions)
  - [File Related](file-related.md#file-related-functions)
  - [Network Related](network-related.md#network-related-functions)
  - [Paths Tool](paths-tool.md#paths-tool)
  - [Profile Related](profile-related.md#profile-related-functions)
  - [Search Related](search-related.md#search-related-functions)
  - [Security Related](security-related.md#security-related-functions)
  - [Shell Utilities](shell-utilities.md#shell-utilities)
  - [System Utilities](system-utilities.md#system-utilities)
  - [Taylor Tool](taylor-tool.md#taylor-tool)
  - [Text Utilities](text-utilities.md#text-utilities)
  - [TOML Utilities](toml-utilities.md#toml-utilities)
  - [Toolchecks](toolchecks.md#tool-checks-functions)
- [Development Tools](../../functions.md#development-tools)
  - [Gradle](../dev-tools/gradle-tools.md#gradle-functions)
  - [Docker](../dev-tools/docker-tools.md#docker-functions)
  - [Git](../dev-tools/git-tools.md#git-functions)

<!-- tocstop -->

### System utilities

#### __hhs_sysinfo

```bash
Usage: __hhs_sysinfo
```

##### **Purpose**

Display relevant system information.

##### **Returns**

**0** on success; **non-zero** otherwise.

##### **Parameters**

N/A

##### **Examples**

`__hhs_sysinfo`

**Output**

```bash
-=- System Information -=-

User:
  Username..... : hjunior
  Group........ : staff
  UID.......... : 504
  GID.......... : 20

System:
  OS........... : Darwin 23.1.0 x86_64 i386
  Software..... : macOS  14.1.1  23B81
  MEM Usage.... : ~47.5%
  CPU Usage.... : ~76.7%

Network:
  Hostname..... : localhost
  IP-External.. : 188.30.22.11
  IP-Gateway... : 192.168.100.1
  IP-en5....... : 192.168.100.139
  IP-lo0....... : 127.0.0.1

Storage:
  Disk            Size    Used    Free    Cap
  /dev/disk1s5s1  233Gi   9.2Gi   14Gi    41%
  devfs           189Ki   189Ki   0Bi     100%
  /dev/disk1s2    233Gi   1.9Gi   14Gi    13%
  /dev/disk1s4    233Gi   3.0Gi   14Gi    19%
  /dev/disk1s6    233Gi   11Mi    14Gi    1%
  /dev/disk1s1    233Gi   204Gi   14Gi    94%

Currently Logged in Users:
  NAME             LINE         TIME         FROM
  hjunior          console      Dec 22 15:01
  hjunior          ttys000      Dec 28 14:08
```

------

#### __hhs_process_list

```bash
Usage: __hhs_process_list [options] <process_name>

    Options:
        -k, --kill        : When specified, attempts to kill the processes it finds.
        -i, --ignore-case : Make case insensitive search.
        -w, --words       : Match full words only.
        -f, --force       : Do not prompt when killing processes.
        -q, --quiet       : Make the operation less talkative.
```

##### **Purpose**

Display a process list matching the process name/expression.

##### **Returns**

**0** on success; **non-zero** otherwise.

##### **Parameters**

  - $1 __Required__ : The process name to check.
  - $2 __Optional__ : Whether to kill all found processes.

##### **Examples**

`__hhs_process_list ssh`

**Output**

```bash
  UID	  PID	 PPID	COMMAND                                  ACTIVE ?
--------------------------------------------------------------------------------------------

  504	17458	    1	ssh-agent                                  active process
  504	67559	    1	ssh.sock [mux]                             active process
  504	67566	67457	ssh                                        active process
  504	67571	67457	ssh                                        active process
```

`__hhs_process_list -i -k PYTHON`

```bash
  UID	  PID	 PPID	COMMAND                                  ACTIVE ?
--------------------------------------------------------------------------------------------

  504	41210	40993	Python                                   Kill this process y/[n]?
```

------

#### __hhs_process_kill

```bash
Usage: __hhs_process_kill [options] <process_name>

    Options:
        -f | --force : Do not prompt for confirmation when killing a process
```

##### **Purpose**

Kills ALL processes specified by name.

##### **Returns**

**0** on success; **non-zero** otherwise.

##### **Parameters**

  - $1 __Required__ : The process name to kill.

##### **Examples**

`__hhs_process_kill -f Python`

**Output**

```bash
504	41441	40993	Python                                  => Killed "41441" with SIGKILL(-9)
```

------

#### __hhs_partitions

```bash
Usage: __hhs_partitions
```

##### **Purpose**

Exhibit a Human readable summary about all partitions.

##### **Returns**

**0** on success; **non-zero** otherwise.

##### **Parameters**

N/A

##### **Examples**

`__hhs_partitions`

```bash
Size	Avail	Used	Capacity	Mounted-ON
----------------------------------------------------------------
251G	14G  	9899	41%     	/
194k	0B   	194k	100%    	/dev
251G	14G  	2015	13%     	/System/Volumes/Preboot
251G	14G  	3222	19%     	/System/Volumes/VM
251G	14G  	11M 	1%      	/System/Volumes/Update
251G	14G  	220G	94%     	/System/Volumes/Data
0B  	0B   	0B  	100%    	/System/Volumes/Data/home
ippe	219G 	251G	16G     	1%
```
