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


### Taylor tool

#### __hhs_tailor

```bash
usage: __hhs_tailor [-F | -f | -r] [-q] [-b # | -c # | -n #] <file>

  Notes:
    - filename: If not provided, /dev/stdin will be used instead
```

##### **Purpose**

Tail a log using colors and patterns specified on `.tailor' file.

##### **Returns**

**0** on success; **non-zero** otherwise.

##### **Parameters**

  $1 _Required_ : The log file name.

##### **Examples**

`__hhs_tailor /var/log/install.log`

**Output**

```bash
2023-12-28 16:30:15-03 localhost softwareupdated[93882]: Product 052-14528 is deferred until 2024-03-10 08:00:00 +0000
2023-12-28 16:30:15-03 localhost softwareupdated[93882]: Product 052-14644 is deferred until 2024-03-10 08:00:00 +0000
2023-12-28 16:30:15-03 localhost softwareupdated[93882]: Product 052-15153 is deferred until 2024-03-10 08:00:00 +0000
2023-12-28 16:30:15-03 localhost softwareupdated[93882]: Product 052-23678 is deferred until 2024-03-17 08:00:00 +0000
...
...
```
