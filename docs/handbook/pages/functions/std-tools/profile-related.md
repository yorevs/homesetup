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


### Profile related functions

### __hhs_activate_nvm

```bash
Usage: __hhs_activate_nvm
```

##### **Purpose**:

Lazy load helper function to initialize NVM for the terminal.

##### **Returns**:

**0** on success; **non-zero** otherwise.

##### **Parameters**: -

##### **Examples:**

```bash
  $ __hhs_activate_nvm
```

------
### __hhs_activate_rvm

```bash
Usage: __hhs_activate_rvm
```

##### **Purpose**:

Lazy load helper function to initialize RVM for the terminal.

##### **Returns**:

**0** on success; **non-zero** otherwise.

##### **Parameters**: -

##### **Examples:**

```bash
  $ __hhs_activate_rvm
```

------
### __hhs_activate_jenv

```bash
Usage: __hhs_activate_jenv
```

##### **Purpose**:

Lazy load helper function to initialize Jenv for the terminal.

##### **Returns**:

**0** on success; **non-zero** otherwise.

##### **Parameters**: -

##### **Examples:**

```bash
  $ __hhs_activate_jenv
```

------
### __hhs_activate_docker

```bash
Usage: __hhs_activate_docker
```

##### **Purpose**:

Lazy load helper function to initialize Docker-Daemon for the terminal.

##### **Returns**:

**0** on success; **non-zero** otherwise.

##### **Parameters**: -

##### **Examples:**

```bash
  $ __hhs_activate_docker
```
