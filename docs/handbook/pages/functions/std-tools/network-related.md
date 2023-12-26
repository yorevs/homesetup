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
Usage: __hhs_port_check <port_number> [port_state]

  Notes:
    States: One of [CLOSED|LISTEN|SYN_SENT|SYN_RCVD|ESTABLISHED|CLOSE_WAIT|LAST_ACK|FIN_WAIT_1|FIN_WAIT_2|CLOSING TIME_WAIT]
```

##### **Purpose**:

Check the state of local port(s).

##### **Returns**:

**0** on success; **non-zero** otherwise.

##### **Parameters**:

  - $1 _Required_ : The port number regex.
  - $2 _Optional_ : The port state to match.

##### **Examples:**

```bash
$ __hhs_port_check 8080
$ __hhs_port_check 8080 listen
```
