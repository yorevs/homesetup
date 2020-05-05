# HomeSetup Network Related Functions Handbook

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


### Network related functions

### __hhs_ip

```bash
Usage: __hhs_ip [kind]

    Arguments:
      type : The kind of IP to get. One of [local|external|gateway|vpn]

    Types:
         local : Get your local network IPv4
      external : Get your external network IPv4
       gateway : Get the IPv4 of your gateway
           vpn : Get your IPv4 assigned by your VPN

  Notes: 
    - If no kind is specified, all ips assigned to the machine will be retrieved
```

##### **Purpose**:

Display the associated machine IP of the given kind.

##### **Returns**:

**0** on success; **non-zero** otherwise.

##### **Parameters**:

  - $1 _Optional_ : The kind of IP to get. One of [local|external|gateway|vpn].

##### **Examples:**

```bash
  $ __hhs_ip local
  $ __hhs_ip gateway
```

------
### __hhs_ip_resolve

```bash
Usage: __hhs_ip_resolve <IPv4_address>
```

##### **Purpose**:

Resolve domain names associated with the specified IP.

##### **Returns**:

**0** on success; **non-zero** otherwise.

##### **Parameters**: 

  - $1 _Required_ : The IP address to resolve.

##### **Examples:**

```bash
  $ __hhs_ip_resolve 8.8.8.8 && echo "Resolved google DNS"
```


------
### __hhs_active_ifaces

```bash
Usage: __hhs_active_ifaces
```

##### **Purpose**:

Display a list of active network interfaces.

##### **Returns**:

**0** on success; **non-zero** otherwise.

##### **Parameters**: -

##### **Examples:**

```bash
$ __hhs_active_ifaces
```


------
### __hhs_ip_info

```bash
Usage: __hhs_ip_info <IPv4_address>
```

##### **Purpose**:

Retrieve information about the specified IP.

##### **Returns**:

**0** on success; **non-zero** otherwise.

##### **Parameters**: 

  - $1 _Required_ : The IP to get information about.

##### **Examples:**

```bash
$ __hhs_ip_info 8.8.8.8
```

------
### __hhs_ip_lookup

```bash
Usage: __hhs_ip_lookup <domain_name>
```

##### **Purpose**:

Lookup DNS entries to determine the IP address.

##### **Returns**:

**0** on success; **non-zero** otherwise.

##### **Parameters**: 

  $1 _Required_ : The domain name to lookup.

##### **Examples:**

```bash
$ __hhs_ip_lookup www.google.com
```

------
### __hhs_port_check

```bash
Usage: 
```

##### **Purpose**:

Usage: __hhs_port_check <port_number> [port_state]

  Notes:
    States: One of [ CLOSE_WAIT, ESTABLISHED, FIN_WAIT_2, TIME_WAIT, LISTEN ]

##### **Returns**:

**0** on success; **non-zero** otherwise.

##### **Parameters**: 

  - $1 _Required_ : The port number regex.
  - $2 _Optional_ : The port state to match. One of: [ CLOSE_WAIT, ESTABLISHED, FIN_WAIT_2, TIME_WAIT, LISTEN ].

##### **Examples:**

```bash
$ __hhs_port_check 8080
$ __hhs_port_check 8080 listen
```
