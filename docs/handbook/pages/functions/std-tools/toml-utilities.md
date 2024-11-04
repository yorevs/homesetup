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

### TOML Utilities

#### __hhs_toml_get

```bash
usage: __hhs_toml_get <file> <key> [group]
```

##### **Purpose**

Get the key's value from a toml file.

##### **Returns**

**0** on success; **non-zero** otherwise.

##### **Parameters**

  - $1 _Required_ : The toml file read from.
  - $2 _Required_ : The key to get.
  - $3 _Optional_ : The group to get the key from (root if not provided).

##### **Examples**

`__hhs_toml_get bumpver.toml current_version`

**Output**

```bash
current_version=1.6.19
```

#### __hhs_toml_set

```bash
usage: __hhs_toml_set <file> <key=value> [group]
```

##### **Purpose**

Set the key's value from a toml file.

##### **Returns**

**0** on success; **non-zero** otherwise.

##### **Parameters**

  - $1 _Required_ : The toml file read from.
  - $2 _Required_ : The key to set on the form: key=value
  - $3 _Optional_ : The group to get the key from (root if not provided).

##### **Examples**

`__hhs_toml_set bumpver.toml current_version=1.6.20`

**Output**

```bash
current_version=1.6.19
```
