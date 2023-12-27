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

### __hhs_active_ifaces

```bash
Usage: __hhs_active_ifaces [-flat]
```

##### **Purpose**

Display a list of active network interfaces.

##### **Returns**

**0** on success; **non-zero** otherwise.

##### **Parameters**

  - $1 _Optional_ : Whether to flat the returned items.

##### **Examples**

`__hhs_active_ifaces`

**Output**

```bash
lo0         	MTU=16384   	flags=8049<UP,LOOPBACK,RUNNING,MULTICAST>
gif0        	MTU=1280    	flags=8010<POINTOPOINT,MULTICAST>
stf0        	MTU=1280    	flags=0<>
en3         	MTU=1500    	flags=8863<UP,BROADCAST,SMART,RUNNING,SIMPLEX,MULTICAST>
ap1         	MTU=1500    	flags=8843<UP,BROADCAST,RUNNING,SIMPLEX,MULTICAST>
en0         	MTU=1500    	flags=8863<UP,BROADCAST,SMART,RUNNING,SIMPLEX,MULTICAST>
...
...
```

`__hhs_active_ifaces -flat`

**Output**

```bash
en5 utun6 utun5 utun4 utun3 utun2 utun1 utun0 bridge0 en2 en1 llw0 awdl0 en0 ap1 en3 stf0 gif0 lo0
```

------

### __hhs_ip

```bash
Usage: __hhs_ip [kind]

    Arguments:
      type : The kind of IP to get. One of [local|external|gateway|vpn].

    Types:
         local : Get your local network IPv4.
      external : Get your external network IPv4.
       gateway : Get the IPv4 of your gateway.
           vpn : Get your IPv4 assigned by your VPN.

  Notes:
    - If no kind is specified, all ips assigned to the machine will be retrieved.
```

##### **Purpose**

Display the associated machine IP of the given kind.

##### **Returns**

**0** on success; **non-zero** otherwise.

##### **Parameters**

  - $1 _Optional_ : The kind of IP to get. One of [local|external|gateway|vpn].

##### **Examples**

`__hhs_ip`

**Output**

```bash
External  : 189.45.44.23
Gateway   : 192.168.100.1
en5       : 192.168.100.139
lo0       : 127.0.0.1
```

`__hhs_ip local`

**Output**

```bash
en5       : 192.168.100.139
```

------

### __hhs_ip_resolve

```bash
Usage: __hhs_ip_resolve <IPv4_address>
```

##### **Purpose**

Resolve domain names associated with the specified IP.

##### **Returns**

**0** on success; **non-zero** otherwise.

##### **Parameters**

  - $1 _Required_ : The IP address to resolve.

##### **Examples**

`__hhs_ip_resolve 8.8.8.8`

**Output**

```bash
dns.google.
```

------

### __hhs_ip_info

```bash
Usage: __hhs_ip_info <IPv4_address>
```

##### **Purpose**

Retrieve information about the specified IP.

##### **Returns**

**0** on success; **non-zero** otherwise.

##### **Parameters**

  - $1 _Required_ : The IP to get information about.

##### **Examples**

`__hhs_ip_info 8.8.8.8`

**Output**

```bash
{
  "status": "success",
  "country": "United States",
  "countryCode": "US",
  "region": "VA",
  "regionName": "Virginia",
  "city": "Ashburn",
  "zip": "20149",
  "lat": 39.03,
  "lon": -77.5,
  "timezone": "America/New_York",
  "isp": "Google LLC",
  "org": "Google Public DNS",
  "as": "AS15169 Google LLC",
  "query": "8.8.8.8"
}
```

------

### __hhs_ip_lookup

```bash
Usage: __hhs_ip_lookup <domain_name>
```

##### **Purpose**

Lookup DNS entries to determine the IP address.

##### **Returns**

**0** on success; **non-zero** otherwise.

##### **Parameters**

  $1 _Required_ : The domain name to lookup.

##### **Examples**

`__hhs_ip_lookup google.com`

**Output**

```bash
google.com has address 142.250.79.46
google.com has IPv6 address 2800:3f0:4004:80b::200e
google.com mail is handled by 10 smtp.google.com.
```

------

### __hhs_port_check

```bash
Usage: __hhs_port_check <port_number> [port_state] [protocol]

  Notes:
       States: One of [CLOSED|LISTEN|SYN_SENT|SYN_RCVD|ESTABLISHED|CLOSE_WAIT|LAST_ACK|FIN_WAIT_1|FIN_WAIT_2|CLOSING|TIME_WAIT].
    Wildcards: Use dots (.) as a wildcard. E.g: 80.. will match 80[0-9][0-9].

  Notes:
    - You can use the dot '.' as a wild card like: __hhs_port_check 8... will match 8[0-9][0-9][0-9].
    - You can use the dot '.' to match any state or protocol.
```

##### **Purpose**

Check the state of local port(s).

##### **Returns**

**0** on success; **non-zero** otherwise.

##### **Parameters**

  - $1 _Required_ : The port number regex.
  - $2 _Optional_ : The port state to match.

##### **Examples**

`__hhs_port_check 5...`

**Output**

```bash
Showing ports  Proto: [^(tcp|udp)] Number: [5***] State: [*]

Proto Recv-Q Send-Q  Local Address          Foreign Address        State

tcp4       0      0  192.168.100.139.65470  17.57.144.87.5223      ESTABLISHED
tcp4       0      0  192.168.100.139.62064  192.204.13.5.5091      ESTABLISHED
tcp6       0      0  *.5000                 *.*                    LISTEN
tcp4       0      0  *.5000                 *.*                    LISTEN
udp6       0      0  *.5353                 *.*
udp4       0      0  *.5353                 *.*
```

`__hhs_port_check 5... listen tcp`

**Output**

```bash
Showing ports  Proto: [tcp] Number: [5***] State: [LISTEN]

Proto Recv-Q Send-Q  Local Address          Foreign Address        State

tcp6       0      0  *.5000                 *.*                    LISTEN
tcp4       0      0  *.5000                 *.*                    LISTEN
```
